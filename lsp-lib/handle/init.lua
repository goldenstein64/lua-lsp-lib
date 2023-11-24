local ioLSP = require("lsp-lib.io")
local MessageType = require("lsp-lib.enum.MessageType")

local notify = require("lsp-lib.notify")
local response = require("lsp-lib.response")

local errors = require("lsp-lib.handle.errors")

---@param msg string
---@param severity lsp.MessageType
local function logMessage(msg, severity)
	---@type lsp.Notification.window-logMessage.params
	local params = {
		message = msg,
		type = severity,
	}

	notify("window/logMessage", params)
end

---@operator call(): nil
local handle = {
	---@type { [thread]: lsp.Request | lsp.Notification }
	waitingThreadToReq = {},

	---@type { [integer]: thread }
	waitingThreads = {},

	state = "initialize",
	running = true,
}

---@return lsp*.AnyMessage?
local function getRequest()
	local s, req = pcall(ioLSP.read, ioLSP)
	if not s then
		ioLSP:write(errors.ParseError(req --[[@as string?]]))
	end

	return s and req or nil
end

local ERR_UNKNOWN_PROTOCOL = "invoked an unknown protocol '%s'"

---@param req lsp.Request | lsp.Notification
---@return nil | fun(params: any): any
local function getRoute(req)
	local route = response[req.method]
	local isRequired = req.method:sub(1, 1) ~= "$"
	if not route then
		local isRequest = req.id ~= nil
		if isRequest then
			if isRequired then
				ioLSP:write(errors.MethodNotFound(req.id, req.method))
				logMessage(ERR_UNKNOWN_PROTOCOL:format(req.method), MessageType.Error)
			end
		else
			logMessage(ERR_UNKNOWN_PROTOCOL:format(req.method), MessageType.Error)
		end

		return nil
	end

	return route
end

---@class lsp*.RouteError
---@field result? lsp.ResponseError
---@field msg string

---@param result lsp.ResponseError | string
---@return lsp*.RouteError
local function handleRouteError(result)
	if type(result) == "table" and result.message and result.code then
		-- graceful error, leave it alone
		return { result = result, msg = debug.traceback(result.message) }
	elseif type(result) == "string" then
		-- messy error
		return { msg = debug.traceback(result) }
	else
		-- messier error
		return { msg = debug.traceback("non-string error: " .. tostring(result)) }
	end
end

local NO_RESPONSE_ERROR = "request '%s' was not responded to"

---@param req lsp.Request
---@param result unknown
---@return lsp.Response
local function handleRequestResult(req, result)
	if result ~= nil then
		-- request handlers should always return a result on success
		return { id = req.id, result = result }
	else
		local msg = NO_RESPONSE_ERROR:format(req.method)
		logMessage(msg, MessageType.Error)
		return errors.general(req.id, msg)
	end
end

---@param req lsp.Request
---@param err lsp*.RouteError
---@return lsp.Response
local function handleRequestError(req, err)
	logMessage("request error: " .. tostring(err.msg), MessageType.Error)
	if err.result then -- graceful error
		return { id = req.id, error = err.result }
	else -- messy error
		return errors.general(req.id, err.msg)
	end
end

---@param req lsp.Request
---@param ok boolean
---@param result unknown
local function handleRequestRoute(req, ok, result)
	local res ---@type lsp.Response
	if ok then -- successful request
		res = handleRequestResult(req, result)
	else
		---@cast result lsp*.RouteError
		res = handleRequestError(req, result)
	end

	ioLSP:write(res)
end

local RESPONSE_ERROR = "notification '%s' was responded to"

---@param notif lsp.Notification
---@param ok boolean
---@param result unknown
local function handleNotificationRoute(notif, ok, result)
	if ok and result ~= nil then
		logMessage(RESPONSE_ERROR:format(notif.method), MessageType.Error)
	elseif not ok then
		---@cast result lsp*.RouteError
		logMessage(result.msg, MessageType.Error)
	end
end

local NO_REQUEST_STORED_ERROR = "request not stored for thread '%s'"

---@param thread thread
---@param ... any
local function executeThread(thread, ...)
	local ok, result = coroutine.resume(thread, ...)
	if coroutine.status(thread) == "suspended" then
		-- waiting for a request to complete
		-- all the book-keeping should've been finished before this, so just return
		return
	end

	if not ok then
		result = handleRouteError(result)
	end

	local req = handle.waitingThreadToReq[thread]
	if not req then
		error(NO_REQUEST_STORED_ERROR:format(thread))
	end
	handle.waitingThreadToReq[thread] = nil
	if req.id then
		---@cast req lsp.Request
		handleRequestRoute(req, ok, result)
	else
		---@cast req lsp.Notification
		handleNotificationRoute(req, ok, result)
	end
end

---@param route fun(params: any): any
---@param req lsp.Request | lsp.Notification
local function handleRoute(route, req)
	local thread = coroutine.create(route)
	handle.waitingThreadToReq[thread] = req
	executeThread(thread, req.params)
end

---@param res lsp.Response
local function handleResponse(res)
	local thread = handle.waitingThreads[res.id] ---@type thread
	if not thread then
		error(string.format("no listener for response id '%s'", tostring(res.id)))
	end

	executeThread(thread, res.result and true or false, res.result or res.error)
end

---@enum (key) lsp*.handle.Handler
handle.handlers = {
	initialize = function()
		local req = getRequest()
		if not req then return end

		if not req.method then
			---@cast req lsp.Response
			handleResponse(req)
			return
		end
		---@cast req lsp.Request | lsp.Notification

		if req.method ~= "initialize" and req.method ~= "exit" then
			ioLSP:write(errors.ServerNotInitialized(req.id))
			return
		end

		local route = getRoute(req)
		if route then
			handleRoute(route, req)
		end

		if req.method == "exit" then
			os.exit(1)
		else
			handle.state = "default"
		end
	end,

	default = function()
		local req = getRequest()
		if not req then return end

		if not req.method then
			---@cast req lsp.Response
			handleResponse(req)
			return
		end
		---@cast req lsp.Request | lsp.Notification

		local route = getRoute(req)
		if route then
			handleRoute(route, req)
		end

		if req.method == "shutdown" then
			handle.state = "shutdown"
		elseif req.method == "exit" then
			os.exit(1)
		end
	end,

	shutdown = function()
		local req = getRequest()
		if not req then return end

		if not req.method then
			---@cast req lsp.Response
			handleResponse(req)
			return
		end
		---@cast req lsp.Request | lsp.Notification

		if req.method ~= "exit" then
			ioLSP:write(errors.InvalidRequest(req.id, req.method))
			return
		end

		local route = getRoute(req)
		if not route then return end

		handleRoute(route, req)

		handle.running = false
	end
}

local handleMt = {}

function handleMt:__call()
	local handler = handle.handlers[handle.state]
	if not handler then
		error(string.format("handler not found for state '%s'", handle.state))
	end

	handler()
end

return setmetatable(handle, handleMt)
