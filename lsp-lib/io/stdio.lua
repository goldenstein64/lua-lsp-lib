---@class lsp*.io.provider.stdio : lsp*.io.provider
local ioStd = {}

---@param bytes integer
---@return string
function ioStd:read(bytes)
	return io.read(bytes)
end

---@param data string
function ioStd:write(data)
	io.write(data)
	io.flush()
end

return ioStd
