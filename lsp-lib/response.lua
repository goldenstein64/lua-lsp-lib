local json = require("cjson")

local noop = function() end

---@type lsp*.Response
local defaults = {}

defaults["initialize"] = function(params)
	return { capabilities = {} }
end

defaults["initialized"] = noop

defaults["shutdown"] = function(params)
	return json.null
end

defaults["exit"] = noop

return setmetatable({}, { __index = defaults }) --[[@as lsp*.Response]]
