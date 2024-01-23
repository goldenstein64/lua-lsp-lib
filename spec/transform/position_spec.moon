transform_position = require 'lsp-lib.transform.position'
import from_lsp, to_lsp from transform_position

describe 'transform_position', ->
	ascii_text = 'a\nb\n\nc\r\nd\re'
	emoji_text = "🤗🤗\n🙂😀\n\n🤣😅\r\n😊\r💥"

	describe 'under UTF-8', ->
		transform_position.encoder = require('lsp-lib.transform.position.utf8')

		describe 'from_lsp', ->
			gen_result_values = (text, expected_values) ->
				result_values = {}
				for line, expected_line in pairs expected_values
					result_line = {}
					result_values[line] = result_line
					for character, expected in pairs expected_line
						s, result = pcall from_lsp, text, { :line, :character }
						result_line[character] = if s
							result
						elseif message = result.message
							message\match('^{(.-)}:') or message
						else
							result

				result_values

			it 'works with line breaks', ->
				-- 'a\nb\n\nc\r\nd\re'
				expected_values = {
					[-1]: { [0]: 'LineOutOfRange' }
					[0]: {
						[-1]: 'UTFCharNegative'
						[0]: 1
						[1]: 2
						[2]: 2 -- clamp to previous byte position
					}
					[1]: {
						[-1]: 'UTFCharNegative'
						[0]: 3
						[1]: 4
						[2]: 4 -- clamp to previous byte position
					}
					[2]: {
						[-1]: 'UTFCharNegative'
						[0]: 5
						[1]: 5 -- clamp to previous byte position
					}
					[3]: {
						[-1]: 'UTFCharNegative'
						[0]: 6
						[1]: 7
						[2]: 7 -- clamp to previous byte position
					}
					[4]: {
						[-1]: 'UTFCharNegative'
						[0]: 9
						[1]: 10
						[2]: 10
					}
					[5]: {
						[-1]: 'UTFCharNegative'
						[0]: 11
						[1]: 12
						[2]: 12 -- clamp to previous byte position
					}
					[6]: { [0]: 'LineOutOfRange' }
				}

				result_values = gen_result_values ascii_text, expected_values
				assert.same expected_values, result_values

			it 'works with larger code points', ->
				-- "🤗🤗\n🙂😀\n\n🤣😅\r\n😊\r💥"
				expected_values = {
					[-1]: { [0]: 'LineOutOfRange' }
					[0]: {
						[-1]: 'UTFCharNegative'
						[0]: 1
						[4]: 5
						[8]: 9
						[9]: 9 -- clamp to previous byte position
					}
					[1]: {
						[-1]: 'UTFCharNegative'
						[0]: 10
						[4]: 14
						[8]: 18
						[9]: 18 -- clamp to previous byte position
					}
					[2]: {
						[-1]: 'UTFCharNegative'
						[0]: 19
						[1]: 19 -- clamp to previous byte position
					}
					[3]: {
						[-1]: 'UTFCharNegative'
						[0]: 20
						[4]: 24
						[8]: 28
						[9]: 28 -- clamp to previous byte position
					}
					[4]: {
						[-1]: 'UTFCharNegative'
						[0]: 30
						[4]: 34
						[5]: 34 -- clamp to previous byte position
					}
					[5]: {
						[-1]: 'UTFCharNegative'
						[0]: 35
						[4]: 39
						[5]: 39 -- clamp to previous byte position
					}
					[6]: { [0]: 'LineOutOfRange' }
				}

				result_values = gen_result_values emoji_text, expected_values
				assert.same expected_values, result_values

		describe 'to_lsp', ->
			gen_result_values = (text, expected_values) ->
				result_values = {}
				for position, expected in pairs expected_values
					s, result = pcall to_lsp, text, position
					result_values[position] = if s
						result
					elseif message = result.message
						message\match('^{(.-)}:') or message
					else
						result

				result_values

			it 'works with line breaks', ->
				-- 'a\nb\n\nc\r\nd\re'
				expected_values = {
					[0]: 'PositionOutOfRange'
					[1]: { line: 0, character: 0 }
					[2]: { line: 0, character: 1 }
					[3]: { line: 1, character: 0 }
					[4]: { line: 1, character: 1 }
					[5]: { line: 2, character: 0 }
					[6]: { line: 3, character: 0 }
					[7]: { line: 3, character: 1 }
					[8]: 'CharOutOfRange'
					[9]: { line: 4, character: 0 }
					[10]: { line: 4, character: 1 }
					[11]: { line: 5, character: 0 }
					[12]: { line: 5, character: 1 }
					[13]: 'PositionOutOfRange'
				}

				result_values = gen_result_values ascii_text, expected_values
				assert.same expected_values, result_values

			it 'works with larger code points', ->
				-- "🤗🤗\n🙂😀\n\n🤣😅\r\n😊\r💥"
				EMOJI = {}
				emoji = (pos) -> { type: EMOJI, :pos }

				expected_values = {
					[0]: 'PositionOutOfRange'
					[1]: emoji { line: 0, character: 0 }
					[5]: emoji { line: 0, character: 4 }
					[9]: { line: 0, character: 8 }
					[10]: emoji { line: 1, character: 0 }
					[14]: emoji { line: 1, character: 4 }
					[18]: { line: 1, character: 8 }
					[19]: { line: 2, character: 0 }
					[20]: emoji { line: 3, character: 0 }
					[24]: emoji { line: 3, character: 4 }
					[28]: { line: 3, character: 8 }
					[29]: 'CharOutOfRange'
					[30]: emoji { line: 4, character: 0 }
					[34]: { line: 4, character: 4 }
					[35]: emoji { line: 5, character: 0 }
					[39]: { line: 5, character: 4 }
					[40]: 'PositionOutOfRange'
				}

				for byte, expected in pairs expected_values
					if "table" == type(expected) and expected.type == EMOJI
						expected_values[byte] = expected.pos
						expected_values[i] = 'PositionInsideChar' for i = byte + 1, byte + 3

				result_values = gen_result_values emoji_text, expected_values
				assert.same expected_values, result_values

	describe 'under UTF-16', ->
		transform_position.encoder = require('lsp-lib.transform.position.utf16')

		describe 'from_lsp', ->
			gen_result_values = (text, expected_values) ->
				result_values = {}
				for line, expected_line in pairs expected_values
					result_line = {}
					result_values[line] = result_line
					for character, expected in pairs expected_line
						s, result = pcall from_lsp, text, { :line, :character }
						result_line[character] = if s
							result
						elseif message = result.message
							message\match('^{(.-)}:') or message
						else
							result

				result_values

			it 'works with line breaks', ->
				-- 'a\nb\n\nc\r\nd\re'
				expected_values = {
					[-1]: { [0]: 'LineOutOfRange' }
					[0]: {
						[-1]: 'UTFCharNegative'
						[0]: 1
						[1]: 2
						[2]: 2 -- clamp to previous byte position
					}
					[1]: {
						[-1]: 'UTFCharNegative'
						[0]: 3
						[1]: 4
						[2]: 4 -- clamp to previous byte position
					}
					[2]: {
						[-1]: 'UTFCharNegative'
						[0]: 5
						[1]: 5 -- clamp to previous byte position
					}
					[3]: {
						[-1]: 'UTFCharNegative'
						[0]: 6
						[1]: 7
						[2]: 7 -- clamp to previous byte position
					}
					[4]: {
						[-1]: 'UTFCharNegative'
						[0]: 9
						[1]: 10
						[2]: 10
					}
					[5]: {
						[-1]: 'UTFCharNegative'
						[0]: 11
						[1]: 12
						[2]: 12 -- clamp to previous byte position
					}
					[6]: { [0]: 'LineOutOfRange' }
				}

				result_values = gen_result_values ascii_text, expected_values
				assert.same expected_values, result_values

			it 'works with larger code points', ->
				-- "🤗🤗\n🙂😀\n\n🤣😅\r\n😊\r💥"
				expected_values = {
					[-1]: { [0]: 'LineOutOfRange' }
					[0]: {
						[-1]: 'UTFCharNegative'
						[0]: 1
						[2]: 5
						[4]: 9
						[5]: 9 -- clamp to previous byte position
					}
					[1]: {
						[-1]: 'UTFCharNegative'
						[0]: 10
						[2]: 14
						[4]: 18
						[5]: 18 -- clamp to previous byte position
					}
					[2]: {
						[-1]: 'UTFCharNegative'
						[0]: 19
						[1]: 19 -- clamp to previous byte position
					}
					[3]: {
						[-1]: 'UTFCharNegative'
						[0]: 20
						[2]: 24
						[4]: 28
						[5]: 28 -- clamp to previous byte position
					}
					[4]: {
						[-1]: 'UTFCharNegative'
						[0]: 30
						[2]: 34
						[3]: 34 -- clamp to previous byte position
					}
					[5]: {
						[-1]: 'UTFCharNegative'
						[0]: 35
						[2]: 39
						[3]: 39 -- clamp to previous byte position
					}
					[6]: { [0]: 'LineOutOfRange' }
				}

				result_values = gen_result_values emoji_text, expected_values
				assert.same expected_values, result_values

		describe 'to_lsp', ->
			gen_result_values = (text, expected_values) ->
				result_values = {}
				for position, expected in pairs expected_values
					s, result = pcall to_lsp, text, position
					result_values[position] = if s
						result
					elseif message = result.message
						message\match('^{(.-)}:') or message
					else
						result

				result_values

			it 'works with line breaks', ->
				-- 'a\nb\n\nc\r\nd\re'
				expected_values = {
					[0]: 'PositionOutOfRange'
					[1]: { line: 0, character: 0 }
					[2]: { line: 0, character: 1 }
					[3]: { line: 1, character: 0 }
					[4]: { line: 1, character: 1 }
					[5]: { line: 2, character: 0 }
					[6]: { line: 3, character: 0 }
					[7]: { line: 3, character: 1 }
					[8]: 'CharOutOfRange'
					[9]: { line: 4, character: 0 }
					[10]: { line: 4, character: 1 }
					[11]: { line: 5, character: 0 }
					[12]: { line: 5, character: 1 }
					[13]: 'PositionOutOfRange'
				}

				result_values = gen_result_values ascii_text, expected_values
				assert.same expected_values, result_values

			it 'works with larger code points', ->
				-- "🤗🤗\n🙂😀\n\n🤣😅\r\n😊\r💥"
				EMOJI = {}
				emoji = (pos) -> { type: EMOJI, :pos }

				expected_values = {
					[0]: 'PositionOutOfRange'
					[1]: emoji { line: 0, character: 0 }
					[5]: emoji { line: 0, character: 2 }
					[9]: { line: 0, character: 4 }
					[10]: emoji { line: 1, character: 0 }
					[14]: emoji { line: 1, character: 2 }
					[18]: { line: 1, character: 4 }
					[19]: { line: 2, character: 0 }
					[20]: emoji { line: 3, character: 0 }
					[24]: emoji { line: 3, character: 2 }
					[28]: { line: 3, character: 4 }
					[29]: 'CharOutOfRange'
					[30]: emoji { line: 4, character: 0 }
					[34]: { line: 4, character: 2 }
					[35]: emoji { line: 5, character: 0 }
					[39]: { line: 5, character: 2 }
					[40]: 'PositionOutOfRange'
				}

				for byte, expected in pairs expected_values
					if "table" == type(expected) and expected.type == EMOJI
						expected_values[byte] = expected.pos
						expected_values[i] = 'PositionInsideChar' for i = byte + 1, byte + 3

				result_values = gen_result_values emoji_text, expected_values
				assert.same expected_values, result_values
