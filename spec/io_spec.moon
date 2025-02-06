io_lsp = require 'lsp-lib.io'

import
	MockProvider, set_provider
	request_of, notif_of, response_of
from require 'spec.mocks.io'

describe 'LSP I/O', ->
	before_each ->
		io_lsp.provider = nil

	it 'reads from its provider', ->
		provider = set_provider {
			request_of 1, '$/test1', { a: 'val1' }
			request_of 2, '$/test2', { b: 'val2' }
			request_of 3, '$/test3', { c: 'val3' }
		}

		assert.same {
			jsonrpc: '2.0'
			id: 1, method: '$/test1', params: { a: 'val1' }
		}, io_lsp\read!
		assert.same {
			jsonrpc: '2.0'
			id: 2, method: '$/test2', params: { b: 'val2' }
		}, io_lsp\read!
		assert.same {
			jsonrpc: '2.0'
			id: 3, method: '$/test3', params: { c: 'val3' }
		}, io_lsp\read!

	describe 'when getting batches', ->
		it 'reads each message in individually', ->
			io_lsp.provider = set_provider {
				{ -- note that the input is one array of 3 notifications
					notif_of '$/test1', { a: 'val1' }
					notif_of '$/test2', { b: 'val2' }
					notif_of '$/test3', { c: 'val3' }
				}
			}

			assert.same {
				jsonrpc: '2.0'
				method: '$/test1', params: { a: 'val1' }
			}, io_lsp\read!
			assert.same {
				jsonrpc: '2.0'
				method: '$/test2', params: { b: 'val2' }
			}, io_lsp\read!
			assert.same {
				jsonrpc: '2.0'
				method: '$/test3', params: { c: 'val3' }
			}, io_lsp\read!
