local ErrorCodes = require("lsp-lib.enum.ErrorCodes")
local utf8 = require("compat53.utf8")

local LINE_OUT_OF_RANGE = "{LineOutOfRange}: line %d is out of range"
local UTF_CHAR_NEGATIVE = "{UTFCharNegative}: LSP column %d is negative"
local CHAR_OUT_OF_RANGE =
	"{CharOutOfRange}: column %s is not in the range of [%d, %d]"
local POSITION_INSIDE_CHAR =
	"{PositionInsideChar}: position %d is inside a UTF-8 character"
local POSITION_OUT_OF_RANGE =
	"{PositionOutOfRange}: position %d is not in the range of [1, %d]"

---@param s string
---@param ... any
---@return table
local function e_invalid(s, ...)
	return { code = ErrorCodes.InvalidParams, message = s:format(...) }
end

---@param s string
---@param ... any
---@return table
local function e_internal(s, ...)
	return { code = ErrorCodes.InternalError, message = s:format(...) }
end

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

---finds the positional offset from a byte position. It also finds the byte
---position from a positional offset.
---@class lsp*.transform_position.encoder
---@field byte_of fun(text: string, i: integer, unit_pos: integer): (byte_pos: integer)
---@field unit_of fun(text: string, i: integer, byte_pos: integer): (unit_pos: integer)

---determines how LSP Positions are translated to byte positions. This is
---typically controlled by which `PositionEncodingKind` was selected on
---`'initialize'`.
---@type lsp*.transform_position.encoder
transform_position.encoder = require("lsp-lib.transform.position.utf16")

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
		error(e_invalid(LINE_OUT_OF_RANGE, line))
	end

	for _ = 1, line do
		line_start = match_next_line(text, line_start)
		if not line_start then
			error(e_invalid(LINE_OUT_OF_RANGE, line))
		end
	end
	local line_end = match_end_line(text, line_start) or string.len(text) + 1

	local character = position.character
	if character < 0 then
		error(e_invalid(UTF_CHAR_NEGATIVE, character))
	end

	local byte_pos =
		transform_position.encoder.byte_of(text, line_start, character)
	if byte_pos < line_start - 1 then
		error(e_invalid(CHAR_OUT_OF_RANGE, byte_pos, line_start, line_end))
	elseif byte_pos > line_end then
		byte_pos = line_end
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
		error(e_internal(POSITION_OUT_OF_RANGE, position, byte_len + 1))
	end

	-- if utf8.offset returns a different byte position,
	-- the position is inside a character
	if utf8.offset(text, 0, position) ~= position then
		error(e_internal(POSITION_INSIDE_CHAR, position))
	end

	local line, line_start = get_line(text, position)

	-- if position == 1 then -- start of the string
	-- 	return { line = 0, character = 0 }
	-- end

	local line_end = match_end_line(text, line_start)
	if line_end and position > line_end then
		error(e_invalid(CHAR_OUT_OF_RANGE, position, line_start, line_end))
	end

	local character =
		transform_position.encoder.unit_of(text, line_start, position)

	if character < 0 then
		error(e_internal(UTF_CHAR_NEGATIVE, character))
	end

	return {
		line = line,
		character = character,
	}
end

return transform_position
