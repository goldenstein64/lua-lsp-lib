io_lsp = require 'lsp-lib.io'
notify = require 'lsp-lib.notify'
async = require 'lsp-lib.async'
MessageType = require 'lsp-lib.enum.MessageType'

import set_provider, notif_of from require 'spec.mocks.io'

describe 'lsp.notify', ->
	before_each ->
		io_lsp.provider = nil

	it 'writes notifications LSP I/O', ->
		provider = set_provider!

		thread, ok, err = async -> notify 'window/logMessage', { message: "bar" }
		assert.truthy ok, err
		assert.thread_dead thread

		responses = provider\mock_output!
		assert.same {
			notif_of 'window/logMessage', { message: "bar" }
		}, responses

	it 'errors when indexed with an unknown notification method', ->
		provider = set_provider!

		thread, ok, err = async -> notify['$/unknownNotification']
		assert.falsy ok, err
		assert.thread_dead thread

		responses = provider\mock_output!
		assert.same {}, responses

	it "doesn't error when indexed with a known notification method", ->
		provider = set_provider!

		thread, ok, err = async ->
			notify['window/showMessage'] { type: MessageType.Debug, message: 'foo' }

		assert.truthy ok, err
		assert.thread_dead thread

		responses = provider\mock_output!
		assert.same {
			notif_of 'window/showMessage', { type: MessageType.Debug, message: 'foo' }
		}, responses

	describe 'log', ->
		it 'sends a notification for each message type', ->
			provider = set_provider!

			for k in *{ 'debug', 'log', 'info', 'warn', 'error' }
				thread, ok, err = async -> notify.log[k] "#{k} message"
				assert.truthy ok, "log.#{k} errored: #{err}"
				assert.thread_dead thread, "log.#{k}'s thread wasn't dead"

			responses = provider\mock_output!
			assert.same {
				notif_of 'window/logMessage', { type: MessageType.Debug, message: 'debug message' }
				notif_of 'window/logMessage', { type: MessageType.Log, message: 'log message' }
				notif_of 'window/logMessage', { type: MessageType.Info, message: 'info message' }
				notif_of 'window/logMessage', { type: MessageType.Warning, message: 'warn message' }
				notif_of 'window/logMessage', { type: MessageType.Error, message: 'error message' }
			}, responses

	describe 'show', ->
		it 'sends a notification for each message type', ->
			provider = set_provider!

			for k in *{ 'debug', 'log', 'info', 'warn', 'error' }
				thread, ok, err = async -> notify.show[k] "#{k} message"
				assert.truthy ok, "show.#{k} errored: #{err}"
				assert.thread_dead thread, "show.#{k}'s thread wasn't dead"

			responses = provider\mock_output!
			assert.same {
				notif_of 'window/showMessage', { type: MessageType.Debug, message: 'debug message' }
				notif_of 'window/showMessage', { type: MessageType.Log, message: 'log message' }
				notif_of 'window/showMessage', { type: MessageType.Info, message: 'info message' }
				notif_of 'window/showMessage', { type: MessageType.Warning, message: 'warn message' }
				notif_of 'window/showMessage', { type: MessageType.Error, message: 'error message' }
			}, responses

	describe 'log_trace', ->
		it 'sends a $/logTrace notification', ->
			provider = set_provider!

			thread, ok, err = async -> notify.log_trace 'msg', true
			assert.truthy ok, err
			assert.thread_dead thread

			responses = provider\mock_output!
			assert.same {
				notif_of '$/logTrace', { message: 'msg', verbose: true }
			}, responses

