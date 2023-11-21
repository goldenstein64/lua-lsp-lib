local ioLSP = require("lsp-lib.io")
local handle = require("lsp-lib.handle")

local INT_LIMIT = 2 ^ 53

local requestSet = {
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
local id = 0

---@type lsp*.Request
local request = {}

local requestMt = {}

function requestMt:__index(method)
	if not requestSet[method] then
		error(string.format("attempt to retrieve unknown request method '%s'", method))
	end

	local v = function(params) return request(method, params) end
	rawset(self, method, v)
	return v
end

function requestMt:__call(method, params)
	handle.waitingThreads[id] = coroutine.running()

	---@type lsp.Request
	local req = {
		jsonrpc = "2.0",
		id = id,
		method = method,
		params = params,
	}

	id = (id + 1) % INT_LIMIT

	ioLSP:write(req)

	return coroutine.yield()
end

return setmetatable(request, requestMt)
