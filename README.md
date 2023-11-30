# lua-lsp-lib

A library aimed at making the construction of language servers easier.

Note: This project is a work-in-progress. Expect features to change at any time!

## Setup

```sh
# Note that this hasn't been uploaded to LuaRocks yet
$ luarocks install lsp-lib
```

Lua language server definitions are included with the rock in `lua_modules`. The path is roughly outlined in the example below.

```jsonc
// in your .vscode/settings.json,
{
  "Lua.workspace.library": [
    // this should point to this rock's types folder
    "lua_modules/lib/luarocks/rocks-5.X/lsp-lib/X.X.X/types"
  ]
}
```

## Usage

These examples showcase some of the functions exposed by this library.

```lua
-- in Lua,
local null = require('cjson').null
local lsp = require('lsp-lib')

-- 'initialize' should auto-complete well enough under LuaLS
lsp.response['initialize'] = function(params)

  lsp.async(function()
    -- make a blocking LSP request
    lsp.config = assert(lsp.request.config())
  end)

  -- utility notify functions are provided too
  lsp.notify.log.info(os.date())

  -- annotation is needed here due to a shortcoming of LuaLS
  ---@type lsp.Response.initialize.result
  return {
    capabilities = {}
  }
end

lsp.response['shutdown'] = function()
  -- notify the client of something
  lsp.notify['$/cancelRequest'] { id = 0 }

  return null
end

-- define your own request function
function lsp.request.custom_request(foo, bar)
  return lsp.request('$/customRequest', { foo = foo, bar = bar })
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

lsp = require 'lsp-lib'
import notify, request, response, listen, async from lsp

class Response extends response
  'initialize': (params) ->
    -- make a (non-blocking) LSP request
    async -> lsp.config = assert request.config!

    -- utility notify functions are provided too
    notify.log.info os.date!

    { capabilities: {} }

  'shutdown': ->
    -- notify the client of something
    notify['$/cancelRequest'] { id: 0 }
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
```

Documentation can be found [here](https://goldenstein64.github.io/lua-lsp-lib).

## Testing

This repo uses Busted/MoonScript for its tests. They can be run using the below command.

```sh
$ luarocks test
```

