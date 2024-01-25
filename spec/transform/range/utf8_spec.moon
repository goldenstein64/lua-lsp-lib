transform_position = require 'lsp-lib.transform.position'
import to_lsp, from_lsp from require 'lsp-lib.transform.range'

describe 'transform_range under UTF-8', ->
	transform_position.encoder = require 'lsp-lib.transform.position.utf8'

	ascii_text = 'ab\nc\n\nd\r\ne\rf'
	emoji_text = "🤗🤗\n🙂😀\n\n🤣😅\r\n😊\r💥"
	crlf_text = 'ab\r\ncd'

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

		it 'works for larger code points', ->
			i, j = from_lsp emoji_text, {
				start: { line: 0, character: 0 }
				'end': { line: 0, character: 8 }
			}
			assert.same { 1, 8 }, { i, j }

		it 'works after the first large code point', ->
			i, j = from_lsp emoji_text, {
				start: { line: 0, character: 4 }
				'end': { line: 0, character: 8 }
			}
			assert.same { 5, 8 }, { i, j }

		it 'accepts the end of a CRLF line', ->
			i, j = from_lsp crlf_text, {
				start: { line: 0, character: 8 }
				'end': { line: 0, character: 8 }
			}
			assert.same { 3, 2 }, { i, j }

		it 'accepts the beginning of a CRLF line', ->
			i, j = from_lsp crlf_text, {
				start: { line: 1, character: 0 }
				'end': { line: 1, character: 0 }
			}
			assert.same { 5, 4 }, { i, j }

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
			result = to_lsp ascii_text, 1, 3
			assert.same {
				start: { line: 0, character: 0 }
				'end': { line: 1, character: 0 }
			}, result

		it 'works for larger code points', ->
			result = to_lsp emoji_text, 1, 4
			assert.same {
				start: { line: 0, character: 0 }
				'end': { line: 0, character: 4 }
			}, result

		it 'works for larger code points across line breaks', ->
			result = to_lsp emoji_text, 1, 9
			assert.same {
				start: { line: 0, character: 0 }
				'end': { line: 1, character: 0 }
			}, result

		it "accepts the end of a CRLF line", ->
			result = to_lsp crlf_text, 3, 2
			assert.same {
				start: { line: 0, character: 2 }
				'end': { line: 0, character: 2 }
			}, result

		it "accepts the start of a CRLF line", ->
			result = to_lsp crlf_text, 5, 4
			assert.same {
				start: { line: 1, character: 0 }
				'end': { line: 1, character: 0 }
			}, result

		it "rejects the middle of a CRLF line", ->
			assert.error -> to_lsp crlf_text, 4, 3
