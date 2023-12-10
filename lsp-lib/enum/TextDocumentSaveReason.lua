---Represents reasons why a text document is saved.
---@enum lsp.TextDocumentSaveReason
local TextDocumentSaveReason = {
	---Manually triggered, e.g. by the user pressing save, by starting debugging,
	---or by an API call.
	Manual = 1,

	---Automatic after a delay.
	AfterDelay = 2,

	---When the editor lost focus.
	FocusOut = 3,
}

return TextDocumentSaveReason
