local io_lsp = require("lsp-lib.io")

local notify = require("lsp-lib.notify")
local response = require("lsp-lib.response")

local errors = require("lsp-lib.listen.errors")

---@operator call(): nil
local listen = {
	---@type { [thread]: lsp.Request | lsp.Notification }
	waiting_thread_to_req = {},

	---@type { [integer]: thread }
	waiting_threads = {},

	state = "initialize",
	running = true,
}

---@return lsp*.AnyMessage?
local function get_request()
	local ok, req = pcall(io_lsp.read, io_lsp)
	if not ok then
		io_lsp:write(errors.ParseError(req --[[@as string?]]))
	end

	return ok and req or nil
end

local ERR_UNKNOWN_PROTOCOL = "invoked an unknown protocol '%s'"

---@param req lsp.Request | lsp.Notification
---@return nil | fun(params: any): any
local function get_route(req)
	local route = response[req.method]
	local is_required = req.method:sub(1, 1) ~= "$"
	if not route then
		local is_request = req.id ~= nil
		if is_request then
			if is_required then
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

	local req = listen.waiting_thread_to_req[thread]
	if not req then
		error(NO_REQUEST_STORED_ERROR:format(thread))
	end
	listen.waiting_thread_to_req[thread] = nil
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
	listen.waiting_thread_to_req[thread] = req
	execute_thread(thread, req.params)
end

---@param res lsp.Response
local function handle_response(res)
	local thread = listen.waiting_threads[res.id] ---@type thread
	if not thread then
		error(string.format("no listener for response id '%s'", tostring(res.id)))
	end

	execute_thread(thread, res.result and true or false, res.result or res.error)
end

---@enum (key) lsp*.handle.Handler
listen.handlers = {
	initialize = function()
		local req = get_request()
		if not req then return end

		local method = req.method
		if not method then
			---@cast req lsp.Response
			handle_response(req)
			return
		end
		---@cast req lsp.Request | lsp.Notification

		if method ~= "initialize" and method ~= "exit" then
			io_lsp:write(errors.ServerNotInitialized(req.id))
			return
		end

		local route = get_route(req)
		if route then
			handle_route(route, req)
		end

		if method == "exit" then
			listen.running = false
		else
			listen.state = "default"
		end
	end,

	default = function()
		local req = get_request()
		if not req then return end

		local method = req.method
		if not method then
			---@cast req lsp.Response
			handle_response(req)
			return
		end
		---@cast req lsp.Request | lsp.Notification

		local route = get_route(req)
		if route then
			handle_route(route, req)
		end

		if method == "shutdown" then
			listen.state = "shutdown"
		elseif method == "exit" then
			listen.running = false
		end
	end,

	shutdown = function()
		local req = get_request()
		if not req then return end

		local method = req.method
		if not method then
			---@cast req lsp.Response
			handle_response(req)
			return
		end
		---@cast req lsp.Request | lsp.Notification

		if method ~= "exit" then
			io_lsp:write(errors.InvalidRequest(req.id, method))
			return
		end

		listen.running = false

		local route = get_route(req)
		if not route then return end

		handle_route(route, req)
	end
}

function listen.once()
	local handler = listen.handlers[listen.state]
	if not handler then
		error(string.format("handler not found for state '%s'", listen.state))
	end

	handler()
end

local listen_mt = {}

---@param exit? boolean
function listen_mt:__call(exit)
	listen.state = "initialize"
	listen.running = true
	while listen.running do listen.once() end

	if exit ~= false then
		os.exit(listen.state == "shutdown" and 0 or 1)
	else
		assert(listen.state == "shutdown", "server left in unfinished state")
	end
end

return setmetatable(listen, listen_mt)