local json = require("cjson").new()

local ErrorCodes = require("lsp-lib.enum.ErrorCodes")

json.decode_array_with_array_mt(true)
local null = json.null
local array_mt = json.array_mt

local RESPONSE_FMT = "Content-Length: %d%s%s%s"

---@param id? string | number | cjson.null
---@param methodName? string
local function e_invalid_request(id, methodName)
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

---represents any message that can be sent or received by the server
---@alias lsp*.AnyMessage
---| lsp.Request
---| lsp.Response
---| lsp.Notification

---a primitive interface for reading from and writing to an I/O source
---
---Due to its push-only interface, it may not be powerful enough to support all
---modes of transport, which is why it may be good practice to redirect stdio
---externally instead of swapping the provider at runtime.
---@see lsp*.io.provider
---@class lsp*.io.Provider
---reads `bytes` bytes from its input source and returns the data read. It must
---be synchronous.
---@field read fun(self: lsp*.io.Provider, bytes: integer): (data: string)
---writes `data` to its output source. It can be asynchronous but must be
---atomic.
---@field write fun(self: lsp*.io.Provider, data: string)
---describes what line ending to use for header fields and the header block
---separator.
---@field line_ending string

---a mid-level interface that sends and receives Lua tables
---@class lsp*.io
---the interface `lsp*.io` uses to read from and write to an I/O source
---
---`stdio` is the default provider, but it can be swapped with other providers
---for pipe and socket transport.
---
---Due to its push-only interface, it may not be powerful enough to support all
---modes of transport, which is why it may be good practice to redirect stdio
---externally instead of swapping the provider at runtime.
---@see lsp*.io.Provider
---@field provider lsp*.io.Provider
---a function that gets called after data is read from `lsp*.io`'s provider and
---before it gets returned
---@field read_callback? fun(data: lsp*.AnyMessage)
---a function that gets called after it receives data and gets it validated and
---before it gets written to `lsp*.io`'s provider
---@field write_callback? fun(data: lsp*.AnyMessage)
---a mapping from request id's to their respective batches
---@field request_to_batch { [lsp.Request]: lsp*.AnyMessage[] }
---holds all messages that haven't been processed yet
---@field message_queue lsp*.AnyMessage[]
local io_lsp = {
	provider = require("lsp-lib.io.stdio"),

	request_to_batch = {},
	message_queue = {},

	read_callback = nil,
	write_callback = nil,
}

---@param self lsp*.io
---@return string
local function read_header_line(self)
	local buffer = {}
	while true do
		local byte = assert(self.provider:read(1))
		table.insert(buffer, byte)
		if byte == "\r" then
			byte = assert(self.provider:read(1))
			table.insert(buffer, byte)
		end

		if byte == "\n" then
			return table.concat(buffer)
		end
	end
end

---an internal interface used for decoding headers
---@class lsp*.io.headers
---@field ["content-length"] integer
---@field ["content-type"] string?

---@param self lsp*.io
---@return lsp*.io.headers
local function get_headers(self)
	local headers = {}
	local header = read_header_line(self)
	while not header:match("^\r?\n$") do
		---@type string, string
		local key, value = header:match("^([%w%-]+): (.*)\r?\n$")
		assert(key, "unable to parse header")
		headers[string.lower(key)] = value
		header = read_header_line(self)
	end

	local len = tonumber(headers["content-length"])
	assert(len, "could not find length")
	headers["content-length"] = len

	local content_type = headers["content-type"] ---@type string?
	assert(
		not content_type
			or (
				content_type:find("^application/vscode%-jsonrpc")
				and content_type:find("charset=utf%-8$")
			),
		"cannot handle content types other than 'application/vscode-jsonrpc; charset=utf-8'"
	)

	return headers
end

---@param self lsp*.io
---@param len integer
---@return lsp*.AnyMessage | (lsp*.AnyMessage)[]
local function get_data(self, len)
	local content = assert(self.provider:read(len))

	local object = json.decode(content)
	assert(type(object) == "table", "object is not a table")

	return object
end

---@param self lsp*.io
---@param data lsp*.AnyMessage | lsp*.AnyMessage[]
local function _write(self, data)
	local content = json.encode(data)

	local line_ending = self.provider.line_ending
	local content_length = string.len(content)
	local response =
		RESPONSE_FMT:format(content_length, line_ending, line_ending, content)

	self.provider:write(response)
end

---reads one raw header/content pair from the I/O provider and extracts all LSP
---messages from it, inserting them into the message queue. `io_lsp:read()`
---removes one message from the queue and returns it to the caller.
---@param self lsp*.io
local function _read(self)
	local headers = get_headers(self)

	local len = headers["content-length"]
	local data = get_data(self, len)

	if self.read_callback then
		self.read_callback(data)
	end

	if getmetatable(data) == array_mt then
		---@cast data lsp*.AnyMessage[]
		if #data == 0 then
			_write(self, e_invalid_request())
			return
		end

		local batch = setmetatable({}, array_mt)
		local pending_count = 0
		for _, sub_msg in ipairs(data) do
			local sub_msg_type = io_lsp.type(sub_msg)
			if sub_msg_type == nil then
				-- add an invalid request to the batch
				table.insert(batch, e_invalid_request())
			else
				table.insert(self.message_queue, sub_msg)
			end

			if sub_msg_type == "request" then
				pending_count = pending_count + 1
				self.request_to_batch[sub_msg.id] = batch
				-- associate this request to the batch
			end
		end

		if pending_count > 0 then
			batch.pending = pending_count
		elseif #batch > 0 then
			_write(self, batch)
		end
	elseif io_lsp.type(data) ~= nil then
		---@cast data lsp*.AnyMessage
		table.insert(self.message_queue, data)
	else
		_write(self, e_invalid_request(data.id, data.method))
	end
end

---reads a message from `lsp*.io`'s provider, validates it, and returns it as a
---Lua table
---@return lsp*.AnyMessage
function io_lsp:read()
	while #self.message_queue <= 0 do
		_read(self)
	end

	---@type lsp*.AnyMessage
	local message = table.remove(self.message_queue, 1)

	return message
end

---takes a Lua table representing an LSP message, validates it, and writes it to
---`lsp*.io`'s provider
---@param message lsp*.AnyMessage
function io_lsp:write(message)
	local msg_type = assert(io_lsp.type(message))

	if self.write_callback then
		self.write_callback(message)
	end

	if msg_type ~= "response" then
		_write(self, message)
		return
	end
	---@cast message lsp.Response

	local id = message.id
	local batch = self.request_to_batch[id]
	if not batch then
		_write(self, message)
		return
	end

	self.request_to_batch[id] = nil
	table.insert(batch, message)
	local new_pending_count = assert(batch.pending) - 1
	if new_pending_count <= 0 then
		_write(self, batch)
	else
		batch.pending = new_pending_count
	end
end

---@alias lsp*.io.MessageEnum "response" | "request" | "notification"

---determines whether a Lua table is a valid LSP message. It either returns a
---string determining the type of LSP message or `nil` and an error message.
---@param value unknown
---@return lsp*.io.MessageEnum? type, string? err_msg
function io_lsp.type(value)
	if type(value) ~= "table" then
		return nil, "not a table"
	elseif value.jsonrpc ~= "2.0" then
		return nil, "jsonrpc is not '2.0'"
	end

	local has_method = value.method ~= nil
	if value.id ~= nil then
		local mutex = 0
		if value.result ~= nil then
			mutex = mutex + 1
		end
		if value.error ~= nil then
			mutex = mutex + 1
		end
		if has_method then
			mutex = mutex + 1
		end

		if mutex ~= 1 then
			return nil, "has 'id' but does not have exactly one of 'result', 'error', or 'method'"
		elseif has_method then
			return "request"
		else -- has 'result' or 'error', both are responses
			return "response"
		end
	elseif has_method then
		return "notification"
	else
		return nil, "has no 'id' and no 'method'"
	end
end

return io_lsp
