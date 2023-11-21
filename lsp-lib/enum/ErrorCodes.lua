---Predefined error codes.
---@enum lsp.ErrorCodes
local ErrorCodes = {
	ParseError = -32700,

	InvalidRequest = -32600,

	MethodNotFound = -32601,

	InvalidParams = -32602,

	InternalError = -32603,

	---Error code indicating that a server received a notification or
	---request before the server has received the `initialize` request.
	ServerNotInitialized = -32002,

	UnknownErrorCode = -32001,
}

return ErrorCodes