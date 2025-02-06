import concat from table

import null, array_mt from require 'cjson'

import types from require 'tableshape'
import shape, array_contains from types

lsp = require 'lsp-lib'
io_lsp = require 'lsp-lib.io'
io_lsp.provider = nil

request_state = require 'lsp-lib.request.state'

listen_async = require 'spec.helper.listen_async'

import
	set_provider
	request_of, notif_of, response_of
	initialize_request, shutdown_request, exit_notif
from require 'spec.mocks.io'

import
	request_shape, notif_shape, response_shape
from require 'spec.mocks.message_shapes'

describe 'the system', ->
	before_each ->
		io_lsp.provider = nil
		lsp.response[k] = nil for k in pairs lsp.response
		request_state.id = 1

	it 'works', ->
		provider = set_provider {
			initialize_request 1
			shutdown_request 2
			exit_notif
		}

		thread, ok, reason = listen_async!
		assert.is_true ok, reason
		assert.thread_dead thread

		responses = provider\mock_output!
		assert.shape responses, shape {
			response_shape 1, { capabilities: shape {} }
			response_shape 2, null
		}

	it 'works with string ids', ->
		provider = set_provider {
			initialize_request 'init'
			shutdown_request 'stop'
			exit_notif
		}

		thread, ok, reason = listen_async!
		assert.is_true ok, reason
		assert.thread_dead thread

		responses = provider\mock_output!
		assert.shape responses, shape {
			response_shape 'init', { capabilities: shape {} }
			response_shape 'stop', null
		}

	it 'calls an implemented response when requested', ->
		provider = set_provider {
			initialize_request 1
			request_of 2, '$/customRequest', { test_prop: 'test value' }
			shutdown_request 3
			exit_notif
		}

		lsp.response['$/customRequest'] = (params) -> { returned: params.test_prop }

		thread, ok, reason = listen_async!
		assert.is_true ok, reason
		assert.thread_dead thread

		responses = provider\mock_output!
		assert.shape responses, shape {
			response_shape 1, { capabilities: shape {} }
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

		thread, ok, reason = listen_async!
		assert.is_true ok, reason
		assert.thread_dead thread

		responses = provider\mock_output!
		assert.shape responses, shape {
			response_shape 1, { capabilities: shape {} } -- initialize
			-- receives '$/asyncRequest'
			request_shape 1, '$/pendingRequest', null
			response_shape 3, null -- '$/noop' is responded to in the meantime
			response_shape 2, { result: shape { test_prop: 'foo' } } -- $/asyncRequest
			response_shape 4, null -- shutdown
		}

		assert.shape request_state.waiting_threads, shape {}
		assert.shape request_state.waiting_requests, shape {}

	it 'handles batch requests', ->
		provider = set_provider {
			initialize_request 1
			setmetatable {
				request_of 2, '$/foo', null
				request_of 3, '$/bar', null
				request_of 4, '$/baz', null
			}, array_mt
			shutdown_request 5
			exit_notif
		}

		lsp.response['$/foo'] = (params) -> 'FOO RESPONSE'
		lsp.response['$/bar'] = (params) -> 'BAR RESPONSE'
		lsp.response['$/baz'] = (params) -> 'BAZ RESPONSE'

		thread, ok, reason = listen_async!
		assert.is_true ok, reason
		assert.thread_dead thread

		responses = provider\mock_output!
		assert.shape responses, shape {
			response_shape 1, { capabilities: shape {} } -- initialize
			types.all_of {
				array_contains response_shape 2, 'FOO RESPONSE'
				array_contains response_shape 3, 'BAR RESPONSE'
				array_contains response_shape 4, 'BAZ RESPONSE'
				types.table\length types.literal 3
				types.metatable_is types.literal array_mt
			}
			response_shape 5, null -- shutdown
		}

		assert.shape request_state.waiting_threads, shape {}
		assert.shape request_state.waiting_requests, shape {}
