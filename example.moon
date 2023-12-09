-- in MoonScript,
import null from require 'cjson'

lsp = require 'lsp-lib'
import notify, request, listen from lsp

class Response extends lsp.response
	'initialize': (params) ->
		{ capabilities: {} }

	'initialized': ->
		-- utility notify functions are provided
		notify.log.info os.date!

		-- make a blocking LSP request
		lsp.config = assert request.config!

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
