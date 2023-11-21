local lpeg = require("lpeg")

local ErrorCodes = require("lsp-lib.enum.ErrorCodes")
local utf8 = require("compat53.module").utf8

local LINE_OUT_OF_RANGE = "line %d is out of range"
local POSITION_OUT_OF_RANGE = "position %d is not in the range of [1, %d]"

local newLine = (lpeg.P("\r\n") + lpeg.S("\r\n")) * lpeg.Cp()
local gNewLine = lpeg.P({ newLine + 1 * lpeg.V(1) })

---@param text string
---@param i? integer
---@return integer? position
local function matchNextLine(text, i)
	return gNewLine:match(text, i) --[[@as integer?]]
end

local transformPosition = {}

---takes an LSP Position and converts it to a byte position in the range of
---`[1, n + 1]`
---
---`n + 1` represents the end of the last line
---@param text string
---@param position lsp.Position
---@return integer position
function transformPosition.fromLSP(text, position)
	local lineStart = 1
	for _ = 1, position.line do
		---@diagnostic disable-next-line: cast-local-type
		lineStart = matchNextLine(text, lineStart)
		if not lineStart then
			error.object({
				code = ErrorCodes.InvalidParams,
				message = LINE_OUT_OF_RANGE:format(position.line)
			})
		end
	end

	local newPosition = utf8.offset(text, position.character + 1, lineStart)
	if newPosition < 1 or newPosition > text:len() + 1 then
		error.object({
			code = ErrorCodes.InvalidParams,
			message = POSITION_OUT_OF_RANGE:format(newPosition, text:len() + 1),
		})
	end

	return newPosition
end

---takes a byte position in the range of `[1, n + 1]` and converts it into an
---LSP Position
---
---`n + 1` represents the end of the last line
---@param text string
---@param position integer
---@return lsp.Position position
function transformPosition.toLSP(text, position)
	if position < 1 or position > text:len() + 1 then
		error.object({
			code = ErrorCodes.InternalError,
			message = POSITION_OUT_OF_RANGE:format(position, text:len() + 1),
		})
	end

	local line = 0
	local lineStart = 1
	local nextStart = matchNextLine(text)
	while nextStart and nextStart <= position do
		line = line + 1
		lineStart = nextStart
		nextStart = matchNextLine(text, nextStart)
	end

	return {
		line = line,
		character = utf8.len(text, lineStart, position - 1),
	}
end

return transformPosition
