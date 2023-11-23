local json = require("cjson")

---@type lsp*.Response
local response = {}

response["initialize"] = function(params)
	return { capabilities = {} }
end

response["shutdown"] = function(params)
	return json.null
end

response["exit"] = function(params)
	os.exit(0)
end

return response
