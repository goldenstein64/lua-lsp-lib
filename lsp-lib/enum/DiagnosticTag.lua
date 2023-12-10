---The diagnostic tags.
---@since 3.15.0
---@enum lsp.DiagnosticTag
local DiagnosticTag = {
	---Unused or unnecessary code.
	---Clients are allowed to render diagnostics with this tag faded out instead of having
	---an error squiggle.
	Unnecessary = 1,

	---Deprecated or obsolete code.
	---Clients are allowed to rendered diagnostics with this tag strike through.
	Deprecated = 2,
}

return DiagnosticTag
