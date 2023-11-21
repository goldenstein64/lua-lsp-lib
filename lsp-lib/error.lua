local ErrorCodes = require("lsp-lib.enum.ErrorCodes")

local oldError = error

local errorMt = {}

function errorMt:__call(msg, level)
	oldError(msg, (level or 1) + 1)
end

error = {}

---@param obj lsp.ResponseError
---@param level? integer
function error.object(obj, level)
	oldError(obj, (level or 1) + 1)
end

setmetatable(error, errorMt)

local oldAssert = assert

local assertMt = {}

function assertMt:__call(...)
	return oldAssert(...)
end

assert = {}

---@generic T
---@param value T
---@param msg string
---@param code? lsp.ErrorCodes
function assert.object(value, msg, code, ...)
	if not value then
		error.object({ code = code or ErrorCodes.InternalError, message = msg })
	end

	return value, msg, code, ...
end

setmetatable(assert, assertMt)
