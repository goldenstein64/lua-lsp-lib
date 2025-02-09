local null = require("cjson").null
local MessageType = require("lsp-lib.enum.MessageType")

local io_lsp = require("lsp-lib.io")

local request_state = require("lsp-lib.request.state")

local message_type_map = {
	error = MessageType.Error,
	warn = MessageType.Warning,
	info = MessageType.Info,
	log = MessageType.Log,
	debug = MessageType.Debug,
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

---sends LSP requests to the client. Requests block the current thread and
---return the response's result xor error object.
---[`lsp-lib.async`](lua://lsp-lib.Async) is provided for sending requests
---asynchronously.
---
---When in a response function, `assert`ing the request will echo the client's
---response back as-is, which is likely unintended behavior. Instead, take the
---message and wrap it in a meaningful `InternalError`.
---
---```lua
---local ErrorCodes = require("lsp-lib.enum.ErrorCodes")
---local lsp = require("lsp-lib")
---
---lsp.response["initialized"] = function(params)
---  local config, err = lsp.request.config()
---  if err then
---    error({
---      code = ErrorCodes.InternalError,
---      message = "Error in `initialized` handler: " .. err.message,
---    })
---  end
---
---  -- process config safely
---end
---```
---
---When indexed with an LSP-specified method, it returns a function that takes
---a `params` argument. This form is entirely type-checked by LuaLS.
---
---When `request` is called, it takes an LSP-specified `method` argument and a
---`params` argument. This form is very loosely type-checked by LuaLS and is
---typically used by other request functions.
---
---This table also contains utility functions for all LSP-specified methods.
---
---Example:
---
---```lua
----- three ways to send a `workspace/configuration` request:
---
----- calling `request`, loosely typed
---local config, err = lsp.request('workspace/configuration', {
---  items = { { section = "server.config" } },
---})
---
----- indexing `request`, strictly typed with Intellisense
---local config, err = lsp.request['workspace/configuration'] {
---  items = { { section = "server.config" } },
---}
---
----- calling `request.config`, strictly typed with Intellisense
---local config, err = lsp.request.config( { section = "server.config" } )
---```
---@class lsp-lib.Request
---@field show lsp-lib.Request.show
local request = {

	---shows a `message` to the user with the given message `[type]` by sending
	---a [`window/showMessageRequest` request](https://microsoft.github.io/language-server-protocol/specifications/lsp/3.17/specification/#window_showMessageRequest).
	---`[type]` must be one of the five message types corresponding to
	---the `MessageType` enum: `debug`, `log`, `info`, `warn`, and `error`. On
	---success, the request returns one of the strings chosen from the
	---`...actions` tuple or `cjson.null` if none were chosen. Otherwise, `nil`
	---is returned followed by a response error.
	---
	---Example:
	---
	---```lua
	---local chosen_action, err = request.show.warn(
	---  "Restart language server?", -- message
	---  "Yes", "No" -- choices
	---)
	---
	---if err then
	---  -- same behavior as choosing nothing
	---  chosen_action = cjson.null
	---end
	---
	---if chosen_action == "Yes" then
	---  restart_the_language_server()
	---end
	---```
	---@class lsp-lib.Request.show
	---@field log fun(message: string, ...: string): (result: lsp.Response.window-showMessageRequest.result?, error: lsp.Response.window-showMessageRequest.error?)
	---@field info fun(message: string, ...: string): (result: lsp.Response.window-showMessageRequest.result?, error: lsp.Response.window-showMessageRequest.error?)
	---@field error fun(message: string, ...: string): (result: lsp.Response.window-showMessageRequest.result?, error: lsp.Response.window-showMessageRequest.error?)
	---@field warn fun(message: string, ...: string): (result: lsp.Response.window-showMessageRequest.result?, error: lsp.Response.window-showMessageRequest.error?)
	---@field debug fun(message: string, ...: string): (result: lsp.Response.window-showMessageRequest.result?, error: lsp.Response.window-showMessageRequest.error?)
	show = {},
}

for k, type in pairs(message_type_map) do
	request.show[k] = function(message, ...)
		---@type lsp.MessageActionItem[] | nil
		local actions = nil
		if select("#", ...) > 0 then
			actions = {}
			for _, title in ipairs({ ... }) do
				table.insert(actions, { title = tostring(title) })
			end
		end

		---@type lsp.Request.window-showMessageRequest.params
		local params = {
			message = tostring(message),
			type = type,
			actions = actions,
		}

		local response, err = request("window/showMessageRequest", params)
		if response then
			return response == null and null or response.title
		else
			return response, err
		end
	end
end

---sends a `workspace/*/refresh` request where `*` is the key
request.refresh = {
	---asks for all folding ranges to be re-calculated by sending a
	---[`workspace/foldingRange/refresh` request](https://microsoft.github.io/language-server-protocol/specifications/lsp/3.18/specification/#workspace_foldingRange_refresh)
	---@return lsp.Response.workspace-foldingRange-refresh.result? result
	---@return lsp.Response.workspace-foldingRange-refresh.error? error
	folding_range = function()
		return request("workspace/foldingRange/refresh", null)
	end,

	---asks for all semantic token highlighting to be re-calculated by sending a
	---[`workspace/semanticTokens/refresh` request](https://microsoft.github.io/language-server-protocol/specifications/lsp/3.17/specification/#semanticTokens_refreshRequest)
	---@return lsp.Response.workspace-semanticTokens-refresh.result? result
	---@return lsp.Response.workspace-semanticTokens-refresh.error? error
	semantic_tokens = function()
		return request("workspace/semanticTokens/refresh", null)
	end,

	---asks for all inline values to be re-calculated by sending a
	---[`workspace/inlineValue/refresh` request](https://microsoft.github.io/language-server-protocol/specifications/lsp/3.17/specification/#workspace_inlineValue_refresh)
	---@return lsp.Response.workspace-inlineValue-refresh.result? result
	---@return lsp.Response.workspace-inlineValue-refresh.error? error
	inline_value = function()
		return request("workspace/inlineValue/refresh", null)
	end,

	---asks for all inlay hints to be re-calculated by sending a
	---[`workspace/inlayHint/refresh` request](https://microsoft.github.io/language-server-protocol/specifications/lsp/3.17/specification/#workspace_inlayHint_refresh)
	---@return lsp.Response.workspace-inlayHint-refresh.result? result
	---@return lsp.Response.workspace-inlayHint-refresh.error? error
	inlay_hint = function()
		return request("workspace/inlayHint/refresh", null)
	end,


	---asks for all workspace and document diagnostics to be re-calculated by
	---sending a
	---[`workspace/diagnostic/refresh` request](https://microsoft.github.io/language-server-protocol/specifications/lsp/3.17/specification/#diagnostic_refresh)
	---@return lsp.Response.workspace-diagnostic-refresh.result? result
	---@return lsp.Response.workspace-diagnostic-refresh.error? error
	diagnostic = function()
		return request("workspace/diagnostic/refresh", null)
	end,

	---asks for all code lenses to be re-calculated by sending a
	---[`workspace/codeLens/refresh` request](https://microsoft.github.io/language-server-protocol/specifications/lsp/3.17/specification/#codeLens_refresh)
	---@return lsp.Response.workspace-codeLens-refresh.result? result
	---@return lsp.Response.workspace-codeLens-refresh.error? error
	code_lens = function()
		return request("workspace/codeLens/refresh", null)
	end,
}

---asks the client for the specified settings values by sending a
---[`workspace/configuration` request](https://microsoft.github.io/language-server-protocol/specifications/lsp/3.17/specification/#workspace_configuration).
---A corresponding item is received for each item requested.
---@param item lsp.ConfigurationItem
---@param ... lsp.ConfigurationItem
---@return lsp.Response.workspace-configuration.result? result
---@return lsp.Response.workspace-configuration.error? error
function request.config(item, ...)
	return request("workspace/configuration", { items = { item, ... } })
end

---fetches a current open list of workspace folders by sending a
---[`workspace/workspaceFolders` request](https://microsoft.github.io/language-server-protocol/specifications/lsp/3.17/specification/#workspace_workspaceFolders)
---@return lsp.Response.workspace-workspaceFolders.result? result
---@return lsp.Response.workspace-workspaceFolders.error? error
function request.workspace_folders()
	return request("workspace/workspaceFolders", null)
end

---asks the client to create a work done progress by sending a
---[`window/workDoneProgress/create` request](https://microsoft.github.io/language-server-protocol/specifications/lsp/3.17/specification/#window_workDoneProgress_create)
---@param token lsp.ProgressToken
---@return lsp.Response.window-workDoneProgress-create.result? result
---@return lsp.Response.window-workDoneProgress-create.error? error
function request.create_work_done_progress(token)
	return request("window/workDoneProgress/create", { token = token })
end

---@class lsp-lib.request.show_document.Options
---Should this document be shown in an external program? e.g. display a website
---link in a browser instead of the editor.
---@field external? boolean
---Should this document take editor focus? Clients might ignore this property if
---an external program is started.
---@field takeFocus? boolean
---Indicates which part of the resource the editor should show. Make sure to
---generate an LSP-compliant object for this property using
---`require("lsp-lib.transform.range").to_lsp`.
---@field selection? lsp.Range

---asks the client to display a resource at the `uri` by sending a
---[`window/showDocument` request](https://microsoft.github.io/language-server-protocol/specifications/lsp/3.17/specification/#window_showDocument)
---@param uri lsp.URI -- the URI to show
---@param options? lsp-lib.request.show_document.Options -- a table of options
---@return boolean? success -- whether the document was successfully shown
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

	local result, error = request("window/showDocument", params)
	if result then
		result = result.success
	end

	return result, error
end

---requests the client to apply edits to the opened documents specified in
---`edit` by sending a
---[`workspace/applyEdit` request](https://microsoft.github.io/language-server-protocol/specifications/lsp/3.17/specification/#workspace_applyEdit)
---
---> **Note**: If the `edit` argument contains a `changes` table or a
---> `documentChanges` table with `edits` entries, it is recommended to send
---> their corresponding `range` fields using
---> `require("lsp-lib.transform.range").to_lsp()` to create an LSP-compliant
---> Range object.
---@param edit lsp.WorkspaceEdit
---@param label? string -- the edit's name, e.g. to use in the editor's undo stack
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
	---dynamically registers a server capability with the client by sending a
	---[`client/registerCapability` request](https://microsoft.github.io/language-server-protocol/specifications/lsp/3.17/specification/#client_registerCapability)
	---
	---A `Registration` object has the same structure as the
	---[`Registration` interface](https://microsoft.github.io/language-server-protocol/specifications/lsp/3.17/specification/#registration)
	---in the LSP specification.
	---@param registration lsp.Registration
	---@param ... lsp.Registration
	---@return lsp.Response.client-registerCapability.result? result
	---@return lsp.Response.client-registerCapability.error? error
	register = function(registration, ...)
		---@type lsp.Request.client-registerCapability.params
		local params = { registrations = { registration, ... } }
		return request("client/registerCapability", params)
	end,

	---dynamically unregisters a server capability with the client by sending a
	---[`client/unregisterCapability` request](https://microsoft.github.io/language-server-protocol/specifications/lsp/3.17/specification/#client_unregisterCapability)
	---
	---An `Unregistration` object has the same structure as the
	---[`Unregistration` interface](https://microsoft.github.io/language-server-protocol/specifications/lsp/3.17/specification/#unregistration)
	---in the LSP specification.
	---@param unregistration lsp.Unregistration
	---@param ... lsp.Unregistration
	---@return lsp.Response.client-unregisterCapability.result? result
	---@return lsp.Response.client-unregisterCapability.error? error
	unregister = function(unregistration, ...)
		---@type lsp.Request.client-unregisterCapability.params
		local params = { unregisterations = { unregistration, ... } }

		return request("client/unregisterCapability", params)
	end,
}

for _, method in ipairs(requests) do
	---@diagnostic disable-next-line: assign-type-mismatch
	request[method] = function(params)
		return request(method, params)
	end
end

local request_mt = {}

function request_mt:__index(method)
	error(
		string.format("attempt to retrieve unknown request method '%s'", method)
	)
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
