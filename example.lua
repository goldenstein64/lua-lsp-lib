-- in Lua,
local null = require('cjson').null
local lsp = require('lsp-lib')

---@class lsp*.Request
lsp.request = lsp.request

-- 'initialize' should auto-complete well enough under LuaLS
lsp.response['initialize'] = function(params)
	lsp.async(function()
		-- make a blocking LSP request
		lsp.config = assert(lsp.request.config())
	end)

	-- utility notify functions are provided too
	lsp.notify.log.info(os.date())

	-- annotation is needed here due to a shortcoming of LuaLS
	---@type lsp.Response.initialize.result
	return { capabilities = {} }
end

lsp.response['shutdown'] = function()
	-- notify the client of something
	lsp.notify['$/cancelRequest'] { id = 0 }

  return null
end

-- define your own request function
function lsp.request.custom_request(foo, bar)
	return lsp.request('$/customRequest', { foo = foo, bar = bar })
end

-- turn on debugging
-- currently logs anything received by or sent from this server
lsp.debug(true)

-- starts a loop that listens to stdio
lsp.listen()
