local io_lsp = require("lsp-lib.io")

local notify = require("lsp-lib.notify")
local response = require("lsp-lib.response")

local errors = require("lsp-lib.handle.errors")

---@operator call(): nil
local handle = {
	---@type { [thread]: lsp.Request | lsp.Notification }
	waiting_thread_to_req = {},

	---@type { [integer]: thread }
	waiting_threads = {},

	state = "initialize",
	running = true,
}

---@return lsp*.AnyMessage?
local function get_request()
	local s, req = pcall(io_lsp.read, io_lsp)
	if not s then
		io_lsp:write(errors.ParseError(req --[[@as string?]]))
	end

	return s and req or nil
end

local ERR_UNKNOWN_PROTOCOL = "invoked an unknown protocol '%s'"

---@param req lsp.Request | lsp.Notification
---@return nil | fun(params: any): any
local function get_route(req)
	local route = response[req.method]
	local isRequired = req.method:sub(1, 1) ~= "$"
	if not route then
		local isRequest = req.id ~= nil
		if isRequest then
			if isRequired then
				io_lsp:write(errors.MethodNotFound(req.id, req.method))
				notify.log.error(ERR_UNKNOWN_PROTOCOL:format(req.method))
			end
		else
			notify.log.error(ERR_UNKNOWN_PROTOCOL:format(req.method))
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
local function handle_route_error(result)
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
local function handle_request_result(req, result)
	if result ~= nil then
		-- request handlers should always return a result on success
		return { id = req.id, result = result }
	else
		local msg = NO_RESPONSE_ERROR:format(req.method)
		notify.log.error(msg)
		return errors.general(req.id, msg)
	end
end

---@param req lsp.Request
---@param err lsp*.RouteError
---@return lsp.Response
local function handle_request_error(req, err)
	notify.log.error("request error: " .. tostring(err.msg))
	if err.result then -- graceful error
		return { id = req.id, error = err.result }
	else -- messy error
		return errors.general(req.id, err.msg)
	end
end

---@param req lsp.Request
---@param ok boolean
---@param result unknown
local function handle_request_route(req, ok, result)
	local res ---@type lsp.Response
	if ok then -- successful request
		res = handle_request_result(req, result)
	else
		---@cast result lsp*.RouteError
		res = handle_request_error(req, result)
	end

	io_lsp:write(res)
end

local RESPONSE_ERROR = "notification '%s' was responded to"

---@param notif lsp.Notification
---@param ok boolean
---@param result unknown
local function handle_notification_route(notif, ok, result)
	if ok and result ~= nil then
		notify.log.error(RESPONSE_ERROR:format(notif.method))
	elseif not ok then
		---@cast result lsp*.RouteError
		notify.log.error(result.msg)
	end
end

local NO_REQUEST_STORED_ERROR = "request not stored for thread '%s'"

---@param thread thread
---@param ... any
local function execute_thread(thread, ...)
	local ok, result = coroutine.resume(thread, ...)
	if coroutine.status(thread) == "suspended" then
		-- waiting for a request to complete
		-- all the book-keeping should've been finished before this, so just return
		return
	end

	if not ok then
		result = handle_route_error(result)
	end

	local req = handle.waiting_thread_to_req[thread]
	if not req then
		error(NO_REQUEST_STORED_ERROR:format(thread))
	end
	handle.waiting_thread_to_req[thread] = nil
	if req.id then
		---@cast req lsp.Request
		handle_request_route(req, ok, result)
	else
		---@cast req lsp.Notification
		handle_notification_route(req, ok, result)
	end
end

---@param route fun(params: any): any
---@param req lsp.Request | lsp.Notification
local function handle_route(route, req)
	local thread = coroutine.create(route)
	handle.waiting_thread_to_req[thread] = req
	execute_thread(thread, req.params)
end

---@param res lsp.Response
local function handle_response(res)
	local thread = handle.waiting_threads[res.id] ---@type thread
	if not thread then
		error(string.format("no listener for response id '%s'", tostring(res.id)))
	end

	execute_thread(thread, res.result and true or false, res.result or res.error)
end

---@enum (key) lsp*.handle.Handler
handle.handlers = {
	initialize = function()
		local req = get_request()
		if not req then return end

		if not req.method then
			---@cast req lsp.Response
			handle_response(req)
			return
		end
		---@cast req lsp.Request | lsp.Notification

		if req.method ~= "initialize" and req.method ~= "exit" then
			io_lsp:write(errors.ServerNotInitialized(req.id))
			return
		end

		local route = get_route(req)
		if route then
			handle_route(route, req)
		end

		if req.method == "exit" then
			os.exit(1)
		else
			handle.state = "default"
		end
	end,

	default = function()
		local req = get_request()
		if not req then return end

		if not req.method then
			---@cast req lsp.Response
			handle_response(req)
			return
		end
		---@cast req lsp.Request | lsp.Notification

		local route = get_route(req)
		if route then
			handle_route(route, req)
		end

		if req.method == "shutdown" then
			handle.state = "shutdown"
		elseif req.method == "exit" then
			os.exit(1)
		end
	end,

	shutdown = function()
		local req = get_request()
		if not req then return end

		if not req.method then
			---@cast req lsp.Response
			handle_response(req)
			return
		end
		---@cast req lsp.Request | lsp.Notification

		if req.method ~= "exit" then
			io_lsp:write(errors.InvalidRequest(req.id, req.method))
			return
		end

		local route = get_route(req)
		if not route then return end

		handle_route(route, req)

		handle.running = false
	end
}

local handle_mt = {}

function handle_mt:__call()
	local handler = handle.handlers[handle.state]
	if not handler then
		error(string.format("handler not found for state '%s'", handle.state))
	end

	handler()
end

return setmetatable(handle, handle_mt)
