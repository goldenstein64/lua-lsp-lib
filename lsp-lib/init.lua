local handle = require("lsp-lib.handle")
local io_lsp = require("lsp-lib.io")

io_lsp.provider = require("lsp-lib.io.stdio")

local lsp = {
	debug = false,

	notify = require("lsp-lib.notify"),
	request = require("lsp-lib.request"),
	response = require("lsp-lib.response"),
}

---@param exit? boolean
function lsp.listen(exit)
	if lsp.debug then
		local dbg = require("lsp-lib.io.debug")
		io_lsp.read_callback = dbg.read
		io_lsp.write_callback = dbg.write
	end

	handle.state = 'initialize'
	handle.running = true
	while handle.running do handle() end

	if exit ~= false then
		os.exit(handle.state == "shutdown" and 0 or 1)
	else
		assert(handle.state == "shutdown", "server left in unfinished state")
	end
end

return lsp
