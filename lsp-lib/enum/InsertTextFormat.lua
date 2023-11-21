---Defines whether the insert text in a completion item should be interpreted as
---plain text or a snippet.
---@enum lsp.InsertTextFormat
local InsertTextFormat = {
	---The primary text to be inserted is treated as a plain string.
	PlainText = 1,

	---The primary text to be inserted is treated as a snippet.
	---A snippet can define tab stops and placeholders with `$1`, `$2`
	---and `${3:foo}`. `$0` defines the final tab stop, it defaults to
	---the end of the snippet. Placeholders with equal identifiers are linked,
	---that is typing in one will update others too.
	---See also: https://microsoft.github.io/language-server-protocol/specifications/specification-current/#snippet_syntax
	Snippet = 2,
}

return InsertTextFormat