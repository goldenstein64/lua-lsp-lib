-- in MoonScript,
import null from require 'cjson'

lsp = require 'lsp-lib'
import notify, request, listen, async from lsp

class Response extends lsp.response
	'initialize': (params) ->
		-- make a (non-blocking) LSP request
		async -> lsp.config = assert request.config!

		-- utility notify functions are provided too
		notify.log.info os.date!

		{ capabilities: {} }

	'shutdown': ->
		-- notify the client of something
		notify.cancel_request { id: 0 }
		null

listen.routes = Response!

-- define your own request function
request.custom_request = (foo, bar) ->
	request '$/customRequest', { :foo, :bar }

-- turn on debugging
-- currently logs anything received by or sent from this server
lsp.debug true

-- starts a loop that listens to stdio
listen!
