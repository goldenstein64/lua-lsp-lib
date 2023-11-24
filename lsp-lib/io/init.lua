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
---@field readCallback? fun(data: lsp*.AnyMessage)
---@field writeCallback? fun(data: lsp*.AnyMessage)
local ioLSP = {
	requestQueue = {}
}

---@param self lsp*.io
local function readHeaderLine(self)
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
local function decodeHeaders(self)
	local headers = {}
	local header = readHeaderLine(self)
	while not header:match("^\r?\n$") do
		---@type string, string
		local key, value = header:match("^([%w%-]+): (.*)\r?\n$")
		assert(key, "unable to parse header")
		headers[string.lower(key)] = value
		header = readHeaderLine(self)
	end

	return headers
end

---@param headers lsp*.io.headers
local function validateHeaders(headers)
	local len = tonumber(headers["content-length"])
	assert(len, "could not find length")
	headers["content-length"] = len

	local contentType = headers["content-type"] ---@type string?
	assert(
		not contentType or (
			contentType:find("^application/vscode%-jsonrpc")
			and contentType:find("charset=utf%-8$")
		),
		"cannot handle content types other than 'application/vscode-jsonrpc; charset=utf-8'"
	)
end

---@param self lsp*.io
---@return lsp*.io.headers
local function getHeaders(self)
	local headers = decodeHeaders(self)
	validateHeaders(headers)
	return headers
end

---@param self lsp*.io
---@param len integer
---@return lsp*.AnyMessage
local function getData(self, len)
	local content = assert(self.provider:read(len))

	local object = json.decode(content)
	assert(type(object) == "table", "object is not a table")

	local mt = getmetatable(object)
	if mt == json.array_mt then
		---@diagnostic disable-next-line:deprecated
		table.move(object, 2, #object, #self.requestQueue + 1, self.requestQueue)
		return object[1]
	end

	return object
end

---@return lsp*.AnyMessage
function ioLSP:read()
	if #self.requestQueue > 0 then
		return table.remove(self.requestQueue, 1)
	end

	local headers = getHeaders(self)

	local len = headers["content-length"]
	local data = getData(self, len)

	if self.readCallback then
		self.readCallback(data)
	end

	return data
end

---@param data lsp*.AnyMessage
function ioLSP:write(data)
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

	if self.writeCallback then
		self.writeCallback(data)
	end

	local content = json.encode(data)

	local contentLength = string.len(content)
	local response = RESPONSE_FMT:format(contentLength, content)

	self.provider:write(response)
end

return ioLSP
