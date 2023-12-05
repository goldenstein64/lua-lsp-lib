local null = require("cjson").null
local MessageType = require("lsp-lib.enum.MessageType")

local transform_range = require("lsp-lib.transform.range")

local io_lsp = require("lsp-lib.io")

local request_state = require("lsp-lib.request.state")

local message_type_map = {
	error = MessageType.Error,
	warn = MessageType.Warning,
	info = MessageType.Info,
	log = MessageType.Log,
	debug = MessageType.Debug
}

local INT_LIMIT = 2 ^ 53

local requests = {
	"workspace/workspaceFolders", -- .workspace_folders
	"workspace/configuration", -- .config
	"window/showMessageRequest", -- .show.*
	"window/workDoneProgress/create", -- .create_work_done_progress
	"window/showDocument", -- .show_document
	"client/registerCapability", -- .capability.register
	"client/unregisterCapability", -- .capability.unregister
	"workspace/applyEdit", -- .apply_edit
	"workspace/foldingRange/refresh", -- .refresh.*
	"workspace/semanticTokens/refresh", -- .refresh.*
	"workspace/inlineValue/refresh", -- .refresh.*
	"workspace/inlayHint/refresh", -- .refresh.*
	"workspace/diagnostic/refresh", -- .refresh.*
	"workspace/codeLens/refresh", -- .refresh.*
}

---sends requests to the client. All requests block the current thread and
---return the response's result and error object. An `async` utility is
---provided for sending requests asynchronously.
---
---When indexed with an LSP-specified method, it returns a function that takes
---a `params` argument. This form is entirely type-checked by LuaLS.
---
---When `request` is called, it takes an LSP-specified `method` argument and a
---`params` argument with fields specified in `lsp.d.lua`. This form is very
---loosely type-checked by LuaLS and is typically used by other request
---functions.
---
---This table also contains utility functions for common requests like getting
---the client's configuration.
---@class lsp*.Request
local request = {

	---sends a `window/showMessageRequest`, where the message type is the key
	---@class lsp*.Request.show
	---@field log fun(message: string, actions: lsp.MessageActionItem[]): lsp.MessageActionItem
	---@field info fun(message: string, actions: lsp.MessageActionItem[]): lsp.MessageActionItem
	---@field error fun(message: string, actions: lsp.MessageActionItem[]): lsp.MessageActionItem
	---@field warn fun(message: string, actions: lsp.MessageActionItem[]): lsp.MessageActionItem
	---@field debug fun(message: string, actions: lsp.MessageActionItem[]): lsp.MessageActionItem
	show = {},
}

for k, type in pairs(message_type_map) do
	request.show[k] = function(message, actions)
		return request("window/showMessageRequest", {
			message = message,
			type = type,
			actions = actions
		})
	end
end

---sends a `workspace/*/refresh` request where `*` is the key
request.refresh = {
	---@return lsp.Response.workspace-foldingRange-refresh.result? result
	---@return lsp.Response.workspace-foldingRange-refresh.error? error
	folding_range = function()
		return request["workspace/foldingRange/refresh"](null)
	end,

	---@return lsp.Response.workspace-semanticTokens-refresh.result? result
	---@return lsp.Response.workspace-semanticTokens-refresh.error? error
	semantic_tokens = function()
		return request["workspace/semanticTokens/refresh"](null)
	end,

	---@return lsp.Response.workspace-inlineValue-refresh.result? result
	---@return lsp.Response.workspace-inlineValue-refresh.error? error
	inline_value = function()
		return request["workspace/inlineValue/refresh"](null)
	end,

	---@return lsp.Response.workspace-inlayHint-refresh.result? result
	---@return lsp.Response.workspace-inlayHint-refresh.error? error
	inlay_hint = function()
		return request["workspace/inlayHint/refresh"](null)
	end,

	---@return lsp.Response.workspace-diagnostic-refresh.result? result
	---@return lsp.Response.workspace-diagnostic-refresh.error? error
	diagnostic = function()
		return request["workspace/diagnostic/refresh"](null)
	end,

	---@return lsp.Response.workspace-codeLens-refresh.result? result
	---@return lsp.Response.workspace-codeLens-refresh.error? error
	code_lens = function()
		return request["workspace/codeLens/refresh"](null)
	end,
}

---sends a `workspace/configuration` request, returning the specified settings
---@param ... lsp.ConfigurationItem
---@return lsp.Response.workspace-configuration.result? result
---@return lsp.Response.workspace-configuration.error? error
function request.config(...)
	return request("workspace/configuration", { items = { ... } })
end

---The `workspace/workspaceFolders` request is sent from the server to the client to
---fetch the open workspace folders.
---@return lsp.Response.workspace-workspaceFolders.result? result
---@return lsp.Response.workspace-workspaceFolders.error? error
function request.workspace_folders()
	return request("workspace/workspaceFolders", null)
end

---sends a `window/workDoneProgress/create` request
---@param token lsp.ProgressToken
---@return lsp.Response.window-workDoneProgress-create.result? result
---@return lsp.Response.window-workDoneProgress-create.error? error
function request.create_work_done_progress(token)
	return request("window/workDoneProgress/create", { token = token })
end

---@class lsp*.Request.show_document.options
---Indicates to show the resource in an external program. To show, for example,
---`https://code.visualstudio.com/` in the default WEB browser set `external`
---to `true`.
---@field external? boolean
---An optional property to indicate whether the editor showing the document
---should take focus or not. Clients might ignore this property if an external
---program is started.
---@field takeFocus? boolean
---An optional selection range if the document is a text document. Clients
---might ignore the property if an external program is started or the file is
---not a text file.
---@field selection? lsp.Range

---sends a `window/showDocument` request
---@param uri lsp.URI -- The uri to show.
---@param options lsp*.Request.show_document.options
---@return lsp.Response.window-showDocument.result? result
---@return lsp.Response.window-showDocument.error? error
function request.show_document(uri, options)
	---@type lsp.Request.window-showDocument.params
	local params = {
		uri = uri,
		external = options.external,
		takeFocus = options.takeFocus,
		selection = options.selection,
	}

	return request("window/showDocument", params)
end

---sends a `workspace/applyEdit` request
---@param label string
---@param edit lsp.WorkspaceEdit
---@return lsp.Response.workspace-applyEdit.result? result
---@return lsp.Response.workspace-applyEdit.error? error
function request.apply_edit(label, edit)
	---@type lsp.Request.workspace-applyEdit.params
	local params = {
		edit = edit,
		label = label,
	}

	return request("workspace/applyEdit", params)
end

---namespace for dynamic registration of server capabilities
request.capability = {
	---sends a `client/registerCapability` request
	---@param registration lsp.Registration
	---@param ... lsp.Registration
	---@return lsp.Response.client-registerCapability.result? result
	---@return lsp.Response.client-registerCapability.error? error
	register = function(registration, ...)
		---@type lsp.Request.client-registerCapability.params
		local params = {
			registrations = { registration, ... }
		}
		return request("client/registerCapability", params)
	end,

	---sends a `client/unregisterCapability` request
	---@param unregistration lsp.Unregistration
	---@param ... lsp.Unregistration
	---@return lsp.Response.client-unregisterCapability.result? result
	---@return lsp.Response.client-unregisterCapability.error? error
	unregister = function(unregistration, ...)
		---@type lsp.Request.client-unregisterCapability.params
		local params = {
			unregisterations = { unregistration, ... }
		}

		return request("client/unregisterCapability", params)
	end
}

for _, method in ipairs(requests) do
	request[method] = function(params) return request(method, params) end
end

local request_mt = {}

function request_mt:__index(method)
	error(string.format("attempt to retrieve unknown request method '%s'", method))
end

function request_mt:__call(method, params)
	local id = request_state.id
	request_state.waiting_threads[id] = coroutine.running()

	---@type lsp.Request
	local req = {
		jsonrpc = "2.0",
		id = id,
		method = method,
		params = params,
	}

	request_state.id = (id + 1) % INT_LIMIT

	io_lsp:write(req)

	return coroutine.yield()
end

return setmetatable(request, request_mt)
