import null from require 'cjson'

io_lsp = require 'lsp-lib.io'
listen = require 'lsp-lib.listen'
response = require 'lsp-lib.response'

match = require 'luassert.match'
spy = require 'luassert.spy'
import
	MockProvider
	request_of, response_of, notif_of
from require 'spec.mocks.io'

describe 'lsp.listen', ->
	before_each ->
		listen.state = 'initialize'
		listen.running = true
		listen.routes = response

		io_lsp.provider = nil

	describe 'once', ->
		it 'calls the handler corresponding to its state', ->
			listen.state = 'foo_bar'
			s = spy ->
			listen.handlers['foo_bar'] = s

			listen.once!

			assert.spy(s).called 1
			assert.spy(s).called.with()
			listen.handlers['foo_bar'] = nil

		it 'errors in an unknown state', ->
			listen.state = 'unknown'
			assert.error -> listen.once!

		it 'indexes routes when a request is received', ->
			provider = MockProvider {
				request_of 1, '$/stringify', { arg: 97 }
			}
			io_lsp.provider = provider

			stringify = spy (params) -> { returned: tostring params.arg }

			listen.state = 'default'
			listen.routes = {
				'$/stringify': stringify
			}

			listen.once!

			assert.spy(stringify).called 1
			assert.spy(stringify).called_with match.is_same { arg: 97 }

			responses = provider\mock_decode_output!
			assert.same {
				response_of 1, { returned: '97' }
			}, responses
