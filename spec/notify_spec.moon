io_lsp = require 'lsp-lib.io'
notify = require 'lsp-lib.notify'

import set_provider, notif_of from require 'spec.mocks.io'

describe 'lsp.notify', ->
	before_each ->
		io_lsp.provider = nil

	it 'writes notifications LSP I/O', ->
		provider = set_provider!

		thread = coroutine.create () -> notify 'window/logMessage', { message: "bar" }

		ok, err = coroutine.resume thread
		assert.truthy ok, err
		assert.thread_dead thread

		responses = provider\mock_output!
		assert.same {
			notif_of 'window/logMessage', { message: "bar" }
		}, responses

	it 'errors when indexed with an unknown notification method', ->
		provider = set_provider!

		thread = coroutine.create () -> notify['$/unknownNotification']

		ok, err = coroutine.resume thread
		assert.falsy ok, err
		assert.thread_dead thread

		responses = provider\mock_output!
		assert.same {}, responses

	it "doesn't error when indexed with a known notification method", ->
		provider = set_provider!

		thread = coroutine.create () ->
			notify['window/showMessage'] { message: 'foo' }

		ok, err = coroutine.resume thread
		assert.truthy ok, err
		assert.thread_dead thread

		responses = provider\mock_output!
		assert.same {
			notif_of 'window/showMessage', { message: 'foo' }
		}, responses
