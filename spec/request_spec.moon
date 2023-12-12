import null from require 'cjson'

ErrorCodes = require 'lsp-lib.enum.ErrorCodes'
MessageType = require 'lsp-lib.enum.MessageType'
io_lsp = require 'lsp-lib.io'
listen = require 'lsp-lib.listen'
request = require 'lsp-lib.request'
request_state = require 'lsp-lib.request.state'
async = require 'lsp-lib.async'

import
	set_provider, MockProvider
	request_of, response_of
from require 'spec.mocks.io'

describe 'lsp.request', ->
	before_each ->
		{ :waiting_threads, :waiting_requests } = request_state
		request_state.id = 1
		waiting_threads[k] = nil for k in pairs waiting_threads
		waiting_requests[k] = nil for k in pairs waiting_requests

	it 'can make a request which yields the current thread', ->
		provider = set_provider!

		thread, ok, err = async -> request '$/customRequest', null
		assert.truthy ok, err
		assert.thread_suspended thread

		assert.equal thread, (select 2, next request_state.waiting_threads)

		responses = provider\mock_output!
		assert.same {
			request_of 1, '$/customRequest', null
		}, responses

	it 'succeeds when indexing with a known request', ->
		set_provider!
		thread, ok, err = async -> request['workspace/configuration'] null
		assert.truthy ok, err
		assert.thread_suspended thread

	it 'errors when indexing with an unknown request', ->
		set_provider!
		thread, ok, err = async -> request['$/unknownRequest'] null
		assert.falsy ok, err
		assert.thread_dead thread

	describe 'show.*', ->
		it 'can show a message for each message type', ->
			provider = set_provider!
			for k in *{ 'debug', 'log', 'info', 'warn', 'error' }
				thread, ok, err = async -> request.show[k] "#{k} message"
				assert.truthy ok, err
				assert.thread_suspended thread

			responses = provider\mock_output!
			assert.same {
				request_of 1, 'window/showMessageRequest', {
					type: MessageType.Debug
					message: 'debug message'
				}
				request_of 2, 'window/showMessageRequest', {
					type: MessageType.Log
					message: 'log message'
				}
				request_of 3, 'window/showMessageRequest', {
					type: MessageType.Info
					message: 'info message'
				}
				request_of 4, 'window/showMessageRequest', {
					type: MessageType.Warning
					message: 'warn message'
				}
				request_of 5, 'window/showMessageRequest', {
					type: MessageType.Error
					message: 'error message'
				}
			}, responses

		it 'can take a list of choices and return one', ->
			provider = set_provider {
				response_of 1, { title: 'Yes' }
			}

			local choice
			thread, ok, err = async ->
				choice = request.show.info 'foo?', 'Yes', 'No'

			assert.truthy ok, err
			assert.thread_suspended thread

			listen.once!

			assert.thread_dead thread

			responses = provider\mock_output!
			assert.same {
				request_of 1, 'window/showMessageRequest', {
					type: MessageType.Info
					message: 'foo?'
					actions: { { title: 'Yes' }, { title: 'No' } }
				}
			}, responses
			assert.equal 'Yes', choice

		it 'can take a list of choices and return nothing', ->
			provider = set_provider {
				response_of 1, null
			}

			local choice
			thread, ok, err = async ->
				choice = request.show.info 'foo?', 'Yes', 'No'

			assert.truthy ok, err
			assert.thread_suspended thread

			listen.once!

			assert.thread_dead thread

			responses = provider\mock_output!
			assert.same {
				request_of 1, 'window/showMessageRequest', {
					type: MessageType.Info
					message: 'foo?'
					actions: { { title: 'Yes' }, { title: 'No' } }
				}
			}, responses
			assert.equal null, choice

		it 'can error', ->
			provider = set_provider {
				response_of 1, nil, {
					code: ErrorCodes.InternalError
					message: 'int overflow'
				}
			}

			local choice, response_err
			thread, ok, err = async ->
				choice, response_err = request.show.info 'foo?', 'Yes', 'No'

			assert.truthy ok, err
			assert.thread_suspended thread

			listen.once!

			assert.thread_dead thread

			responses = provider\mock_output!
			assert.same {
				request_of 1, 'window/showMessageRequest', {
					type: MessageType.Info
					message: 'foo?'
					actions: { { title: 'Yes' }, { title: 'No' } }
				}
			}, responses
			assert.is_nil choice
			assert.same {
				code: ErrorCodes.InternalError
				message: 'int overflow'
			}, response_err
