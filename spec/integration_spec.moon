import concat from table

json = require 'cjson'
import null from json

import types from require 'tableshape'

lsp = require 'lsp-lib'
io_lsp = require 'lsp-lib.io'
io_lsp.provider = nil

request_state = require 'lsp-lib.request.state'

import
	set_provider
	request_of, notif_of, response_of
from require 'spec.mocks.io'

import
	request_shape, notif_shape, response_shape
from require 'spec.mocks.message_shapes'

describe 'the system', ->
	before_each ->
		io_lsp.provider = nil
		lsp.response[k] = nil for k in pairs lsp.response
		request_state.id = 1

	initialize_request = (id) ->
		request_of id, 'initialize', {
			processId: null
			rootUri: null
			capabilities: {}
		}

	shutdown_request = (id) -> request_of id, 'shutdown', null

	exit_notif = notif_of 'exit', null

	listen = do
		listen_wrapper = (...) -> lsp.listen ...
		->
			thread = coroutine.create listen_wrapper
			ok, reason = coroutine.resume thread, false
			assert.is_true ok, reason
			thread

	it 'works', ->
		provider = set_provider {
			initialize_request 1
			shutdown_request 2
			exit_notif
		}

		thread = listen!
		assert.thread_dead thread

		responses = provider\mock_output!
		assert.shape responses, types.shape {
			response_shape 1, { capabilities: types.shape {} }
			response_shape 2, null
		}

	it 'works with string ids', ->
		provider = set_provider {
			initialize_request 'init'
			shutdown_request 'stop'
			exit_notif
		}

		thread = listen!
		assert.thread_dead thread

		responses = provider\mock_output!
		assert.shape responses, types.shape {
			response_shape 'init', { capabilities: types.shape {} }
			response_shape 'stop', null
		}

	it 'calls my custom function when requested', ->
		provider = set_provider {
			initialize_request 1
			request_of 2, '$/customRequest', { test_prop: 'test value' }
			shutdown_request 3
			exit_notif
		}

		lsp.response['$/customRequest'] = (params) -> { returned: params.test_prop }

		thread = listen!
		assert.thread_dead thread

		responses = provider\mock_output!
		assert.shape responses, types.shape {
			response_shape 1, { capabilities: types.shape {} }
			response_shape 2, { returned: 'test value' }
			response_shape 3, null
		}

	it 'waits for a request asynchronously', ->
		provider = set_provider {
			initialize_request 1
			request_of 2, '$/asyncRequest', null
			request_of 3, '$/noop', null
			response_of 1, { test_prop: 'foo' }
			shutdown_request 4
			exit_notif
		}

		lsp.response['$/noop'] = (params) -> null

		lsp.response['$/asyncRequest'] = (params) ->
			result, err = lsp.request '$/pendingRequest', null
			{ :result, :err }

		thread = listen!
		assert.thread_dead thread

		responses = provider\mock_output!
		assert.shape responses, types.shape {
			response_shape 1, { capabilities: types.shape {} } -- initialize
			-- receives '$/asyncRequest'
			request_shape 1, '$/pendingRequest', null
			response_shape 3, null -- '$/noop' is responded to in the meantime
			response_shape 2, { result: types.shape { test_prop: 'foo' } } -- $/asyncRequest
			response_shape 4, null -- shutdown
		}

		assert.shape request_state.waiting_threads, types.shape {}
		assert.shape request_state.waiting_requests, types.shape {}
