local io_lsp = require("lsp-lib.io")

local notify = require("lsp-lib.notify")
local request_state = require("lsp-lib.request.state")

local errors = require("lsp-lib.listen.errors")

local ERR_UNKNOWN_PROTOCOL = "invoked an unknown protocol '%s'"
local ERR_NO_RESPONSE = "request '%s' was not responded to"
local ERR_RESPONSE_FOUND = "notification '%s' was responded to"
local ERR_NO_THREAD_STORED = "no thread found for response id '%s'"

---@alias lsp-lib.Listen.state "initialize" | "default" | "shutdown"

---manages messages read from input, routes them through its message handlers,
---and sends what they return to output
---
---This module also resumes requesting threads when receiving responses and
---logs errors to the client when a route errors.
---
---Calling this module starts a blocking I/O loop. It's dependent on
---[`lsp-lib.io`](lua://lsp-lib.IO) to read and write these messages.
---
---If the `exit` parameter is anything but `false`, `listen()` will call
---`os.exit` after receiving the
---[`exit` notification](https://microsoft.github.io/language-server-protocol/specifications/lsp/3.17/specification/#exit).
---`listen(false)` will simply assert that the server was left in a finished
---state before returning. This is used for writing tests.
---@class lsp-lib.Listen
---This table is indexed whenever a request or notification is read, and the
---resulting method gets called with the received message's parameters. It holds
---all methods implemented by the user, and defaults to the
---[`lsp.response`](lua://lsp-lib.Response) module.
---@field routes { [string]: nil | fun(params: any): any }
---describes how `listen()` handles messages as specified by the LSP. It
---typically doesn't have to be modified by the user. This gets set to
---`'initialize'` when `listen()` is called.
---
---- `"initialize"`: It transitions to the `default` state once an
---  [`initialize` request](https://microsoft.github.io/language-server-protocol/specifications/lsp/3.17/specification/#initialize)
---  is received and stops running if an
---  [`exit` notification](https://microsoft.github.io/language-server-protocol/specifications/lsp/3.17/specification/#exit)
---  is received. These requests and notifications are routed,
---  and any other request is responded to with a
---  [`ServerNotInitialized` error](https://microsoft.github.io/language-server-protocol/specifications/lsp/3.17/specification/#errorCodes).
---
---- `"default"`: It transitions to the `shutdown` state once a
---  [`shutdown` request](https://microsoft.github.io/language-server-protocol/specifications/lsp/3.17/specification/#shutdown)
---  is received and stops running if an
---  [`exit` notification](https://microsoft.github.io/language-server-protocol/specifications/lsp/3.17/specification/#exit)
---  is received. All requests and notifications are routed.
---
---- `"shutdown"`: It stops running if an
---  [`exit` notification](https://microsoft.github.io/language-server-protocol/specifications/lsp/3.17/specification/#exit)
---  is received. This notification is routed, and all
---  requests are responded to with an
---  [`InvalidRequest` error](https://microsoft.github.io/language-server-protocol/specifications/lsp/3.17/specification/#errorCodes).
---@field state lsp-lib.Listen.state
---a flag indicating whether `listen()` should keep listening for messages. It
---typically doesn't have to be modified by the user. This gets set to `true`
---when calling `listen()`.
---@field running boolean
---@overload fun(exit?: boolean)
local listen = {
	routes = require("lsp-lib.response"),
	state = "initialize",
	running = true,
}

---@param msg lsp.Request | lsp.Notification
---@return nil | fun(params: any): any
local function get_route(msg)
	local route = listen.routes[msg.method]
	if not route then
		notify.log.error(ERR_UNKNOWN_PROTOCOL:format(msg.method))
		if msg.id ~= nil then
			---@cast msg lsp.Request
			io_lsp:write(errors.MethodNotFound(msg.id, msg.method))
		end
	end

	return route
end

---@class lsp-lib.listen.RouteError
---@field result? lsp.ResponseError
---@field msg string

---@param result lsp.ResponseError | string
---@return lsp-lib.listen.RouteError
local function handle_route_error(result)
	if type(result) == "table" and result.message and result.code then
		-- graceful error, leave it alone
		return { result = result, msg = debug.traceback(result.message) }
	elseif type(result) == "string" then
		-- messy error
		return { msg = debug.traceback(result) }
	else
		-- messier error
		return {
			msg = debug.traceback("non-string error: " .. tostring(result)),
		}
	end
end

---@param req lsp.Request
---@param result unknown
---@return lsp.Response
local function handle_request_result(req, result)
	if result ~= nil then
		-- request handlers should always return a result on success
		return { jsonrpc = "2.0", id = req.id, result = result }
	else
		local msg = ERR_NO_RESPONSE:format(req.method)
		notify.log.error(msg)
		return errors.general(req.id, msg)
	end
end

---@param req lsp.Request
---@param err lsp-lib.listen.RouteError
---@return lsp.Response
local function handle_request_error(req, err)
	notify.log.error("request error: " .. tostring(err.msg))
	if err.result then -- graceful error
		return { jsonrpc = "2.0", id = req.id, error = err.result }
	else -- messy error
		return errors.general(req.id, err.msg)
	end
end

---@param ok boolean
---@param result unknown
local function handle_async_route(ok, result)
	if not ok then
		---@cast result lsp-lib.listen.RouteError
		notify.log.error(tostring(result))
	end
end

---@param req lsp.Request
---@param ok boolean
---@param result unknown
---@return lsp.Response
local function handle_request_route(req, ok, result)
	if ok then -- successful request
		return handle_request_result(req, result)
	else
		---@cast result lsp-lib.listen.RouteError
		return handle_request_error(req, result)
	end
end

---@param notif lsp.Notification
---@param ok boolean
---@param result unknown
local function handle_notification_route(notif, ok, result)
	if not ok then
		---@cast result lsp-lib.listen.RouteError
		notify.log.error(result.msg)
	elseif result ~= nil then
		notify.log.error(ERR_RESPONSE_FOUND:format(notif.method))
	end
end

---@param req lsp.Request | lsp.Notification | nil
---@param thread thread
---@param ... any
local function execute_thread(req, thread, ...)
	local co_ok, ok, result = coroutine.resume(thread, ...)
	local thread_status = coroutine.status(thread)
	if thread_status == "suspended" then
		-- waiting for a request to complete
		request_state.waiting_requests[thread] = req
		return
	end
	assert(thread_status == "dead", "thread is not dead")

	if not req then
		ok, result = co_ok, ok
		handle_async_route(ok, result)
	elseif req.id then
		---@cast req lsp.Request
		io_lsp:write(handle_request_route(req, ok, result))
	else
		---@cast req lsp.Notification
		handle_notification_route(req, ok, result)
	end
end

---@param route fun(params: any): any
---@param req lsp.Request | lsp.Notification
local function handle_route(route, req)
	if type(route) == "table" then
		local old_route = route
		route = function(...)
			return old_route(...)
		end
	end

	local thread = coroutine.create(xpcall)
	execute_thread(req, thread, route, handle_route_error, req.params)
end

---@param msg lsp.Request | lsp.Notification
local function try_route(msg)
	local route = get_route(msg)
	if route then
		handle_route(route, msg)
	end
end

---@param res lsp.Response
local function handle_response(res)
	local thread = request_state.waiting_threads[res.id]
	if not thread then
		error(ERR_NO_THREAD_STORED:format(res.id))
	end
	request_state.waiting_threads[res.id] = nil

	local req = request_state.waiting_requests[thread]
	request_state.waiting_requests[thread] = nil

	execute_thread(req, thread, res.result, res.error)
end

---describes `listen()`'s behavior based on the value of `listen.state`. It
---typically doesn't have to be modified by the user.
listen.handlers = {
	["initialize"] = function()
		local msg = io_lsp:read()
		local msg_type = io_lsp.type(msg) --[[@as lsp-lib.io.MessageEnum]]

		if msg_type == "response" then
			---@cast msg lsp.Response
			handle_response(msg)
			return
		end

		---@cast msg lsp.Request | lsp.Notification

		if msg_type == "notification" then
			---@cast msg lsp.Notification
			if msg.method == "exit" then
				listen.running = false
			else
				return
			end
		elseif msg_type == "request" then
			---@cast msg lsp.Request
			if msg.method == "initialize" then
				listen.state = "default"
			else
				io_lsp:write(errors.ServerNotInitialized(msg.id))
				return
			end
		end

		try_route(msg)
	end,

	["default"] = function()
		local msg = io_lsp:read()
		local msg_type = io_lsp.type(msg) --[[@as lsp-lib.io.MessageEnum]]

		if msg_type == "response" then
			---@cast msg lsp.Response
			handle_response(msg)
			return
		end

		---@cast msg lsp.Request | lsp.Notification

		if msg_type == "request" and msg.method == "shutdown" then
			listen.state = "shutdown"
		elseif msg_type == "notification" and msg.method == "exit" then
			listen.running = false
		end

		try_route(msg)
	end,

	["shutdown"] = function()
		local msg = io_lsp:read()
		local msg_type = io_lsp.type(msg) --[[@as lsp-lib.io.MessageEnum]]

		if msg_type == "response" then
			---@cast msg lsp.Response
			handle_response(msg)
			return
		end

		---@cast msg lsp.Request | lsp.Notification

		if msg_type == "notification" then
			if msg.method == "exit" then
				listen.running = false
			else
				return
			end
		elseif msg_type == "request" then
			---@cast msg lsp.Request
			io_lsp:write(errors.InvalidRequest(msg.id, msg.method))
			return
		end

		try_route(msg)
	end,
}

---handles exactly one iteration of the I/O loop, reading one LSP message pulled
---from [`lsp.io:read`](lua://lsp-lib.IO.read) and propagating it to the
---appropriate route.
function listen.once()
	local handler = listen.handlers[listen.state]
	if not handler then
		error(string.format("handler not found for state '%s'", listen.state))
	end

	handler()
end

local listen_mt = {}

---@see lsp-lib.Listen
---@param exit? boolean
function listen_mt:__call(exit)
	listen.state = "initialize"
	listen.running = true
	while listen.running do
		listen.once()
	end

	if exit ~= false then
		os.exit(listen.state == "shutdown" and 0 or 1)
	else
		assert(
			listen.state == "shutdown",
			"server was left in an unfinished state"
		)
	end
end

---@diagnostic disable-next-line: param-type-mismatch
return setmetatable(listen, listen_mt) --[[@as lsp-lib.Listen]]
