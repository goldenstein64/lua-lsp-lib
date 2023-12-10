---A document highlight kind.
---@enum lsp.DocumentHighlightKind
local DocumentHighlightKind = {
	---A textual occurrence.
	Text = 1,

	---Read-access of a symbol, like reading a variable.
	Read = 2,

	---Write-access of a symbol, like writing to a variable.
	Write = 3,
}

return DocumentHighlightKind
