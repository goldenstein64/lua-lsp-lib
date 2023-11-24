local handle = require("lsp-lib.handle")
local ioLSP = require("lsp-lib.io")

ioLSP.provider = require("lsp-lib.io.stdio")

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
		ioLSP.readCallback = dbg.read
		ioLSP.writeCallback = dbg.write
	end

	while handle.running do handle() end

	if exit ~= false then
		os.exit(handle.state == "shutdown" and 0 or 1)
	else
		assert(handle.state == "shutdown", "server left in unfinished state")
	end
end

return lsp
