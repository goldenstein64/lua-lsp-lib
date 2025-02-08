-- in MoonScript,
import null from require 'cjson'

ErrorCodes = require 'lsp-lib.enum.ErrorCodes'
lsp = require 'lsp-lib'
import notify, request, listen from lsp

local server_config

class Routes extends lsp.response
	'initialize': (params) ->
		{ capabilities: {} }

	'initialized': ->
		-- utility notify functions are provided
		notify.log.info os.date!

		-- make a blocking LSP request
		server_config, err = request.config { section: "server.config" }
		if err
			-- errors are logged to the client
			error
				code: ErrorCodes.InternalError
				message: "Error in `initialized` handler: #{err.message}"

	'shutdown': ->
		-- notify the client of something
		notify["$/cancelRequest"] { id: 0 }
		-- there is also a library function for this
		notify.cancel_request 0

		something_bad_happened = math.random! < 0.5
		if something_bad_happened
			-- erroring in a response handler sends a response error and logs it to
			-- the client
			error
				code: ErrorCodes.InternalError
				message: "Something bad happened!"

		null

listen.routes = Routes!

-- define your own request function
request.custom_request = (foo, bar) ->
	request '$/customRequest', { :foo, :bar }

-- turn on debugging
-- currently logs anything received by or sent from this server
lsp.debug true

-- starts a loop that listens to stdio
listen!
