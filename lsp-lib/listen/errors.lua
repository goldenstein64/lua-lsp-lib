local null = require("cjson").null
local ErrorCodes = require("lsp-lib.enum.ErrorCodes")

---holds utility functions for generating LSP response errors that `listen()`
---uses.
---
---It holds all the types of errors
---that may occur while listening to requests. See the
---[`ErrorCodes`](lua://lsp.ErrorCodes) enum and
---[LSP specification](https://microsoft.github.io/language-server-protocol/specifications/lsp/3.17/specification/)
---for more information.
local errors = {}

---@param msg? string
---@return lsp.Response
function errors.ParseError(msg)
	return {
		jsonrpc = "2.0",
		id = null, -- if the request couldn't be parsed, we don't know the id

		error = {
			code = ErrorCodes.ParseError,
			message = msg and string.format("Parse Error: %s", msg)
				or "Parse Error",
		},
	}
end

---@param id? string | number | cjson.null
---@param methodName? string
---@return lsp.Response
function errors.MethodNotFound(id, methodName)
	return {
		jsonrpc = "2.0",
		id = id or null,

		error = {
			code = ErrorCodes.MethodNotFound,
			message = methodName
					and string.format("Method Not Found: '%s'", methodName)
				or "Method Not Found",
		},
	}
end

---@param id? string | number | cjson.null
---@param methodName? string
---@return lsp.Response
function errors.InvalidRequest(id, methodName)
	return {
		jsonrpc = "2.0",
		id = id or null,

		error = {
			code = ErrorCodes.InvalidRequest,
			message = methodName
					and string.format("Invalid Request: '%s'", methodName)
				or "Invalid Request",
		},
	}
end

---@param id? string | number | cjson.null
---@return lsp.Response
function errors.ServerNotInitialized(id)
	return {
		jsonrpc = "2.0",
		id = id or null,

		error = {
			code = ErrorCodes.ServerNotInitialized,
			message = "Server Not Initialized",
		},
	}
end

---This is treated as a fallback for any unhandled errors in a response.
---@param id? string | integer
---@param msg? string
---@return lsp.Response
function errors.general(id, msg)
	return {
		jsonrpc = "2.0",
		id = id or null,

		error = {
			code = ErrorCodes.InternalError,
			message = msg and string.format("Internal Error: %s", msg)
				or "Internal Error",
		},
	}
end

return errors
