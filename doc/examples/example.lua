-- in Lua,
local null = require("cjson").null
local lsp = require("lsp-lib")

-- this allows adding fields to the type
---@class lsp*.Request
lsp.request = lsp.request

-- 'initialize' should auto-complete well enough under LuaLS
lsp.response["initialize"] = function(params)
	-- annotation is needed here due to a shortcoming of LuaLS
	---@type lsp.Response.initialize.result
	return { capabilities = {} }
end

lsp.response["initialized"] = function()
	-- utility notify functions are provided
	lsp.notify.log.info(os.date())

	-- make a blocking LSP request
	lsp.config = assert(lsp.request.config({ section = "server.config" }))
end

lsp.response["shutdown"] = function()
	-- notify the client of something
	lsp.notify["$/cancelRequest"]({ id = 0 })

	return null
end

-- define your own request function
function lsp.request.custom_request(foo, bar)
	return lsp.request("$/customRequest", { foo = foo, bar = bar })
end

-- turn on debugging
-- currently logs anything received by or sent from this server
lsp.debug(true)

-- starts a loop that listens to stdio
lsp.listen()
