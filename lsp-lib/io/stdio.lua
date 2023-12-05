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

---@type lsp*.io.Provider
return io_std
