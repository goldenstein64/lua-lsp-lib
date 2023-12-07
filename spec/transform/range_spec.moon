import to_lsp, from_lsp from require 'lsp-lib.transform.range'

describe 'transform_range', ->
	ascii_text = 'ab\nc\n\nd\r\ne\rf'
	emoji_text = "🤗🤗\n🙂😀\n\n🤣😅\r\n😊\r💥"

	describe 'from_lsp', ->
		it 'works', ->
			i, j = from_lsp ascii_text, {
				start: { line: 0, character: 0 }
				'end': { line: 0, character: 1 }
			}
			assert.same { 1, 1 }, { i, j }

		it 'works across line breaks', ->
			i, j = from_lsp ascii_text, {
				start: { line: 0, character: 0 }
				'end': { line: 1, character: 0 }
			}
			assert.same { 1, 3 }, { i, j }

		it 'works for UTF-8 characters', ->
			i, j = from_lsp emoji_text, {
				start: { line: 0, character: 0 }
				'end': { line: 0, character: 2 }
			}
			assert.same { 1, 8 }, { i, j }

		it 'works after the first UTF-8 character', ->
			i, j = from_lsp emoji_text, {
				start: { line: 0, character: 1 }
				'end': { line: 0, character: 2 }
			}
			assert.same { 5, 8 }, { i, j }

	describe 'to_lsp', ->
		it 'works', ->
			result = to_lsp ascii_text, 1, 1
			assert.same {
				start: { line: 0, character: 0 }
				'end': { line: 0, character: 1 }
			}, result

		it 'works with one argument', ->
			result = to_lsp ascii_text, 1
			assert.same {
				start: { line: 0, character: 0 }
				'end': { line: 1, character: 0 }
			}, result

		it 'works after the first byte', ->
			result = to_lsp ascii_text, 2, 2
			assert.same {
				start: { line: 0, character: 1 }
				'end': { line: 0, character: 2 }
			}, result

		it 'works at the end of the string', ->
			result = to_lsp ascii_text, 1, 12
			assert.same {
				start: { line: 0, character: 0 }
				'end': { line: 5, character: 1 }
			}, result

		it 'works for strings larger than one character', ->
			result = to_lsp ascii_text, 1, 2
			assert.same {
				start: { line: 0, character: 0 }
				'end': { line: 0, character: 2 }
			}, result

		it 'works across line breaks', ->
			-- arg #3 should be interpreted differently...
			result = to_lsp ascii_text, 1, 3
			assert.same {
				start: { line: 0, character: 0 }
				'end': { line: 1, character: 0 }
			}, result

		it 'works for UTF-8 characters', ->
			result = to_lsp emoji_text, 1, 4
			assert.same {
				start: { line: 0, character: 0 }
				'end': { line: 0, character: 1 }
			}, result

		it 'works for UTF-8 characters across line breaks', ->
			result = to_lsp emoji_text, 1, 9
			assert.same {
				start: { line: 0, character: 0 }
				'end': { line: 1, character: 0}
			}, result
