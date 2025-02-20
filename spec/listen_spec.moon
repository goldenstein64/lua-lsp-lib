import null from require 'cjson'

spy = require 'luassert.spy'
import types from require 'tableshape'
import shape from types

MessageType = require 'lsp-lib.enum.MessageType'
ErrorCodes = require 'lsp-lib.enum.ErrorCodes'
LSPErrorCodes = require 'lsp-lib.enum.LSPErrorCodes'

io_lsp = require 'lsp-lib.io'
listen = require 'lsp-lib.listen'
response = require 'lsp-lib.response'
request = require 'lsp-lib.request'
request_state = require 'lsp-lib.request.state'
async = require 'lsp-lib.async'
import waiting_threads, waiting_requests from request_state

import
	set_provider
	request_of, response_of, notif_of
	initialize_request, shutdown_request, exit_notif
from require 'spec.mocks.io'

import
	request_shape, response_shape, notif_shape
from require 'spec.mocks.message_shapes'

listen_async = require 'spec.helper.listen_async'

notif_error = (message=types.string) ->
	notif_shape 'window/logMessage', { type: MessageType.Error, :message }

describe 'lsp.listen', ->
	before_each ->
		listen.state = 'default'
		listen.running = true
		listen.routes = response

		request_state.id = 1
		waiting_threads[k] = nil for k in pairs waiting_threads
		waiting_requests[k] = nil for k in pairs waiting_requests

		io_lsp.provider = nil

	describe 'routes', ->
		it 'defaults to lsp.response', ->
			assert.equal response, listen.routes

	describe 'once', ->
		it 'calls the handler corresponding to its state', ->
			listen.state = 'foo_bar'
			s = spy ->
			listen.handlers['foo_bar'] = s

			listen.once!

			assert.spy(s).called 1
			assert.spy(s).called.with()

			-- teardown
			listen.handlers['foo_bar'] = nil

		it 'errors in an unknown state', ->
			listen.state = 'unknown'
			assert.error -> listen.once!

		it 'indexes routes when called', ->
			provider = set_provider {
				request_of 1, '$/stringify', { arg: 97 }
			}

			stringify = spy (params) -> { returned: tostring params.arg }
			listen.routes = {
				'$/stringify': stringify
			}

			listen.once!

			assert.spy(stringify).called 1
			assert.spy(stringify).called_with match.is_same { arg: 97 }

			responses = provider\mock_output!
			assert.shape responses, shape {
				response_shape 1, { returned: '97' }
			}

		describe 'when in "initialize" state', ->
			before_each -> listen.state = 'initialize'

			it 'transitions to "default" on "initialize"', ->
				provider = set_provider {
					request_of 1, 'initialize', {
						processId: null
						rootUri: null
						capabilities: {}
					}
				}

				init_handler = spy (params) -> { capabilities: {} }
				listen.routes = {
					'initialize': init_handler
				}

				listen.once!

				assert.equal 'default', listen.state

				assert.spy(init_handler).called 1
				assert.spy(init_handler).called_with match.is_same {
					processId: null
					rootUri: null
					capabilities: {}
				}

				responses = provider\mock_output!
				assert.shape responses, shape {
					response_shape 1, { capabilities: shape {} }
				}

			it 'exits on "exit"', ->
				provider = set_provider {
					notif_of 'exit'
				}

				exit_handler = spy (params) -> nil
				listen.routes = {
					'exit': exit_handler
				}

				listen.once!

				assert.is_false listen.running

				assert.spy(exit_handler).called 1
				assert.spy(exit_handler).called_with nil

				responses = provider\mock_output!
				assert.shape responses, shape {}

			it 'sends a response error on any other request', ->
				provider = set_provider {
					request_of 1, '$/random', null
				}

				random_handler = spy () -> 'bar'
				listen.routes = {
					'$/random': random_handler
				}

				listen.once!

				assert.is_true listen.running
				assert.equal 'initialize', listen.state

				assert.spy(random_handler).not_called!

				responses = provider\mock_output!
				assert.shape responses, shape {
					response_shape 1, nil, {
						code: ErrorCodes.ServerNotInitialized
						message: 'Server Not Initialized'
					}
				}

			it 'drops any other notification', ->
				provider = set_provider {
					notif_of '$/random', null
				}

				random_handler = spy () -> 'bar'
				listen.routes = {
					'$/random': random_handler
				}

				listen.once!

				assert.is_true listen.running
				assert.equal 'initialize', listen.state

				assert.spy(random_handler).not_called!

				responses = provider\mock_output!
				assert.shape responses, shape {}

		describe 'when in "shutdown" state', ->
			before_each -> listen.state = 'shutdown'

			it 'exits on "exit"', ->
				provider = set_provider {
					notif_of 'exit'
				}

				exit_handler = spy (params) -> nil
				listen.routes = {
					'exit': exit_handler
				}

				listen.once!

				assert.is_false listen.running

				assert.spy(exit_handler).called 1
				assert.spy(exit_handler).called_with nil

				responses = provider\mock_output!
				assert.shape responses, shape {}

			it 'sends a response error on any other request', ->
				provider = set_provider {
					request_of 1, '$/random', null
				}

				random_handler = spy () -> 'bar'
				listen.routes = {
					'$/random': random_handler
				}

				listen.once!

				assert.is_true listen.running
				assert.equal 'shutdown', listen.state

				assert.spy(random_handler).not_called!

				responses = provider\mock_output!
				assert.shape responses, shape {
					response_shape 1, nil, {
						code: ErrorCodes.InvalidRequest
						message: "Invalid Request: '$/random'"
					}
				}

			it 'drops any other notification', ->
				provider = set_provider {
					notif_of '$/random', null
				}

				random_handler = spy () -> 'bar'
				listen.routes = {
					'$/random': random_handler
				}

				listen.once!

				assert.is_true listen.running
				assert.equal 'shutdown', listen.state

				assert.spy(random_handler).not_called!

				responses = provider\mock_output!
				assert.shape responses, shape {}

		describe 'when handling responses from routes', ->
			it 'handles requests successfully', ->
				provider = set_provider {
					request_of 5, '$/greet', { name: 'Bob' }
				}

				listen.routes = {
					'$/greet': (params) ->
						{ message: "Hello, #{params.name}." }
				}

				listen.once!

				responses = provider\mock_output!
				assert.shape responses, shape {
					response_shape 5, { message: 'Hello, Bob.' }
				}

			it 'handles notifications successfully', ->
				provider = set_provider {
					notif_of '$/event', { type: 'string' }
				}

				local ev_type
				listen.routes = {
					'$/event': (params) -> ev_type = params.type
				}

				listen.once!

				responses = provider\mock_output!
				assert.shape responses, shape {} -- responses should be empty
				assert.equal 'string', ev_type

			it 'errors when a notification is responded to', ->
				provider = set_provider {
					notif_of '$/event', { type: 'string' }
				}

				listen.routes = { '$/event': -> null }

				listen.once!

				responses = provider\mock_output!
				assert.shape responses, shape { notif_error! }

			it 'errors when a notification is not implemented', ->
				provider = set_provider {
					notif_of '$/event', { type: 'string' }
				}

				listen.routes = {}

				listen.once!

				responses = provider\mock_output!
				assert.shape responses, shape { notif_error! }

			it 'errors when a request is not responded to', ->
				provider = set_provider {
					request_of 5, '$/customRequest', null
				}

				listen.routes = {
					'$/customRequest': -> nil
				}

				listen.once!

				responses = provider\mock_output!
				assert.shape responses, shape {
					notif_error!
					response_shape 5, nil, {
						code: ErrorCodes.InternalError
						message: types.string
					}
				}

			it 'errors when a request is not implemented', ->
				provider = set_provider {
					request_of 5, '$/customRequest', null
				}

				listen.routes = {}

				listen.once!

				responses = provider\mock_output!
				assert.shape responses, shape {
					notif_error!
					response_shape 5, nil, {
						code: ErrorCodes.MethodNotFound
						message: types.string
					}
				}

		describe 'when handling responses from the client', ->
			describe 'for routing threads with a request', ->
				it 'resumes when a response is received', ->
					provider = set_provider {
						request_of 5, '$/startWait', null
						response_of 1, { returned: 'value' }
					}

					waiting = spy ->
						result, err = request '$/waiting', null
						{ :result, :err }

					listen.routes = {
						'$/startWait': waiting
					}

					listen.once!

					assert.spy(waiting).called 1

					thread = waiting_threads[1]
					assert.is_thread thread
					assert.same(
						request_of 5, '$/startWait', null
						waiting_requests[thread]
					)

					listen.once!

					assert.shape waiting_threads, shape {}
					assert.shape waiting_requests, shape {}

					assert.spy(waiting).called 1

					responses = provider\mock_output!
					assert.shape responses, shape {
						request_shape 1, '$/waiting', null
						response_shape 5, { result: shape { returned: 'value' } }
					}

				it 'handles messy errors', ->
					provider = set_provider {
						request_of 5, '$/startWait', null
						response_of 1, { returned: 'value' }
					}

					listen.routes = {
						'$/startWait': ->
							ok, result = request '$/waiting', null
							error 'something went wrong'
					}

					listen.once!
					listen.once!

					responses = provider\mock_output!
					assert.shape responses, shape {
						request_shape 1, '$/waiting', null
						notif_error!
						response_shape 5, nil, {
							code: ErrorCodes.InternalError
							message: types.string
						}
					}

				it 'handles messy table errors', ->
					provider = set_provider {
						request_of 5, '$/startWait', null
						response_of 1, { returned: 'value' }
					}

					listen.routes = {
						'$/startWait': ->
							result, err = request '$/waiting', null
							error { '???' }
					}

					listen.once!
					listen.once!

					responses = provider\mock_output!
					assert.shape responses, shape {
						request_shape 1, '$/waiting', null
						notif_error!
						response_shape 5, nil, {
							code: ErrorCodes.InternalError
							message: types.string
						}
					}

				it 'handles graceful errors', ->
					provider = set_provider({
						request_of 5, '$/startWait', null
						response_of 1, { returned: 'value' }
					})

					err_msg = 'an error occurred'
					listen.routes = {
						'$/startWait': ->
							result, err = request '$/waiting', null
							error {
								code: LSPErrorCodes.RequestFailed
								message: err_msg
							}
					}

					listen.once!
					listen.once!

					responses = provider\mock_output!
					assert.shape responses, shape {
						request_shape 1, '$/waiting', null
						notif_error!
						response_shape 5, nil, {
							code: LSPErrorCodes.RequestFailed
							message: err_msg
						}
					}

			describe 'for anonymous threads with a request', ->
				it 'resumes when a response is received', ->
					provider = set_provider {
						request_of 5, '$/spawnWaiting', null
						response_of 1, { returned: 'value' }
					}

					local config
					listen.routes = {
						'$/spawnWaiting': ->
							async ->
								result, err = request '$/waiting', null
								assert.truthy result, err
								config = result

							null
					}

					listen.once!

					responses = provider\mock_output!
					assert.shape responses, shape {
						request_shape 1, '$/waiting', null
						response_shape 5, null
					}

					assert.is_nil config

					listen.once!

					assert.same { returned: 'value' }, config

				it 'handles errors', ->
					provider = set_provider {
						request_of 5, '$/spawnWaiting', null
						response_of 1, { returned: 'value' }
					}

					err_msg = 'non-response thread errored'
					listen.routes = {
						'$/spawnWaiting': ->
							async ->
								result, err = request '$/waiting', null
								error err_msg

							null
					}

					listen.once!
					listen.once!

					responses = provider\mock_output!
					assert.shape responses, shape {
						request_shape 1, '$/waiting', null
						response_shape 5, null
						notif_error err_msg
					}

	describe 'call', ->
		it 'errors when exiting initialize state', ->
			provider = set_provider { exit_notif }

			thread, ok, reason = listen_async!
			assert.is_false ok
			assert.thread_dead thread

			responses = provider\mock_output!
			assert.shape responses, shape {}

		it 'errors when exiting default state', ->
			provider = set_provider {
				initialize_request 1
				exit_notif
			}

			thread, ok, reason = listen_async!
			assert.is_false ok
			assert.thread_dead thread

			responses = provider\mock_output!
			assert.shape responses, shape {
				response_shape 1, { capabilities: shape {} }
			}
