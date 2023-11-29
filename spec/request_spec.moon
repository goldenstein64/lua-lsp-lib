import null from require 'cjson'

io_lsp = require 'lsp-lib.io'
listen = require 'lsp-lib.listen'
request = require 'lsp-lib.request'
request_state = require 'lsp-lib.request.state'

import MockProvider, request_of from require 'spec.mocks.io'

describe 'lsp.request', ->
	before_each ->
		request_state.waiting_threads[k] = nil for k in pairs request_state.waiting_threads
		request_state.waiting_requests[k] = nil for k in pairs request_state.waiting_requests

	it 'can make a request which yields the current thread', ->
		provider = MockProvider!
		io_lsp.provider = provider

		thread = coroutine.create () -> request '$/customRequest', null

		ok, err = coroutine.resume thread
		assert.truthy ok, err
		assert.thread_suspended thread

		assert.equal thread, (select 2, next request_state.waiting_threads)

		responses = provider\mock_decode_output!
		assert.same {
			request_of 1, '$/customRequest', null
		}, responses

	it 'succeeds when indexing with a known request', ->
		io_lsp.provider = MockProvider!
		thread = coroutine.create () -> request['workspace/configuration'] null

		ok, err = coroutine.resume thread
		assert.truthy ok, err
		assert.thread_suspended thread

	it 'errors when indexing with an unknown request', ->
		io_lsp.provider = MockProvider!
		thread = coroutine.create () -> request['$/unknownRequest'] null

		ok, err = coroutine.resume thread
		assert.falsy ok, err
		assert.thread_dead thread
