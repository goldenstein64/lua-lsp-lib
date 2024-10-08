local json = require("cjson").new()

json.decode_array_with_array_mt(true)

local RESPONSE_FMT = "Content-Length: %d%s%s%s"

local NON_TABLE_ERROR = "sent a non-table, '%s'"

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
local io_lsp = {
	message_queue = {},
	provider = require("lsp-lib.io.stdio"),
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
---@return lsp*.AnyMessage
local function get_data(self, len)
	local content = assert(self.provider:read(len))

	local object = json.decode(content)
	assert(type(object) == "table", "object is not a table")

	local mt = getmetatable(object)
	if mt == json.array_mt then
		for i = 2, #object do
			table.insert(self.message_queue, object[i])
		end
		return object[1]
	end

	return object
end

---reads a message from `lsp*.io`'s provider, validates it, and returns it as a Lua
---table
---@return lsp*.AnyMessage
function io_lsp:read()
	if #self.message_queue > 0 then
		return table.remove(self.message_queue, 1)
	end

	local headers = get_headers(self)

	local len = headers["content-length"]
	local data = get_data(self, len)

	if self.read_callback then
		self.read_callback(data)
	end

	return data
end

---takes a Lua table, validates it, and writes it to `lsp*.io`'s provider
---@param data lsp*.AnyMessage
function io_lsp:write(data)
	if type(data) ~= "table" then
		error(NON_TABLE_ERROR:format(type(data)))
	end

	data.jsonrpc = "2.0"

	if data.id then
		local mutex = 0
		do
			if data.result then
				mutex = mutex + 1
			end
			if data.error then
				mutex = mutex + 1
			end
			if data.method then
				mutex = mutex + 1
			end
		end

		if mutex ~= 1 then
			if data.method then
				error("malformed request")
			else
				error("malformed response")
			end
		end
	elseif not data.id and not data.method then
		error("malformed notification")
	end

	if self.write_callback then
		self.write_callback(data)
	end

	local content = json.encode(data)

	local line_ending = self.provider.line_ending
	local content_length = string.len(content)
	local response =
		RESPONSE_FMT:format(content_length, line_ending, line_ending, content)

	self.provider:write(response)
end

return io_lsp
