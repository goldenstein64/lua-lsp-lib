local transformPosition = require("lsp-lib.transform.position")

local transformRange = {}

---takes an LSP range and converts it into a pair of byte positions
---`start, finish` in the range of `[1, n + 1]` such that
---`text:sub(start, finish)` represents the substring of `text` in `range`
---@param text string
---@param range lsp.Range
---@return integer start, integer finish
function transformRange.fromLSP(text, range)
	return
		transformPosition.fromLSP(text, range.start),
		transformPosition.fromLSP(text, range["end"])
end

---takes a pair of byte positions in the range of `[1, n + 1]` and converts
---them into an LSP range
---@param text string
---@param start integer
---@param finish? integer
---@return lsp.Range range
function transformRange.toLSP(text, start, finish)
	if finish then
		return {
			start = transformPosition.toLSP(text, start),
			["end"] = transformPosition.toLSP(text, finish),
		}
	else
		local lspStart = transformPosition.toLSP(text, start)
		return {
			start = lspStart,
			["end"] = { line = lspStart.line + 1, character = 0 }
		}
	end
end

return transformRange
