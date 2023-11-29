local io_lsp = require("lsp-lib.io")
local MessageType = require("lsp-lib.enum.MessageType")

local notifications = {
	"window/showMessage",
	"window/logMessage",
	"telemetry/event",
	"textDocument/publishDiagnostics",
	"$/logTrace",
	"$/cancelRequest",
	"$/progress",
}

---@enum (key) lsp*.MessageType
local message_type_map = {
	error = MessageType.Error,
	warn = MessageType.Warning,
	info = MessageType.Info,
	log = MessageType.Log,
	debug = MessageType.Debug
}

---@class lsp*.Notify
local notify = {
	---@class lsp*.Notify.log
	---@field error fun(message: string)
	---@field warn fun(message: string)
	---@field info fun(message: string)
	---@field log fun(message: string)
	---@field debug fun(message: string)
	log = {},

	---@class lsp*.Notify.show
	---@field error fun(message: string)
	---@field warn fun(message: string)
	---@field info fun(message: string)
	---@field log fun(message: string)
	---@field debug fun(message: string)
	show = {},
}

for k, type in pairs(message_type_map) do
	notify.log[k] = function(message)
		notify("window/logMessage", { message = message, type = type })
	end
	notify.show[k] = function(message)
		notify("window/showMessage", { message = message, type = type })
	end
end

---@param message string
---@param verbose? string
function notify.log_trace(message, verbose)
	notify("$/logTrace", { message = message, verbose = verbose })
end

---@param data lsp.LSPAny
function notify.telemetry(data)
	notify("telemetry/event", data)
end

---@param token lsp.ProgressToken
---@param data lsp.LSPAny
function notify.progress(token, data)
	notify("$/progress", { token = token, value = data })
end

---@param id string | integer
function notify.cancel_request(id)
	notify("$/cancelRequest", { id = id })
end

---@param uri lsp.URI
---@param diagnostics lsp.Diagnostic[]
---@param version? integer
function notify.diagnostics(uri, diagnostics, version)
	notify("textDocument/publishDiagnostics", { uri = uri, diagnostics = diagnostics, version = version })
end

for _, method in pairs(notifications) do
	---@diagnostic disable-next-line: assign-type-mismatch
	notify[method] = function(params) notify(method, params) end
end

local notify_mt = {}

function notify_mt:__index(method)
	error(string.format("attempt to retrieve unknown notification method '%s'", method))
end

---@param method string
---@param params table
function notify_mt:__call(method, params)
	---@type lsp.Notification
	local notif = {
		jsonrpc = "2.0",
		method = method,
		params = params
	}

	io_lsp:write(notif)
end

return setmetatable(notify, notify_mt)
