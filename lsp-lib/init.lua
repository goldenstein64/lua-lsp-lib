local listen = require("lsp-lib.listen")
local io_lsp = require("lsp-lib.io")

io_lsp.provider = require("lsp-lib.io.stdio")
listen.routes = require("lsp-lib.response")

local lsp = {
	notify = require("lsp-lib.notify"),
	request = require("lsp-lib.request"),
	response = require("lsp-lib.response"),
	listen = require("lsp-lib.listen")
}

function lsp.debug(setting)
	if setting then
		local dbg = require("lsp-lib.io.debug")
		io_lsp.read_callback = dbg.read
		io_lsp.write_callback = dbg.write
	else
		io_lsp.read_callback = nil
		io_lsp.write_callback = nil
	end
end

return lsp
