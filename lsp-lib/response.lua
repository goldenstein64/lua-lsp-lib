local json = require("dkjson")

local response = {} --[[@as lsp*.Response]]

response["initialize"] = function (params)
	return { capabilities = {} }
end

response["shutdown"] = function(params)
	return json.null
end

response["exit"] = function(params)
	os.exit(0)
end

return response --[[@as lsp*.Response]]
