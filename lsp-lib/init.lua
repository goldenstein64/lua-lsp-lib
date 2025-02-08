local io_lsp = require("lsp-lib.io")

---the "Sprint Boot" of the API. It gives all the functionality needed to build
---a typical LSP server.
---
---Example:
---
---```lua
---local null = require('cjson').null
---local lsp = require('lsp-lib')
---
----- this allows adding fields to the type
------@class lsp*.Request
---lsp.request = lsp.request
---
----- 'initialize' should auto-complete well enough under LuaLS
---lsp.response['initialize'] = function(params)
---
---  -- annotation is needed here due to a shortcoming of LuaLS
---  ---@type lsp.Response.initialize.result
---  return { capabilities = {} }
---end
---
---lsp.response['initialized'] = function()
---  -- utility notify functions are provided
---  lsp.notify.log.info(os.date())
---
---  -- make a blocking LSP request
---  lsp.config = assert(lsp.request.config())
---end
---
---lsp.response['shutdown'] = function()
---  -- notify the client of something
---  lsp.notify['$/cancelRequest'] { id = 0 }
---  -- there is also a library function for this
---  lsp.notify.cancel_request(0)
---
---  return null
---end
---
----- define your own request function
---function lsp.request.custom_request(foo, bar)
---  return lsp.request('$/customRequest', { foo = foo, bar = bar })
---end
---
----- turn on debugging
----- currently logs anything received by or sent from this server
---lsp.debug(true)
---
----- starts a loop that listens to stdio
---lsp.listen()
---```
---@class lsp*
---@field notify lsp*.Notify
---@field request lsp*.Request
---@field response lsp*.Response
---@field listen lsp*.Listen
---@field async lsp*.Async
local lsp = {
	notify = require("lsp-lib.notify"),
	request = require("lsp-lib.request"),
	response = require("lsp-lib.response"),
	listen = require("lsp-lib.listen"),
	async = require("lsp-lib.async"),
}

---sets debug mode to its boolean `setting` parameter. Right now, its only
---effect is logging all messages that are read from and written to the server.
---@param setting boolean
function lsp.debug(setting)
	if setting then
		local dbg = require("lsp-lib.io.debug")
		io_lsp.read_callback = dbg.read
		io_lsp.write_callback = dbg.write
	else
		io_lsp.read_callback = nil
		io_lsp.write_callback = nil
	end
end

return lsp
