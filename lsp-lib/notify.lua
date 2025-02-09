local io_lsp = require("lsp-lib.io")
local MessageType = require("lsp-lib.enum.MessageType")

local notifications = {
	"window/showMessage", -- .show.*
	"window/logMessage", -- .log.*
	"telemetry/event", -- .telemetry
	"textDocument/publishDiagnostics", -- .diagnostics
	"$/logTrace", -- .log_trace
	"$/cancelRequest", -- .cancel_request
	"$/progress", -- .progress
}

---@enum (key) lsp-lib.MessageType
local message_type_map = {
	error = MessageType.Error,
	warn = MessageType.Warning,
	info = MessageType.Info,
	log = MessageType.Log,
	debug = MessageType.Debug,
}

---sends notifications to the client. Unlike requests, notifications never
---block the current thread and return nothing.
---
---When indexed with an LSP-specified method, it returns a function that takes
---a `params` argument. This form is entirely type-checked by LuaLS.
---
---When `notify` is called, it takes an LSP-specified `method` argument and a
---`params` argument. This form is loosely type-checked by LuaLS and is
---typically used by other notification functions.
---
---This table also contains utility functions for all LSP-specified methods.
---
---Example:
---
---```lua
----- three ways to send a `window/logMessage` notification:
---
---local MessageType = require('lsp-lib.enum.MessageType')
---
----- calling `notify`, loosely typed
---notify('window/logMessage', {
---  type = MessageType.Info,
---  message = "server version: X.Y.Z",
---})
---
----- indexing `notify`, strictly typed with Intellisense
---notify['window/logMessage'] {
---  type = MessageType.Info,
---  message = "server version: X.Y.Z",
---}
---
----- calling `notify.log.*`, strictly typed with Intellisense
---notify.log.info("server version: X.Y.Z")
---```
---@class lsp-lib.Notify
---@field log lsp-lib.Notify.log
---@field show lsp-lib.Notify.show
local notify = {
	---sends a `window/logMessage` notification, where the message type is the
	---key
	---@class lsp-lib.Notify.log
	---@field error fun(message: string)
	---@field warn fun(message: string)
	---@field info fun(message: string)
	---@field log fun(message: string)
	---@field debug fun(message: string)
	log = {},

	---sends a `window/showMessage` notification, where the message type is the
	---key
	---@class lsp-lib.Notify.show
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

---sends a `$/logTrace` notification
---@param message string
---@param verbose? string
function notify.log_trace(message, verbose)
	notify("$/logTrace", { message = message, verbose = verbose })
end

---sends a
---[`telemetry/event` notification](https://microsoft.github.io/language-server-protocol/specifications/lsp/3.17/specification/#telemetry_event)
---to the client, which is meant to help monitor performance and other
---statistics about the language server
---@param data lsp.LSPAny
function notify.telemetry(data)
	notify("telemetry/event", data)
end

---reports progress on an arbitrary task by sending a
---[`$/progress` notification](https://microsoft.github.io/language-server-protocol/specifications/lsp/3.17/specification/#progress)
---@param token lsp.ProgressToken
---@param value lsp.LSPAny
function notify.progress(token, value)
	notify("$/progress", { token = token, value = value })
end

---cancels a request a client is currently processing with the given `id` by
---sending a
---[`$/cancelRequest` notification](https://microsoft.github.io/language-server-protocol/specifications/lsp/3.17/specification/#cancelRequest).
---Should the client respect it, a response will be returned with either partial
---data or an error message.
---
---Request id's can currently be retrieved by reading `request_state.id` right
---before sending a request.
---
---```lua
---local request_state = require('lsp-lib.request.state')
---
----- ...
---
---local id = request_state.id
---lsp.async(function()
---  local ok, error = lsp.request.refresh.code_lens()
---  print(ok, error)
---end)
---
----- makes the above async function print `nil table: 0x1234...`.
---lsp.notify.cancel_request(id)
---```
---@param id string | integer
function notify.cancel_request(id)
	notify("$/cancelRequest", { id = id })
end

---publishes diagnostics about a particular file by sending a
---[`textDocument/publishDiagnostics` notification](https://microsoft.github.io/language-server-protocol/specifications/lsp/3.17/specification/#textDocument_publishDiagnostics)
---
---Note: It is recommended to send each diagnostic object's `range` field
---through `lsp-lib.transform.range`'s `to_lsp` function to create an
---LSP-compliant range object.
---@param uri lsp.URI
---@param diagnostics lsp.Diagnostic[]
---@param version? integer
function notify.diagnostics(uri, diagnostics, version)
	notify(
		"textDocument/publishDiagnostics",
		{ uri = uri, diagnostics = diagnostics, version = version }
	)
end

for _, method in pairs(notifications) do
	---@diagnostic disable-next-line: assign-type-mismatch
	notify[method] = function(params)
		notify(method, params)
	end
end

local notify_mt = {}

function notify_mt:__index(method)
	error(
		string.format(
			"attempt to retrieve unknown notification method '%s'",
			method
		)
	)
end

---@param method string
---@param params table
function notify_mt:__call(method, params)
	---@type lsp.Notification
	local notification = {
		jsonrpc = "2.0",
		method = method,
		params = params,
	}

	io_lsp:write(notification)
end

return setmetatable(notify, notify_mt)
