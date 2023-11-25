local transform_position = require("lsp-lib.transform.position")

local transform_range = {}

---takes an LSP range and converts it into a pair of byte positions
---`start, finish` in the range of `[1, n + 1]` such that
---`text:sub(start, finish)` represents the substring of `text` in `range`
---@param text string
---@param range lsp.Range
---@return integer start, integer finish
function transform_range.from_lsp(text, range)
	return
		transform_position.from_lsp(text, range.start),
		transform_position.from_lsp(text, range["end"])
end

---takes a pair of byte positions in the range of `[1, n + 1]` and converts
---them into an LSP range
---@param text string
---@param start integer
---@param finish? integer
---@return lsp.Range range
function transform_range.to_lsp(text, start, finish)
	if finish then
		return {
			start = transform_position.to_lsp(text, start),
			["end"] = transform_position.to_lsp(text, finish),
		}
	else
		local lsp_start = transform_position.to_lsp(text, start)
		return {
			start = lsp_start,
			["end"] = { line = lsp_start.line + 1, character = 0 }
		}
	end
end

return transform_range
