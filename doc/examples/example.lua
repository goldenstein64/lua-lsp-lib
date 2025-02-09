-- in Lua,
local null = require("cjson").null
local lsp = require("lsp-lib")
local ErrorCodes = require("lsp-lib.enum.ErrorCodes")

---@type lsp.ClientCapabilities
local server_config

-- this allows adding fields to the type
---@class lsp-lib.Request
lsp.request = lsp.request

-- "initialize" should auto-complete well enough under LuaLS
lsp.response["initialize"] = function(params)
  -- annotation is needed here due to a shortcoming of LuaLS
  ---@type lsp.Response.initialize.result
  return { capabilities = {} }
end

lsp.response["initialized"] = function()
  -- utility notify functions are provided
  lsp.notify.log.info(os.date())

  -- make a blocking LSP request
  local err
  server_config, err = lsp.request.config()
  if err then
    -- errors are logged to the client
    error({
      code = ErrorCodes.InternalError,
      message = "Error in `initialized` handler: " .. err.message,
    })
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

-- define your own request function
function lsp.request.custom_request(foo, bar)
  return lsp.request("$/customRequest", { foo = foo, bar = bar })
end

-- turn on debugging
-- currently logs anything received by or sent from this server
lsp.debug(true)

-- starts a loop that listens to stdio
lsp.listen()