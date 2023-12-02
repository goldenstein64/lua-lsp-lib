import null from require 'cjson'

spy = require 'luassert.spy'
import types from require 'tableshape'

MessageType = require 'lsp-lib.enum.MessageType'
ErrorCodes = require 'lsp-lib.enum.ErrorCodes'

io_lsp = require 'lsp-lib.io'
listen = require 'lsp-lib.listen'
response = require 'lsp-lib.response'
request = require 'lsp-lib.request'
request_state = require 'lsp-lib.request.state'
async = require 'lsp-lib.async'
import waiting_threads, waiting_requests from request_state

import
	MockProvider
	request_of, response_of, notif_of
from require 'spec.mocks.io'

describe 'lsp.listen', ->
	before_each ->
		listen.state = 'default'
		listen.running = true
		listen.routes = response

		request_state.id = 1
		waiting_threads[k] = nil for k in pairs waiting_threads
		waiting_requests[k] = nil for k in pairs waiting_requests

		io_lsp.provider = nil

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
			provider = MockProvider {
				request_of 1, '$/stringify', { arg: 97 }
			}
			io_lsp.provider = provider

			stringify = spy (params) -> { returned: tostring params.arg }
			listen.routes = {
				'$/stringify': stringify
			}

			listen.once!

			assert.spy(stringify).called 1
			assert.spy(stringify).called_with match.is_same { arg: 97 }

			responses = provider\mock_output!
			assert.same {
				response_of 1, { returned: '97' }
			}, responses

		describe 'when handling responses', ->
			describe 'for routing threads with a request', ->
				it 'resumes when a response is received', ->
					provider = MockProvider {
						request_of 5, '$/startWait', null
						response_of 1, { returned: 'value' }
					}
					io_lsp.provider = provider

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

					assert.is_nil next waiting_threads
					assert.is_nil next waiting_requests

					assert.spy(waiting).called 1

					responses = provider\mock_output!
					assert.same {
						request_of 1, '$/waiting', null
						response_of 5, { result: { returned: 'value' } }
					}, responses

				it 'handles messy errors', ->
					provider = MockProvider {
						request_of 5, '$/startWait', null
						response_of 1, { returned: 'value' }
					}
					io_lsp.provider = provider

					listen.routes = {
						'$/startWait': ->
							ok, result = request '$/waiting', null
							error 'something went wrong'
					}

					listen.once!
					listen.once!

					responses = provider\mock_output!
					assert.shape responses, types.shape {
						types.shape request_of 1, '$/waiting', null
						types.shape notif_of 'window/logMessage', types.shape {
							type: MessageType.Error
							message: types.pattern '^request error: something went wrong'
						}
						types.shape response_of 5, nil, types.shape {
							code: ErrorCodes.InternalError
							message: types.pattern '^something went wrong'
						}
					}

				set_provider = ->
					provider = MockProvider {
			describe 'for anonymous threads with a request', ->
						request_of 5, '$/spawnWaiting', null
						response_of 1, { returned: 'value' }
					}
					io_lsp.provider = provider
					provider

				it 'resumes those that made a request', ->
					provider = set_provider!

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
					assert.same {
						request_of 1, '$/waiting', null
						response_of 5, null
					}, responses

					assert.is_nil config

					listen.once!

					assert.same { returned: 'value' }, config

				it 'handles errors', ->
					provider = set_provider!

					listen.routes = {
						'$/spawnWaiting': ->
							async ->
								result, err = request '$/waiting', null
								error 'non-response thread errored'

							null
					}

					listen.once!
					listen.once!

					assert.same {
						request_of 1, '$/waiting', null
						response_of 5, null
						notif_of 'window/logMessage', {
					responses = provider\mock_output!
							type: MessageType.Error,
							message: 'non-response thread errored'
						}
					}, responses

