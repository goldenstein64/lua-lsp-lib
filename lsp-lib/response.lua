local null = require("cjson").null

local noop = function() end

---@type lsp*.Response
local defaults = {}

defaults["initialize"] = function(params)
	return { capabilities = {} }
end

defaults["initialized"] = noop

defaults["shutdown"] = function(params)
	return null
end

defaults["exit"] = noop

---a key-value mapping of LSP methods to functions that get called when a
---request or notification with that method is received
---
---There are default implementations for the `initialize`, `shutdown` and
---`exit` methods, but it is recommended to at least implement `initialize` so
---that the server's capabilities can be modified.
---
---All the logic for filtering requests and closing when the `exit`
---notification is received is already implemented, but implementations for
---e.g. storing and changing data is left up to the user.
---@class lsp*.Response
local response = {}

setmetatable(response, { __index = defaults })

return response
