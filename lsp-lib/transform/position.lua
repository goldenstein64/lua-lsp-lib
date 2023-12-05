local ErrorCodes = require("lsp-lib.enum.ErrorCodes")
local utf8 = require("compat53.module").utf8

local LINE_OUT_OF_RANGE = "line %d is out of range"
local CHAR_OUT_OF_RANGE = "column %d is not in the range of [0, %d]"
local POSITION_OUT_OF_RANGE = "position %d is not in the range of [1, %d]"

---@param text string
---@param i? integer
---@return integer? position
local function match_next_line(text, i)
	local result = math.min(
		text:match("\r\n?()", i) or math.huge,
		text:match("\n()", i) or math.huge
	)
	return result ~= math.huge and result or nil
end

---@param text string
---@param i? integer
---@return integer? position
local function match_end_line(text, i)
	local result = math.min(
		text:match("()\r\n?", i) or math.huge,
		text:match("()\n", i) or math.huge
	)
	return result ~= math.huge and result or nil
end

local transform_position = {}

---takes an LSP Position and converts it to a byte position in the range of
---`[1, n + 1]`. It errors with a response error object if the given `position`
---is erroneous according to `text`.
---
---`n + 1` represents the end of the current line.
---@param text string
---@param position lsp.Position
---@return integer position
function transform_position.from_lsp(text, position)
	local line_start = 1 ---@type integer?
	for _ = 1, position.line do
		line_start = match_next_line(text, line_start)
		if not line_start then
			error({
				code = ErrorCodes.InvalidParams,
				message = LINE_OUT_OF_RANGE:format(position.line)
			})
		end
	end
	local line_end = match_end_line(text, line_start) or string.len(text) + 1

	local character = position.character
	local end_char = line_end - line_start
	if character < 0 or character > end_char then
		error({
			code = ErrorCodes.InvalidParams,
			message = CHAR_OUT_OF_RANGE:format(character, end_char)
		})
	end

	return utf8.offset(text, character + 1, line_start)
end

---takes a byte position in the range of `[1, n + 1]` and converts it to an LSP
---Position. It errors with a response error object if the given `position` is
---erroneous according to `text`.
---
---`n + 1` represents the end of the current line.
---@param text string
---@param position integer
---@return lsp.Position position
function transform_position.to_lsp(text, position)
	if position < 1 or position > text:len() + 1 then
		error({
			code = ErrorCodes.InternalError,
			message = POSITION_OUT_OF_RANGE:format(position, text:len() + 1),
		})
	end

	local line = 0
	local line_start = 1
	local next_start = match_next_line(text)
	while next_start and next_start <= position do
		line = line + 1
		line_start = next_start
		next_start = match_next_line(text, next_start)
	end

	local character = utf8.len(text, line_start, position - 1)
	local line_end = match_end_line(text, line_start) or utf8.len(text) + 1
	local end_char = line_end - line_start
	if character < 0 or character > end_char then
		error({
			code = ErrorCodes.InternalError,
			CHAR_OUT_OF_RANGE:format(character, end_char)
		})
	end

	return {
		line = line,
		character = character,
	}
end

return transform_position
