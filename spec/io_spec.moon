ioLSP = require 'lsp-lib.io'

import
	MockProvider
	request_of, notif_of, response_of
from require 'spec.helpers.mock_io'

describe 'LSP I/O', ->
	before_each ->
		ioLSP.provider = nil

	it 'reads from its provider', ->
		ioLSP.provider = MockProvider {
			request_of 1, '$/test1', { a: 'val1' }
			request_of 2, '$/test2', { b: 'val2' }
			request_of 3, '$/test3', { c: 'val3' }
		}

		assert.same {
			jsonrpc: '2.0'
			id: 1, method: '$/test1', params: { a: 'val1' }
		}, ioLSP\read!
		assert.same {
			jsonrpc: '2.0'
			id: 2, method: '$/test2', params: { b: 'val2' }
		}, ioLSP\read!
		assert.same {
			jsonrpc: '2.0'
			id: 3, method: '$/test3', params: { c: 'val3' }
		}, ioLSP\read!
