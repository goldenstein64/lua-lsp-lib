---A set of predefined token types. This set is not fixed
---an clients can specify additional token types via the
---corresponding client capabilities.
---@since 3.16.0
---@enum lsp.SemanticTokenTypes
local SemanticTokenTypes = {
	namespace = "namespace",

	---Represents a generic type. Acts as a fallback for types which can't be mapped to
	---a specific type like class or enum.
	type = "type",

	class = "class",

	enum = "enum",

	interface = "interface",

	struct = "struct",

	typeParameter = "typeParameter",

	parameter = "parameter",

	variable = "variable",

	property = "property",

	enumMember = "enumMember",

	event = "event",

	_function = "function",

	method = "method",

	macro = "macro",

	keyword = "keyword",

	modifier = "modifier",

	comment = "comment",

	string = "string",

	number = "number",

	regexp = "regexp",

	operator = "operator",

	---@since 3.17.0
	decorator = "decorator",
}

return SemanticTokenTypes