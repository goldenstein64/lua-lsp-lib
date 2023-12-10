---The moniker kind.
---@since 3.16.0
---@enum lsp.MonikerKind
local MonikerKind = {
	---The moniker represent a symbol that is imported into a project
	import = "import",

	---The moniker represents a symbol that is exported from a project
	export = "export",

	---The moniker represents a symbol that is local to a project (e.g. a local
	---variable of a function, a class not visible outside the project, ...)
	_local = "local",
}

return MonikerKind
