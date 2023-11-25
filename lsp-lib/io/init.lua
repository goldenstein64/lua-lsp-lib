local json = require("cjson").new()

json.decode_array_with_array_mt(true)

local RESPONSE_FMT = "Content-Length: %d\n\n%s"

local NON_TABLE_ERROR = "sent a non-table, '%s'"

---@alias lsp*.AnyMessage
---| lsp.Request
---| lsp.Response
---| lsp.Notification

---@class lsp*.io.provider
---@field read fun(self: lsp*.io.provider, bytes: integer): (data: string)
---@field write fun(self: lsp*.io.provider, data: string)

---@class lsp*.io
---@field provider lsp*.io.provider
---@field read_callback? fun(data: lsp*.AnyMessage)
---@field write_callback? fun(data: lsp*.AnyMessage)
local io_lsp = {
	request_queue = {}
}

---@param self lsp*.io
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

---@class lsp*.io.headers
---@field ["content-length"] integer
---@field ["content-type"] string?

---@param self lsp*.io
---@return lsp*.io.headers
local function decode_headers(self)
	local headers = {}
	local header = read_header_line(self)
	while not header:match("^\r?\n$") do
		---@type string, string
		local key, value = header:match("^([%w%-]+): (.*)\r?\n$")
		assert(key, "unable to parse header")
		headers[string.lower(key)] = value
		header = read_header_line(self)
	end

	return headers
end

---@param headers lsp*.io.headers
local function validate_headers(headers)
	local len = tonumber(headers["content-length"])
	assert(len, "could not find length")
	headers["content-length"] = len

	local content_type = headers["content-type"] ---@type string?
	assert(
		not content_type or (
			content_type:find("^application/vscode%-jsonrpc")
			and content_type:find("charset=utf%-8$")
		),
		"cannot handle content types other than 'application/vscode-jsonrpc; charset=utf-8'"
	)
end

---@param self lsp*.io
---@return lsp*.io.headers
local function get_headers(self)
	local headers = decode_headers(self)
	validate_headers(headers)
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
		---@diagnostic disable-next-line:deprecated
		table.move(object, 2, #object, #self.request_queue + 1, self.request_queue)
		return object[1]
	end

	return object
end

---@return lsp*.AnyMessage
function io_lsp:read()
	if #self.request_queue > 0 then
		return table.remove(self.request_queue, 1)
	end

	local headers = get_headers(self)

	local len = headers["content-length"]
	local data = get_data(self, len)

	if self.read_callback then
		self.read_callback(data)
	end

	return data
end

---@param data lsp*.AnyMessage
function io_lsp:write(data)
	if type(data) ~= "table" then
		error(NON_TABLE_ERROR:format(type(data)))
	end

	data.jsonrpc = "2.0"

	if data.id then
		local mutex = 0 do
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

	local content_length = string.len(content)
	local response = RESPONSE_FMT:format(content_length, content)

	self.provider:write(response)
end

return io_lsp
