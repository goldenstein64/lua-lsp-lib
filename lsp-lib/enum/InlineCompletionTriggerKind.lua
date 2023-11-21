---Describes how an {@link InlineCompletionItemProvider inline completion provider} was triggered.
---@since 3.18.0
---@proposed
---@enum lsp.InlineCompletionTriggerKind
local InlineCompletionTriggerKind = {
	---Completion was triggered explicitly by a user gesture.
	Invoked = 0,

	---Completion was triggered automatically while editing.
	Automatic = 1,
}

return InlineCompletionTriggerKind