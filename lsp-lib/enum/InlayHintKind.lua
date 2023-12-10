---Inlay hint kinds.
---@since 3.17.0
---@enum lsp.InlayHintKind
local InlayHintKind = {
	---An inlay hint that for a type annotation.
	Type = 1,

	---An inlay hint that is for a parameter.
	Parameter = 2,
}

return InlayHintKind
