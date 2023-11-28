---holds state for `lsp.request`. Every key in `request` is reserved for
---custom request implementations.
return {
	---@type integer
	id = 1,

	---@type { [integer]: thread }
	waiting_threads = {},

	---@type { [thread]: lsp.Request | lsp.Notification }
	waiting_requests = {},
}
