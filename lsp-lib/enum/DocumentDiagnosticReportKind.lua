---The document diagnostic report kinds.
---@since 3.17.0
---@enum lsp.DocumentDiagnosticReportKind
local DocumentDiagnosticReportKind = {
	---A diagnostic report with a full
	---set of problems.
	Full = "full",

	---A report indicating that the last
	---returned report is still accurate.
	Unchanged = "unchanged",
}

return DocumentDiagnosticReportKind