local json = require("cjson")

---@type lsp*.Response
local defaults = {}

defaults["initialize"] = function(params)
	return { capabilities = {} }
end

defaults["shutdown"] = function(params)
	return json.null
end

return setmetatable({}, { __index = defaults }) --[[@as lsp*.Response]]
