import null from require 'cjson'

io_lsp = require 'lsp-lib.io'
listen = require 'lsp-lib.listen'
response = require 'lsp-lib.response'
request = require 'lsp-lib.request'
request_state = require 'lsp-lib.request.state'
import waiting_threads, waiting_requests from request_state

match = require 'luassert.match'
spy = require 'luassert.spy'
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
			stringify = spy (params) -> { returned: tostring params.arg }

			io_lsp.provider = provider

			listen.routes = {
				'$/stringify': stringify
			}

			listen.once!

			assert.spy(stringify).called 1
			assert.spy(stringify).called_with match.is_same { arg: 97 }

			responses = provider\mock_decode_output!
			assert.same {
				response_of 1, { returned: '97' }
			}, responses

		it 'resumes its thread when a response is received', ->
			provider = MockProvider {
				request_of 5, '$/startWait', null
				response_of 1, { returned: 'value' }
			}
			io_lsp.provider = provider

			waiting = spy ->
				ok, result = request '$/waiting', null
				{ :ok, :result }

			listen.routes = {
				'$/startWait': waiting
			}

			listen.once!

			assert.spy(waiting).called 1
			assert.spy(waiting).called_with null

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

			responses = provider\mock_decode_output!
			assert.same {
				request_of 1, '$/waiting', null
				response_of 5, { ok: true, result: { returned: 'value' } }
			}, responses

		it 'resumes non-response threads that made a request', ->
			provider = MockProvider {
				request_of 5, '$/spawnWaiting', null
				response_of 1, { returned: true }
			}
			io_lsp.provider = provider

			local config

			spawn_waiting = spy ->
				thread = coroutine.create ->
					ok, result = request '$/waiting', null
					assert.truthy ok, result
					config = result

				coroutine.resume thread
				null

			listen.routes = {
				'$/spawnWaiting': spawn_waiting
			}

			listen.once!

			responses = provider\mock_decode_output!
			assert.same {
				request_of 1, '$/waiting', null
				response_of 5, null
			}, responses

			assert.is_nil config

			listen.once!

			assert.same { returned: true }, config

