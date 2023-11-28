import null from require 'cjson'

io_lsp = require 'lsp-lib.io'
handle = require 'lsp-lib.handle'
request = require 'lsp-lib.request'

import MockProvider, request_of from require 'spec.mocks.io'

describe 'lsp.request', ->
	before_each ->
		handle.waiting_threads[k] = nil for k in pairs handle.waiting_threads
		handle.waiting_thread_to_req[k] = nil for k in pairs handle.waiting_thread_to_req

	it 'can make a request which yields the current thread', ->
		provider = MockProvider!
		io_lsp.provider = provider

		thread = coroutine.create () -> request '$/customRequest', null

		ok, result = coroutine.resume thread
		assert.truthy ok, result
		assert.thread_suspended thread

		assert.equal thread, (select 2, next handle.waiting_threads)

		responses = provider\mock_decode_output!
		assert.same {
			request_of 1, '$/customRequest', null
		}, responses

	it 'succeeds when indexing with a known request #only', ->
		io_lsp.provider = MockProvider!
		thread = coroutine.create () -> request['workspace/configuration'] null

		ok, result = coroutine.resume thread
		assert.truthy ok, result
		assert.thread_suspended thread

	it 'errors when indexing with an unknown request', ->
		io_lsp.provider = MockProvider!
		thread = coroutine.create () -> request['$/unknownRequest'] null

		ok, result = coroutine.resume thread
		assert.falsy ok
		assert.thread_dead thread
