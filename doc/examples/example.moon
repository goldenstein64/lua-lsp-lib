import null from require 'cjson'

ErrorCodes = require 'lsp-lib.enum.ErrorCodes'
lsp = require 'lsp-lib'
import notify, request, listen from lsp

local server_config

get_server_config = () ->
  config, err = request.config { section: "test-server" }
  if err
    -- errors in notifications are logged to the client
    error
      code: ErrorCodes.InternalError
      message: "[#{os.date!}] error getting config: #{err.message}"

  config[1]

class Routes extends lsp.response
  'initialize': (params) ->
    { capabilities: {} }

  'initialized': ->
    -- utility notify functions are provided
    notify.log.info "[#{os.date!}]: server started!"

    -- make a blocking LSP request
    server_config = get_server_config!

    -- you can also make an async request instead using coroutines
    thread = coroutine.create ->
      server_config = get_server_config!

    ok, err = coroutine.resume thread
    assert ok, err

  -- a custom request handler
  '$/foo': (params) ->
    if params.doBar and server_config.hasFoo
      nil

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
