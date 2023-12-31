local json = require("cjson")
local ErrorCodes = require("lsp-lib.enum.ErrorCodes")

---a table of response object constructors
---
---It holds all the types of errors
---that may occur while listening to requests. See the `ErrorCodes` enum and
---[LSP specification](https://microsoft.github.io/language-server-protocol/specifications/lsp/3.17/specification/)
---for more information.
local errors = {}

---@param msg? string
---@return lsp.Response
function errors.ParseError(msg)
	return {
		id = json.null, -- if the request couldn't be parsed, we don't know the id

		error = {
			code = ErrorCodes.ParseError,
			message = string.format("parse error: %s", msg or "unknown cause"),
		},
	}
end

---@param id? string | number | cjson.null
---@param methodName? string
---@return lsp.Response
function errors.MethodNotFound(id, methodName)
	return {
		id = id or json.null,

		error = {
			code = ErrorCodes.MethodNotFound,
			message = string.format("invoked an unknown protocol '%s'", methodName or ""),
		},
	}
end

---@param id? string | number | cjson.null
---@param methodName? string
---@return lsp.Response
function errors.InvalidRequest(id, methodName)
	return {
		id = id or json.null,

		error = {
			code = ErrorCodes.InvalidRequest,
			message = string.format("cannot respond to protocol '%s'", methodName or ""),
		},
	}
end

---@param id? string | number | cjson.null
---@return lsp.Response
function errors.ServerNotInitialized(id)
	return {
		id = id or json.null,

		error = {
			code = ErrorCodes.ServerNotInitialized,
			message = "the server is not yet initialized",
		},
	}
end

---This is treated as a fallback for any unhandled errors in a response.
---@param id? string | integer
---@param message? string
---@return lsp.Response
function errors.general(id, message)
	return {
		id = id or json.null,

		error = {
			code = ErrorCodes.InternalError,
			message = message or "request failed",
		},
	}
end

return errors
