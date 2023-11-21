---A set of predefined range kinds.
---@enum lsp.FoldingRangeKind
local FoldingRangeKind = {
	---Folding range for a comment
	Comment = "comment",

	---Folding range for an import or include
	Imports = "imports",

	---Folding range for a region (e.g. `#region`)
	Region = "region",
}

return FoldingRangeKind