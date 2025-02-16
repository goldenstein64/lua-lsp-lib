# Tutorial

This is the smallest bare-bones language server you can make.

```lua
-- server.lua
local lsp = require("lsp-lib")

lsp.listen()
```

Running this server doesn't give the client any basic server info, like its capabilities, name, or version. This can be specified in the handler for the [`initialize`](https://microsoft.github.io/language-server-protocol/specifications/lsp/3.17/specification/#initialize) request.

```lua
local lsp = require("lsp-lib")

lsp.response["initialize"] = function(params)
  -- `params` contain the client's capabilities
  -- typed as `lsp.Request.initialize.params`

  ---@type lsp.Response.initialize.result
  return {
    capabilities = {
      -- Intellisense is available here thanks to `@type` annotation
    },
    serverInfo = {
      name = "plain text language server",
      version = "0.0.1",
    }
  }
end

lsp.listen()
```

`lsp.response` tells the server what to do when it receives a message from the client, defined at [`lsp-lib/response.lua`](./lsp-lib/response.lua). This is done by defining functions on it, with the key being the message it will respond to. Every function takes a `params` argument, although they do not always have useful information in them.

These messages are either requests or notifications. Requests require the handler to either return a value or error, whereas notifications require they do not return. Lua LS will tell you when the handler requires a return value, and the server will send a response error to the client at runtime if this constraint is not followed.

When a handler returns a value, it fills the `result` field of an LSP response. When a handler throws an error, the error argument fills the `error` field of an LSP response. A full-fledged error object can be sent, and a string can be sent as well.

```lua
local ErrorCodes = require("lsp-lib.enum.ErrorCodes")
local TraceValues = require("lsp-lib.enum.TraceValues")

local server = {
    ---@type lsp.TraceValues
    trace = TraceValues.Off,
}

local function supports_trace_value(value)
  for _, trace_value in pairs(TraceValues) do
    if value == trace_value then
      return true
    end
  end

  return false
end

local ErrUnknownVerbosity =
  "'$/setTrace' does not use the verbosity level '%s'"

lsp.response["$/setTrace"] = function(params)
  local value = params.value
  if not supports_trace_value(value) then
    error({
      code = ErrorCodes.InvalidRequest,
      message = ErrUnknownVerbosity:format(value),
    })
  end

  server.trace = value
end

lsp.listen()
```

The server can also send requests and notifications. For example, you may want the server to log a status message. You can do so by sending a [`window/logMessage` notification](https://microsoft.github.io/language-server-protocol/specifications/lsp/3.17/specification/#window_logMessage) with `lsp.notify`.

```lua
local lsp = require("lsp-lib")
local MessageType =  require("lsp-lib.enum.MessageType")

-- send with raw params:
lsp.notify["window/logMessage"]({
  type = MessageType.Info,
  message = "server started!",
})

-- send using the utility function:
lsp.notify.log.info("server started!")
```

`lsp.notify` is a module used for sending notifications to the client, defined at [`lsp-lib/notify.lua`](./lsp-lib/notify.lua).

You may want to retrieve the server's configuration from the client. You can do by sending a [`workspace/configuration` request](https://microsoft.github.io/language-server-protocol/specifications/lsp/3.17/specification/#workspace_configuration) with `lsp.request`.

```lua
local lsp = require("lsp-lib")

-- send with raw params:
local result, err = lsp.request["workspace/configuration"]({
  items = {
    {
      scopeUri = "file:///some/file.txt",
      section = "plain-text",
    }
  }
})

-- send using the utility function:
local result, err = lsp.request.config({
  scopeUri = "file:///some/file.txt",
  section = "plain-text",
})
```

It should be noted that requests block the current thread. It gets resumed again when the client's response is received. Either the `result` or `err` variable will be non-nil, and the other will be nil.

Requests can be sent asynchronously by using a coroutine. `lsp-lib` provides a convenience function that does this, `lsp.async`.

```lua
local co = coroutine.create(function(section)
  local result, err = lsp.request.config({ section = section })
  if err then
    lsp.notify.log.error(string.format(
      "error response received: %s",
      tostring(err)
    ))
  end
  print(result, err)
end)
local ok, msg = coroutine.resume(co, "plain-text")

-- using lsp.async:
local ok, msg = lsp.async(function(section)
  local result, err = lsp.request.config({ section = section })
  print(result, err)
end, "plain-text")
```

Note that most feature-specific methods require its corresponding capability to be registered before being used. This can be specified in the `initialize` handler. For example, here is a derived [`textDocument/hover`](https://microsoft.github.io/language-server-protocol/specifications/lsp/3.17/specification/#textDocument_hover) implementation.

```lua
local lsp = require("lsp-lib")

lsp.response["initialize"] = function(params)
  ---@type lsp.Response.initialize.result
  return {
    capabilities = {
      hoverProvider = { workDoneProgress = false },
    },
    serverInfo = {
      name = "plain text language server",
      version = "0.0.1",
    }
  }
end

local example_code_block = [[
-- an example Lua code block
print("foo")
]]

lsp.response["textDocument/hover"] = function(params)
  ---@type lsp.Response.textDocument-hover.result
  return {
    contents = {
      "Here is some hover information :)",
      ---@type lsp.MarkedString.alias.2
      {
        language = "lua",
        value = example_code_block,
      }
    }
  }
end

lsp.listen()
```