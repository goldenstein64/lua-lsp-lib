---The diagnostic's severity.
---@enum lsp.DiagnosticSeverity
local DiagnosticSeverity = {
	---Reports an error.
	Error = 1,

	---Reports a warning.
	Warning = 2,

	---Reports an information.
	Information = 3,

	---Reports a hint.
	Hint = 4,
}

return DiagnosticSeverity
