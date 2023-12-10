local ErrorCodes = require("lsp-lib.enum.ErrorCodes")
local utf8 = require("compat53.module").utf8

local LINE_OUT_OF_RANGE = "{LineOutOfRange}: line %d is out of range"
local UTF_CHAR_NEGATIVE = "{UTFCharNegative}: LSP column %d is negative"
local CHAR_OUT_OF_RANGE = "{CharOutOfRange}: column %s is not in the range of [%d, %d]"
local POSITION_INSIDE_CHAR = "{PositionInsideChar}: position %d is inside a UTF-8 character"
local POSITION_OUT_OF_RANGE = "{PositionOutOfRange}: position %d is not in the range of [1, %d]"

---@param text string
---@param i? integer
---@return integer? position
local function match_next_line(text, i)
	local crlf_match = string.match(text, "\r\n?()", i) or math.huge
	local lf_match = string.match(text, "\n()", i) or math.huge
	local result = math.min(crlf_match, lf_match)
	return result ~= math.huge and result or nil
end

---@param text string
---@param i? integer
---@return integer? position
local function match_end_line(text, i)
	local crlf_match = string.match(text, "()\r\n?", i) or math.huge
	local lf_match = string.match(text, "()\n", i) or math.huge
	local result = math.min(crlf_match, lf_match)
	return result ~= math.huge and result or nil
end

---@param text string
---@param position integer
---@return integer line, integer line_start
local function get_line(text, position)
	local line = 0
	local line_start = 1

	local next_start = match_next_line(text)
	while next_start and next_start <= position do
		line = line + 1
		line_start = next_start
		next_start = match_next_line(text, next_start)
	end

	return line, line_start
end

---helps with transforming LSP Position objects into byte positions and
---vice-versa
local transform_position = {}

---takes an LSP Position and converts it to a byte position in the range of
---`[1, n + 1]`. It errors with a response error object if the given `position`
---is erroneous according to `text`.
---
---`n + 1` represents the end of the string.
---@param text string
---@param position lsp.Position
---@return integer position
function transform_position.from_lsp(text, position)
	local line_start = 1 ---@type integer?

	local line = position.line
	if line < 0 then
		error({
			code = ErrorCodes.InvalidParams,
			message = LINE_OUT_OF_RANGE:format(line),
		})
	end

	for _ = 1, line do
		line_start = match_next_line(text, line_start)
		if not line_start then
			error({
				code = ErrorCodes.InvalidParams,
				message = LINE_OUT_OF_RANGE:format(line),
			})
		end
	end
	local line_end = match_end_line(text, line_start) or string.len(text) + 1

	local character = position.character
	if character < 0 then
		error({
			code = ErrorCodes.InvalidParams,
			message = UTF_CHAR_NEGATIVE:format(character),
		})
	end

	local byte_pos = utf8.offset(text, character + 1, line_start)
	if not byte_pos or byte_pos < line_start - 1 or byte_pos > line_end then
		error({
			code = ErrorCodes.InvalidParams,
			message = CHAR_OUT_OF_RANGE:format(byte_pos, line_start, line_end),
		})
	end

	return byte_pos
end

---takes a byte position in the range of `[1, n + 1]` and converts it to an LSP
---Position. It errors with a response error object if the given `position` is
---erroneous according to `text`.
---
---`n + 1` represents the end of the string.
---@param text string
---@param position integer
---@return lsp.Position position
function transform_position.to_lsp(text, position)
	local byte_len = string.len(text)
	if position < 1 or position > byte_len + 1 then
		error({
			code = ErrorCodes.InternalError,
			message = POSITION_OUT_OF_RANGE:format(position, byte_len + 1),
		})
	end

	-- if utf8.offset returns a different byte position,
	-- the position is inside a character
	if utf8.offset(text, 0, position) ~= position then
		error({
			code = ErrorCodes.InternalError,
			message = POSITION_INSIDE_CHAR:format(position),
		})
	end

	local line, line_start = get_line(text, position)

	if position == byte_len + 1 then
		-- end of the string
		return {
			line = line,
			character = utf8.len(text, line_start),
		}
	elseif position == 1 then
		-- start of the string
		return {
			line = 0,
			character = 0,
		}
	end

	local line_end = match_end_line(text, line_start)
	local char_end
	if line_end then
		char_end = utf8.len(text, 1, line_end)
	else
		char_end = utf8.len(text) + 1
	end

	local character = utf8.len(text, line_start, position - 1)
	local char_start = utf8.len(text, 1, line_start)
	local utf_row_len = char_end - char_start
	if character < 0 or character > utf_row_len then
		error({
			code = ErrorCodes.InternalError,
			message = CHAR_OUT_OF_RANGE:format(character, 0, utf_row_len),
		})
	end

	return {
		line = line,
		character = character,
	}
end

return transform_position
