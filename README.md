# lsp-lib

A library aimed at making the construction of language servers in Lua easier.

Note: This project is a work-in-progress. Expect features to change at any time!

## Usage

`lsp-lib` is packaged as a module on LuaRocks, so it can be installed there as shown below.

```sh
$ luarocks --dev install lsp-lib
```

[Lua Language Server](https://github.com/LuaLS/lua-language-server) definitions are included with the rock in `lua_modules`. The path is roughly outlined in the example below.

```jsonc
// in your .vscode/settings.json,
{
  "Lua.workspace.library": [
    // path to the CJSON addon, e.g. on Windows,
    "$USERPROFILE/AppData/Roaming/Code/User/globalStorage/sumneko.lua/addonManager/addons/lua-cjson/module/library",

    // this should point to this rock's types folder
    "lua_modules/lib/luarocks/rocks-5.X/lsp-lib/X.X.X/types"
  ]
}
```

These examples showcase some of the functions exposed by this library.

```lua
-- in Lua,
local null = require("cjson").null
local lsp = require("lsp-lib")
local ErrorCodes = require("lsp-lib.enum.ErrorCodes")

---@type lsp.ClientCapabilities
local server_config

-- this allows adding fields to the type
---@class lsp*.Request
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
    -- errors in notification handlers are logged to the client
    error("Error in `initialized` handler: " .. err.message)
  end
end

lsp.response["shutdown"] = function()
  -- notify the client of something
  lsp.notify["$/cancelRequest"] { id = 0 }
  -- there is also a library function for this
  lsp.notify.cancel_request(0)

  local something_bad_happened = math.random() < 0.5
  if something_bad_happened then
    -- errors in response handlers send a response error and logs them to the
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
```

```moonscript
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
			-- errors in notification handlers are logged to the client
			error "Error in `initialized` handler: #{err.message}"

	'shutdown': ->
		-- notify the client of something
		notify["$/cancelRequest"] { id: 0 }
		-- there is also a library function for this
		notify.cancel_request 0

		something_bad_happened = math.random! < 0.5
		if something_bad_happened
			-- errors in response handlers send a response error and logs them to the
			-- client
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
```

Documentation can be found [here](https://goldenstein64.github.io/lua-lsp-lib). (This is also not set up yet!)

## Development Setup

```sh
$ git clone https://github.com/goldenstein64/lua-lsp-lib

# set up `.env` or `.envrc` with your environment manager
# For Windows, I recommend `PS-Dotenv`

$ luarocks build --deps-only --pin
```

The `lsp-lib/` folder contains all the source code.

### Testing

Tests are located in the `spec/` folder. Busted and MoonScript are used to run them. They can be run using the following command.

```sh
$ luarocks test
```
