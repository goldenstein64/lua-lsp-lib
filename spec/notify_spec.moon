io_lsp = require 'lsp-lib.io'
notify = require 'lsp-lib.notify'

import MockProvider, notif_of from require 'spec.mocks.io'

describe 'lsp.notify', ->
	before_each ->
		io_lsp.provider = nil

	it 'writes notifications LSP I/O', ->
		provider = MockProvider!
		io_lsp.provider = provider

		thread = coroutine.create () -> notify 'window/logMessage', { message: "bar" }

		ok, err = coroutine.resume thread
		assert.truthy ok, err
		assert.thread_dead thread

		responses = provider\mock_decode_output!
		assert.same {
			notif_of 'window/logMessage', { message: "bar" }
		}, responses

	it 'errors when indexed with an unknown notification method', ->
		provider = MockProvider!
		io_lsp.provider = provider

		thread = coroutine.create () -> notify['$/unknownNotification']

		ok, err = coroutine.resume thread
		assert.falsy ok, err
		assert.thread_dead thread

		responses = provider\mock_decode_output!
		assert.same {}, responses

	it "doesn't error when indexed with a known notification method", ->
		provider = MockProvider!
		io_lsp.provider = provider

		thread = coroutine.create () ->
			notify['window/showMessage'] { message: 'telnet' }

		ok, err = coroutine.resume thread
		assert.truthy ok, err
		assert.thread_dead thread

		responses = provider\mock_decode_output!
		assert.same {
			notif_of 'window/showMessage', { message: 'telnet' }
		}, responses
