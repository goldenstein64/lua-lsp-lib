---holds the internal state for `lsp.request`. This exists because every field
---in `request` is intended to be reserved for custom request implementations.
return {
	---the next id the server uses for a request.
	---@type integer
	id = 1,

	---a map of request id's to threads.
	---@type { [integer]: thread }
	waiting_threads = {},

	---a map of threads to waiting requests and notifications.
	---@type { [thread]: lsp.Request | lsp.Notification }
	waiting_requests = {},
}
