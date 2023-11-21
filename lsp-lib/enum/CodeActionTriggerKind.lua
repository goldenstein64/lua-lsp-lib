---The reason why code actions were requested.
---@since 3.17.0
---@enum lsp.CodeActionTriggerKind
local CodeActionTriggerKind = {
	---Code actions were explicitly requested by the user or by an extension.
	Invoked = 1,

	---Code actions were requested automatically.
	---This typically happens when current selection in a file changes, but can
	---also be triggered when file content changes.
	Automatic = 2,
}

return CodeActionTriggerKind