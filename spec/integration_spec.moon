import concat from table

json = require 'cjson'
import null from json

lsp = require 'lsp-lib'
ioLSP = require 'lsp-lib.io'
ioLSP.provider = nil

import
	MockProvider
	request_of, notif_of, response_of
from require 'spec.helpers.mock_io'

describe 'integration', ->
	after_each ->
		ioLSP.provider = nil
		lsp.response[k] = nil for k in pairs lsp.response

	initialize_request = (id) ->
		request_of id, 'initialize', {
			processId: null
			rootUri: null
			capabilities: {}
		}

	shutdown_request = (id) -> request_of id, 'shutdown', null

	exit_notif = notif_of 'exit', null

	run = ->
		thread = coroutine.create lsp.listen
		ok = coroutine.resume thread, false
		assert.is_true ok
		thread

	it 'works', ->
		provider = MockProvider {
			initialize_request 1
			shutdown_request 2
			exit_notif
		}
		ioLSP.provider = provider

		thread = run!
		assert.equal 'dead', coroutine.status thread

		responses = provider\mock_decode_output!
		assert.equal 2, #responses
		assert.same response_of(1, { capabilities: {} }), responses[1]
		assert.same response_of(2, null), responses[2]

	it 'calls my custom function when requested', ->
		provider = MockProvider {
			initialize_request 1
			request_of 2, '$/customRequest', { test_prop: 'test value' }
			shutdown_request 3
			exit_notif
		}
		ioLSP.provider = provider

		lsp.response['$/customRequest'] = (params) -> { returned: params.test_prop }

		thread = run!
		assert.equal 'dead', coroutine.status thread

		responses = provider\mock_decode_output!
		assert.equal 3, #responses
		assert.same response_of(1, { capabilities: {} }), responses[1]
		assert.same response_of(2, { returned: 'test value' }), responses[2]
		assert.same response_of(3, null), responses[3]
