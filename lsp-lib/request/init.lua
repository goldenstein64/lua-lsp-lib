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
	"window/workDoneProgress/create",
	"window/showDocument",
	"client/registerCapability",
	"client/unregisterCapability",
	"workspace/applyEdit",
	"workspace/foldingRange/refresh",
	"workspace/semanticTokens/refresh",
	"workspace/inlineValue/refresh",
	"workspace/inlayHint/refresh",
	"workspace/diagnostic/refresh",
	"workspace/codeLens/refresh",
}

---@class lsp*.Request
local request = {
	---@class lsp*.Request.show
	---@field log fun(message: string, actions: lsp.MessageActionItem[]): lsp.MessageActionItem
	---@field info fun(message: string, actions: lsp.MessageActionItem[]): lsp.MessageActionItem
	---@field error fun(message: string, actions: lsp.MessageActionItem[]): lsp.MessageActionItem
	---@field warn fun(message: string, actions: lsp.MessageActionItem[]): lsp.MessageActionItem
	---@field debug fun(message: string, actions: lsp.MessageActionItem[]): lsp.MessageActionItem
	show = {},
}

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


for k, type in pairs(message_type_map) do
	request.show[k] = function(message, actions)
		return request("window/showMessageRequest", {
			message = message,
			type = type,
			actions = actions
		})
	end
end

---The 'workspace/configuration' request is sent from the server to the client to fetch a certain
---configuration setting.
---This pull model replaces the old push model were the client signaled configuration change via an
---event. If the server still needs to react to configuration changes (since the server caches the
---result of `workspace/configuration` requests) the server should register for an empty configuration
---change event and empty the cache if such an event is received.
---@param ... lsp.ConfigurationItem
---@return lsp.Response.workspace-configuration.result? result
---@return lsp.Response.workspace-configuration.error? error
function request.config(...)
	return request("workspace/configuration", { items = { ... } })
end

---The `workspace/workspaceFolders` is sent from the server to the client to fetch the open workspace folders.
---@return lsp.Response.workspace-workspaceFolders.result? result
---@return lsp.Response.workspace-workspaceFolders.error? error
function request.workspace_folders()
	return request("workspace/workspaceFolders", null)
end

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
