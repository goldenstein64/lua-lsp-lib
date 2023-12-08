local null = require("cjson").null
local MessageType = require("lsp-lib.enum.MessageType")

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
	"workspace/foldingRange/refresh", -- .refresh.folding_range
	"workspace/semanticTokens/refresh", -- .refresh.semantic_tokens
	"workspace/inlineValue/refresh", -- .refresh.inline_value
	"workspace/inlayHint/refresh", -- .refresh.inlay_hint
	"workspace/diagnostic/refresh", -- .refresh.diagnostic
	"workspace/codeLens/refresh", -- .refresh.code_lens
}

---sends requests to the client. Requests block the current thread and return
---the response's result and error object. `lsp-lib.async` is provided for
---sending requests asynchronously.
---
---When indexed with an LSP-specified method, it returns a function that takes
---a `params` argument. This form is entirely type-checked by LuaLS.
---
---When `request` is called, it takes an LSP-specified `method` argument and a
---`params` argument with fields specified in `lsp.d.lua`. This form is very
---loosely type-checked by LuaLS and is typically used by other request
---functions.
---
---This table also contains utility functions for all LSP-specified methods.
---
---Example:
---
---```lua
----- three ways to send a `workspace/configuration` request:
---
----- calling `request`, loosely typed
---local result = lsp.request('workspace/configuration', {
---  items = { { section = "Namespace" } },
---})
---
----- indexing `request`, strictly typed with Intellisense
---local result = lsp.request['workspace/configuration'] {
---  items = { { section = "Namespace" } },
---}
---
----- calling `request.config`, strictly typed with Intellisense
---local result = lsp.request.config( { section = "Namespace" } )
---```
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
		return request("workspace/foldingRange/refresh", null)
	end,

	---@return lsp.Response.workspace-semanticTokens-refresh.result? result
	---@return lsp.Response.workspace-semanticTokens-refresh.error? error
	semantic_tokens = function()
		return request("workspace/semanticTokens/refresh", null)
	end,

	---@return lsp.Response.workspace-inlineValue-refresh.result? result
	---@return lsp.Response.workspace-inlineValue-refresh.error? error
	inline_value = function()
		return request("workspace/inlineValue/refresh", null)
	end,

	---@return lsp.Response.workspace-inlayHint-refresh.result? result
	---@return lsp.Response.workspace-inlayHint-refresh.error? error
	inlay_hint = function()
		return request("workspace/inlayHint/refresh", null)
	end,

	---@return lsp.Response.workspace-diagnostic-refresh.result? result
	---@return lsp.Response.workspace-diagnostic-refresh.error? error
	diagnostic = function()
		return request("workspace/diagnostic/refresh", null)
	end,

	---@return lsp.Response.workspace-codeLens-refresh.result? result
	---@return lsp.Response.workspace-codeLens-refresh.error? error
	code_lens = function()
		return request("workspace/codeLens/refresh", null)
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
---
---Note: If `selection` is provided in the `options` argument, it's recommended
---to send it through `lsp-lib.transform.range`'s `to_lsp` function to create
---an LSP-compliant range object.
---@param uri lsp.URI -- The uri to show.
---@param options? lsp*.Request.show_document.options
---@return lsp.Response.window-showDocument.result? result
---@return lsp.Response.window-showDocument.error? error
function request.show_document(uri, options)
	---@type lsp.Request.window-showDocument.params
	local params
	if options then
		params = {
			uri = uri,
			external = options.external,
			takeFocus = options.takeFocus,
			selection = options.selection,
		}
	else
		params = { uri = uri }
	end

	return request("window/showDocument", params)
end

---sends a `workspace/applyEdit` request
---
---Note: If the `edit` argument contains a `changes` table or a
---`documentChanges` table with `edits` entries, it is recommended to send
---their corresponding `range` fields through `lsp-lib.transform.range`'s
---`to_lsp` function to create an LSP-compliant range object.
---@param edit lsp.WorkspaceEdit
---@param label? string
---@return lsp.Response.workspace-applyEdit.result? result
---@return lsp.Response.workspace-applyEdit.error? error
function request.apply_edit(edit, label)
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
