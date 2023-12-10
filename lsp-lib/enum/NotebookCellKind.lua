---A notebook cell kind.
---@since 3.17.0
---@enum lsp.NotebookCellKind
local NotebookCellKind = {
	---A markup-cell is formatted source that is used for display.
	Markup = 1,

	---A code-cell is source code.
	Code = 2,
}

return NotebookCellKind
