io_lsp = require 'lsp-lib.io'
notify = require 'lsp-lib.notify'

MessageType = require 'lsp-lib.enum.MessageType'
DiagnosticSeverity = require 'lsp-lib.enum.DiagnosticSeverity'

transform_range = require 'lsp-lib.transform.range'

import set_provider, notif_of from require 'spec.mocks.io'

describe 'lsp.notify', ->
	before_each ->
		io_lsp.provider = nil

	it 'writes notifications to LSP I/O', ->
		provider = set_provider!

		notify 'window/logMessage', { type: MessageType.Debug, message: "bar" }

		responses = provider\mock_output!
		assert.same {
			notif_of 'window/logMessage', { type: MessageType.Debug, message: "bar" }
		}, responses

	it 'errors when indexed with an unknown notification method', ->
		assert.error -> notify['$/unknownNotification']

	it "doesn't error when indexed with a known notification method", ->
		provider = set_provider!

		assert.no_error ->
			notify['window/showMessage'] { type: MessageType.Debug, message: 'foo' }

		responses = provider\mock_output!
		assert.same {
			notif_of 'window/showMessage', { type: MessageType.Debug, message: 'foo' }
		}, responses

	describe 'log', ->
		it 'sends a notification for each message type', ->
			provider = set_provider!

			for k in *{ 'debug', 'log', 'info', 'warn', 'error' }
				notify.log[k] "#{k} message"

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
				notify.show[k] "#{k} message"

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

			notify.log_trace 'msg', true

			responses = provider\mock_output!
			assert.same {
				notif_of '$/logTrace', { message: 'msg', verbose: true }
			}, responses

	describe 'telemetry', ->
		it 'sends a telemetry/event notification', ->
			provider = set_provider!

			notify.telemetry { anything: 'foobar' }

			responses = provider\mock_output!
			assert.same {
				notif_of 'telemetry/event', { anything: 'foobar' }
			}, responses

	describe 'progress', ->
		it 'sends a $/progress notification', ->
			provider = set_provider!

			notify.progress 493, 'qux'

			responses = provider\mock_output!
			assert.same {
				notif_of '$/progress', { token: 493, value: 'qux' }
			}, responses

	describe 'cancel_request', ->
		it 'sends a $/cancelRequest notification', ->
			provider = set_provider!

			notify.cancel_request 1

			responses = provider\mock_output!
			assert.same {
				notif_of '$/cancelRequest', { id: 1 }
			}, responses

	describe 'diagnostics', ->
		it 'sends a textDocument/publishDiagnostics notification', ->
			provider = set_provider!

			notify.diagnostics(
				'file:///home/me/doc/test.txt'
				{
					{
						range: transform_range.to_lsp 'abcd', 1, 4
						message: 'unknown character'
						code: 'UnknownChar'
						severity: DiagnosticSeverity.Error
						data: { thud: 'baz' }
					}
				}
				10
			)

			responses = provider\mock_output!
			assert.same {
				notif_of 'textDocument/publishDiagnostics', {
					uri: 'file:///home/me/doc/test.txt'
					diagnostics: {
						{
							range: {
								start: { line: 0, character: 0 }
								'end': { line: 0, character: 4 }
							}
							message: 'unknown character'
							code: 'UnknownChar'
							severity: DiagnosticSeverity.Error
							data: { thud: 'baz' }
						}
					}
					version: 10
				}
			}, responses
