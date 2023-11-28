local io_lsp = require("lsp-lib.io")
local listen = require("lsp-lib.listen")

local INT_LIMIT = 2 ^ 53

local request_set = {
	["workspace/workspaceFolders"] = true,
	["workspace/configuration"] = true,
	["workspace/foldingRange/refresh"] = true,
	["window/workDoneProgress/create"] = true,
	["workspace/semanticTokens/refresh"] = true,
	["window/showDocument"] = true,
	["workspace/inlineValue/refresh"] = true,
	["workspace/inlayHint/refresh"] = true,
	["workspace/diagnostic/refresh"] = true,
	["client/registerCapability"] = true,
	["client/unregisterCapability"] = true,
	["window/showMessageRequest"] = true,
	["workspace/codeLens/refresh"] = true,
	["workspace/applyEdit"] = true,
}

---@type integer
local id = 1

---@type lsp*.Request
local request = {}

local request_mt = {}

function request_mt:__index(method)
	if not request_set[method] then
		error(string.format("attempt to retrieve unknown request method '%s'", method))
	end

	local v = function(params) return request(method, params) end
	rawset(self, method, v)
	return v
end

function request_mt:__call(method, params)
	listen.waiting_threads[id] = coroutine.running()

	---@type lsp.Request
	local req = {
		jsonrpc = "2.0",
		id = id,
		method = method,
		params = params,
	}

	id = (id + 1) % INT_LIMIT

	io_lsp:write(req)

	return coroutine.yield()
end

return setmetatable(request, request_mt)
