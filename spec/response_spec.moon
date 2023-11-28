import null from require 'cjson'

response = require 'lsp-lib.response'

describe 'lsp.response', ->
	it 'has defaults for mandatory request implementations', ->
		assert.is_function response['initialize']
		assert.is_function response['shutdown']

	it 'has defaults for spam notifications', ->
		assert.is_function response['initialized']
		assert.is_function response['exit']

	it 'can implement a custom method', ->
		assert.no_error ->
			response['$/noop'] = -> null
