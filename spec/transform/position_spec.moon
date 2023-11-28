import from_lsp, to_lsp from require 'lsp-lib.transform.position'

describe 'transform_position', ->
	describe 'from_lsp', ->
		text = 'a\nb\n\nc\r\nd\re'

		it 'works', ->
			assert.error -> from_lsp text, { line: 0, character: -1 }
			assert.equal 1, from_lsp text, { line: 0, character: 0 }
			assert.equal 2, from_lsp text, { line: 0, character: 1 }
			assert.error -> from_lsp text, { line: 0, character: 2 }
			assert.equal 3, from_lsp text, { line: 1, character: 0 }
			assert.equal 4, from_lsp text, { line: 1, character: 1 }
			assert.error -> from_lsp text, { line: 1, character: 2 }
			assert.equal 5, from_lsp text, { line: 2, character: 0 }
			assert.error -> from_lsp text, { line: 2, character: 1 }
			assert.equal 6, from_lsp text, { line: 3, character: 0 }
			assert.equal 7, from_lsp text, { line: 3, character: 1 }
			assert.error -> from_lsp text, { line: 3, character: 2 }
			assert.equal 9, from_lsp text, { line: 4, character: 0 }
			assert.equal 10, from_lsp text, { line: 4, character: 1 }
			assert.error -> from_lsp text, { line: 4, character: 2 }
			assert.equal 11, from_lsp text, { line: 5, character: 0 }
			assert.equal 12, from_lsp text, { line: 5, character: 1 }
			assert.error -> from_lsp text, { line: 5, character: 2 }
			assert.error -> from_lsp text, { line: 6, character: 0 }

	describe 'to_lsp', ->
		text = 'a\nb\n\nc\r\nd\re'

		it 'works', ->
			assert.error -> to_lsp text, 0
			assert.same { line: 0, character: 0 }, to_lsp text, 1
			assert.same { line: 0, character: 1 }, to_lsp text, 2
			assert.same { line: 1, character: 0 }, to_lsp text, 3
			assert.same { line: 1, character: 1 }, to_lsp text, 4
			assert.same { line: 2, character: 0 }, to_lsp text, 5
			assert.same { line: 3, character: 0 }, to_lsp text, 6
			assert.same { line: 3, character: 1 }, to_lsp text, 7
			assert.error -> to_lsp text, 8 -- middle of a line ending
			assert.same { line: 4, character: 0 }, to_lsp text, 9
			assert.same { line: 4, character: 1 }, to_lsp text, 10
			assert.same { line: 5, character: 0 }, to_lsp text, 11
			assert.same { line: 5, character: 1 }, to_lsp text, 12
			assert.error -> to_lsp text, 13
