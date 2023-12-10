---A set of predefined token modifiers. This set is not fixed
---an clients can specify additional token types via the
---corresponding client capabilities.
---@since 3.16.0
---@enum lsp.SemanticTokenModifiers
local SemanticTokenModifiers = {
	declaration = "declaration",

	definition = "definition",

	readonly = "readonly",

	static = "static",

	deprecated = "deprecated",

	abstract = "abstract",

	async = "async",

	modification = "modification",

	documentation = "documentation",

	defaultLibrary = "defaultLibrary",
}

return SemanticTokenModifiers
