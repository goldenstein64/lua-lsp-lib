local handle = require("lsp-lib.handle")
local ioLSP = require("lsp-lib.io")

ioLSP.provider = require("lsp-lib.io.stdio")

local lsp = {
	debug = false,

	notify = require("lsp-lib.notify"),
	request = require("lsp-lib.request"),
	response = require("lsp-lib.response"),
}

function lsp.listen()
	if lsp.debug then
		local dbg = require("lsp-lib.io.debug")
		ioLSP.readCallback = dbg.read
		ioLSP.writeCallback = dbg.write
	end

	while true do handle() end
end

return lsp
