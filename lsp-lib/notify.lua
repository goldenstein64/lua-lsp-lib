local ioLSP = require("lsp-lib.io")
local MessageType = require("lsp-lib.enum.MessageType")

local notifSet = {
	["window/showMessage"] = true,
	["window/logMessage"] = true,
	["telemetry/event"] = true,
	["textDocument/publishDiagnostics"] = true,
	["$/logTrace"] = true,
	["$/cancelRequest"] = true,
	["$/progress"] = true,
}

---@enum (key) lsp*.MessageType
local messageTypeMap = {
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

for k, type in pairs(messageTypeMap) do
	notify.log[k] = function(message)
		notify("window/logMessage", { message = message, type = type })
	end
	notify.show[k] = function(message)
		notify("window/showMessage", { message = message, type = type })
	end
end

---@param message string
---@param verbose? string
function notify.logTrace(message, verbose)
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
function notify.cancelRequest(id)
	notify("$/cancelRequest", { id = id })
end

---@param uri lsp.URI
---@param diagnostics lsp.Diagnostic[]
---@param version? integer
function notify.diagnostics(uri, diagnostics, version)
	notify("textDocument/publishDiagnostics", { uri = uri, diagnostics = diagnostics, version = version })
end

local notifyMt = {}

function notifyMt:__index(method)
	if not notifSet[method] then
		error(string.format("attempt to retrieve unknown notification method '%s'", method))
	end
	local v = function(params) notify(method, params) end
	rawset(self, method, v)
	return v
end

---@param method string
---@param params table
function notifyMt:__call(method, params)
	---@type lsp.Notification
	local notif = {
		jsonrpc = "2.0",
		method = method,
		params = params
	}

	ioLSP:write(notif)
end

return setmetatable(notify, notifyMt)
