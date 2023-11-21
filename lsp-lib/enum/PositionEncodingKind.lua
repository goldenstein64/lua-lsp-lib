---A set of predefined position encoding kinds.
---@since 3.17.0
---@enum lsp.PositionEncodingKind
local PositionEncodingKind = {
	---Character offsets count UTF-8 code units (e.g. bytes).
	UTF8 = "utf-8",

	---Character offsets count UTF-16 code units.
	---This is the default and must always be supported
	---by servers
	UTF16 = "utf-16",

	---Character offsets count UTF-32 code units.
	---Implementation note: these are the same as Unicode codepoints,
	---so this `PositionEncodingKind` may also be used for an
	---encoding-agnostic representation of character offsets.
	UTF32 = "utf-32",
}

return PositionEncodingKind