import concat from table

json = require 'cjson'
import null from json

lsp = require 'lsp-lib'
io_lsp = require 'lsp-lib.io'
io_lsp.provider = nil

import
	MockProvider
	request_of, notif_of, response_of
from require 'spec.mocks.io'

describe 'the system', ->
	before_each ->
		io_lsp.provider = nil
		lsp.response[k] = nil for k in pairs lsp.response

	initialize_request = (id) ->
		request_of id, 'initialize', {
			processId: null
			rootUri: null
			capabilities: {}
		}

	shutdown_request = (id) -> request_of id, 'shutdown', null

	exit_notif = notif_of 'exit', null

	listen = do
		listen_wrapper = (...) -> lsp.listen ...
		->
			thread = coroutine.create listen_wrapper
			ok, reason = coroutine.resume thread, false
			assert.is_true ok, reason
			thread

	it 'works', ->
		provider = MockProvider {
			initialize_request 1
			shutdown_request 2
			exit_notif
		}
		io_lsp.provider = provider

		thread = listen!
		assert.thread_dead thread

		responses = provider\mock_decode_output!
		assert.same {
			response_of 1, { capabilities: {} }
			response_of 2, null
		}, responses

	it 'works with string ids', ->
		provider = MockProvider {
			initialize_request 'init'
			shutdown_request 'stop'
			exit_notif
		}
		io_lsp.provider = provider

		thread = listen!
		assert.thread_dead thread

		responses = provider\mock_decode_output!
		assert.same {
			response_of 'init', { capabilities: {} }
			response_of 'stop', null
		}, responses

	it 'calls my custom function when requested', ->
		provider = MockProvider {
			initialize_request 1
			request_of 2, '$/customRequest', { test_prop: 'test value' }
			shutdown_request 3
			exit_notif
		}
		io_lsp.provider = provider

		lsp.response['$/customRequest'] = (params) -> { returned: params.test_prop }

		thread = listen!
		assert.thread_dead thread

		responses = provider\mock_decode_output!
		assert.same {
			response_of 1, { capabilities: {} }
			response_of 2, { returned: 'test value' }
			response_of 3, null
		}, responses

	it 'waits for a request asynchronously', ->
		provider = MockProvider {
			initialize_request 1
			request_of 2, '$/asyncRequest', null
			request_of 3, '$/noop', null
			response_of 1, { test_prop: 'foo' }
			shutdown_request 4
			exit_notif
		}
		io_lsp.provider = provider

		lsp.response['$/noop'] = (params) -> null

		lsp.response['$/asyncRequest'] = (params) ->
			ok, result = lsp.request '$/pendingRequest', null
			{ :ok, :result }

		thread = listen!
		assert.thread_dead thread

		responses = provider\mock_decode_output!
		assert.same {
			response_of 1, { capabilities: {} } -- initialize
			-- receives '$/asyncRequest'
			request_of 1, '$/pendingRequest', null
			response_of 3, null -- '$/noop' is responded to in the meantime
			response_of 2, { ok: true, result: { test_prop: 'foo' } } -- $/asyncRequest
			response_of 4, null -- shutdown
		}, responses
