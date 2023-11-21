---Completion item tags are extra annotations that tweak the rendering of a completion
---item.
---@since 3.15.0
---@enum lsp.CompletionItemTag
local CompletionItemTag = {
	---Render a completion as obsolete, usually using a strike-out.
	Deprecated = 1,
}

return CompletionItemTag