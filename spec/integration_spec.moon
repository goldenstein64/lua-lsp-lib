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

describe 'the system', ->
	before_each ->
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

	listen = ->
		thread = coroutine.create lsp.listen
		ok, reason = coroutine.resume thread, false
		assert.is_true ok, reason
		thread

	it 'works', ->
		provider = MockProvider {
			initialize_request 1
			shutdown_request 2
			exit_notif
		}
		ioLSP.provider = provider

		thread = listen!
		assert.equal 'dead', coroutine.status thread

		responses = provider\mock_decode_output!
		assert.same {
			response_of 1, { capabilities: {} }
			response_of 2, null
		}, responses

	it 'calls my custom function when requested', ->
		provider = MockProvider {
			initialize_request 1
			request_of 2, '$/customRequest', { test_prop: 'test value' }
			shutdown_request 3
			exit_notif
		}
		ioLSP.provider = provider

		lsp.response['$/customRequest'] = (params) -> { returned: params.test_prop }

		thread = listen!
		assert.equal 'dead', coroutine.status thread

		responses = provider\mock_decode_output!
		assert.same {
			response_of 1, { capabilities: {} }
			response_of 2, { returned: 'test value' }
			response_of 3, null
		}, responses
