local null = require("cjson").null
local lsp = require("lsp-lib")
local ErrorCodes = require("lsp-lib.enum.ErrorCodes")

local MSG_SERVER_STARTED = "[%s]: server started!"
local ERR_CONFIG_NOT_FOUND = "[%s] error getting config: %s"

---@class ServerConfig
---@field hasFoo boolean

---@type ServerConfig
local server_config

-- make a blocking LSP request
---@return ServerConfig
local function get_server_config()
  ---@type any?, lsp.ResponseError?
  local config, err = lsp.request.config({ section = "test-server" })
  if err then
    -- errors are logged to the client
    error({
      code = ErrorCodes.InternalError,
      message = "error getting config: " .. err.message,
    })
  end

  -- config exists if err doesn't
  return config[1]
end

-- "initialize" should auto-complete well enough under LuaLS
lsp.response["initialize"] = function(params)
  ---@type lsp.Request.initialize.params

  -- annotation is needed here
  ---@type lsp.Response.initialize.result
  return { capabilities = {} }
end

lsp.response["initialized"] = function()
  -- utility notify functions are provided
  lsp.notify.log.info(MSG_SERVER_STARTED:format(os.date()))

  -- make a blocking LSP request
  server_config = get_server_config()

  -- you can also make an async request instead using coroutines
  local thread = coroutine.create(function()
    server_config = get_server_config()
  end)
  local ok, err = coroutine.resume(thread)
  assert(ok, err)
end

-- a custom request handler
-- it won't have any auto-complete without specifying params/returns
---@param params { doBar: boolean }
lsp.response["$/foo"] = function(params)
  if params.doBar and server_config.hasFoo then

  end
end

lsp.response["shutdown"] = function()
  -- notify the client of something
  lsp.notify["$/cancelRequest"] { id = 0 }
  -- there is also a library function for this
  lsp.notify.cancel_request(0)

  local something_bad_happened = math.random() < 0.5
  if something_bad_happened then
    -- erroring in a response handler sends a response error and logs it to the
    -- client
    error({
      code = ErrorCodes.InternalError,
      message = "Something bad happened!",
    })
  end

  return null
end

-- this allows adding new requests to lsp.request
---@class lsp-lib.Request
lsp.request = lsp.request

-- define your own request function
function lsp.request.custom_request(foo, bar)
  return lsp.request("$/customRequest", { foo = foo, bar = bar })
end

-- turn on debugging
-- currently logs anything received by or sent from this server
lsp.debug(true)

-- starts a loop that listens to stdio
lsp.listen()