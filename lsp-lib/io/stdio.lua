---represents an I/O provider that reads from `stdin` and writes to `stdout`
---@class lsp*.io.StdIOProvider : lsp*.io.Provider
local stdio = {
	line_ending = "\n",
}

---reads `bytes` bytes from `stdin`, returning a string
---@param bytes integer
---@return string
function stdio:read(bytes)
	return io.read(bytes)
end

---writes `data` to `stdout`
---@param data string
function stdio:write(data)
	io.write(data)
	io.flush()
end

return stdio
