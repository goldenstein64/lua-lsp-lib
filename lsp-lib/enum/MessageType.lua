---The message type
---@enum lsp.MessageType
local MessageType = {
	---An error message.
	Error = 1,

	---A warning message.
	Warning = 2,

	---An information message.
	Info = 3,

	---A log message.
	Log = 4,

	---A debug message.
	---@since 3.18.0
	Debug = 5,
}

return MessageType