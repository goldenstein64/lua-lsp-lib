io_lsp = require 'lsp-lib.io'
notify = require 'lsp-lib.notify'

import MockProvider, notif_of from require 'spec.mocks.io'

describe 'lsp.notify', ->
	it 'writes notifications LSP I/O', ->
		provider = MockProvider!
		io_lsp.provider = provider

		thread = coroutine.create () -> notify 'window/logMessage', { message: "bar" }

		ok, result = coroutine.resume thread
		assert.truthy ok
		assert.thread_dead thread

		responses = provider\mock_decode_output!
		assert.same {
			notif_of 'window/logMessage', { message: "bar" }
		}, responses
