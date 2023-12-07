import from_lsp, to_lsp from require 'lsp-lib.transform.position'

describe 'transform_position', ->
	ascii_text = 'a\nb\n\nc\r\nd\re'
	emoji_text = "🤗🤗\n🙂😀\n\n🤣😅\r\n😊\r💥"

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
			expected_values = {
				[-1]: { [0]: 'LineOutOfRange' }
				[0]: {
					[-1]: 'UTFCharNegative'
					[0]: 1
					[1]: 2
					[2]: 'CharOutOfRange' }
				[1]: {
					[-1]: 'UTFCharNegative'
					[0]: 3
					[1]: 4
					[2]: 'CharOutOfRange'
				}
				[2]: {
					[-1]: 'UTFCharNegative'
					[0]: 5
					[1]: 'CharOutOfRange'
				}
				[3]: {
					[-1]: 'UTFCharNegative'
					[0]: 6
					[1]: 7
					[2]: 'CharOutOfRange'
				}
				[4]: {
					[-1]: 'UTFCharNegative'
					[0]: 9
					[1]: 10
					[2]: 'CharOutOfRange'
				}
				[5]: {
					[-1]: 'UTFCharNegative'
					[0]: 11
					[1]: 12
					[2]: 'CharOutOfRange'
				}
				[6]: { [0]: 'LineOutOfRange' }
			}

			result_values = gen_result_values ascii_text, expected_values
			assert.same expected_values, result_values

		it 'works with UTF-8 characters', ->
			expected_values = {
				[-1]: { [0]: 'LineOutOfRange' }
				[0]: {
					[-1]: 'UTFCharNegative'
					[0]: 1
					[1]: 5
					[2]: 9
					[3]: 'CharOutOfRange'
				}
				[1]: {
					[-1]: 'UTFCharNegative'
					[0]: 10
					[1]: 14
					[2]: 18
					[3]: 'CharOutOfRange'
				}
				[2]: {
					[-1]: 'UTFCharNegative'
					[0]: 19
					[1]: 'CharOutOfRange'
				}
				[3]: {
					[-1]: 'UTFCharNegative'
					[0]: 20
					[1]: 24
					[2]: 28
					[3]: 'CharOutOfRange'
				}
				[4]: {
					[-1]: 'UTFCharNegative'
					[0]: 30
					[1]: 34
					[2]: 'CharOutOfRange'
				}
				[5]: {
					[-1]: 'UTFCharNegative'
					[0]: 35
					[1]: 39
					[2]: 'CharOutOfRange'
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

		it 'works with extended UTF-8 characters', ->
			EMOJI = {}
			emoji = (pos) -> { type: EMOJI, :pos }

			expected_values = {
				[0]: 'PositionOutOfRange'
				[1]: emoji { line: 0, character: 0 }
				[5]: emoji { line: 0, character: 1 }
				[9]: { line: 0, character: 2 }
				[10]: emoji { line: 1, character: 0 }
				[14]: emoji { line: 1, character: 1 }
				[18]: { line: 1, character: 2 }
				[19]: { line: 2, character: 0 }
				[20]: emoji { line: 3, character: 0 }
				[24]: emoji { line: 3, character: 1 }
				[28]: { line: 3, character: 2 }
				[29]: 'CharOutOfRange'
				[30]: emoji { line: 4, character: 0 }
				[34]: { line: 4, character: 1 }
				[35]: emoji { line: 5, character: 0 }
				[39]: { line: 5, character: 1 }
				[40]: 'PositionOutOfRange'
			}

			for byte, expected in pairs expected_values
				if "table" == type(expected) and expected.type == EMOJI
					expected_values[byte] = expected.pos
					expected_values[i] = 'PositionInsideChar' for i = byte + 1, byte + 3

			result_values = gen_result_values emoji_text, expected_values
			assert.same expected_values, result_values


