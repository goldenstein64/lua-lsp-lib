---@class lsp*.io.provider.stdio : lsp*.io.provider
local io_std = {}

---@param bytes integer
---@return string
function io_std:read(bytes)
	return io.read(bytes)
end

---@param data string
function io_std:write(data)
	io.write(data)
	io.flush()
end

return io_std
