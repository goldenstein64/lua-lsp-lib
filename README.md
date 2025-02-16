# lsp-lib

A library aimed at making the construction of language servers in Lua easier. For general information about the LSP, see the [VSCode extension guide](https://code.visualstudio.com/api/language-extensions/language-server-extension-guide), which also describes what language servers are for and the problems they solve. For precise information about what features the server can provide and how the protocol is followed, see the [LSP specification](https://microsoft.github.io/language-server-protocol/specifications/lsp/3.17/specification/).

## Installation

`lsp-lib` is packaged as a module on LuaRocks, so it can be installed there as shown below.

```sh
$ luarocks --dev install lsp-lib
```

[Lua Language Server](https://github.com/LuaLS/lua-language-server) definitions are included with the rock in `lua_modules`. The path is roughly outlined in the example below.

```jsonc
// in your .vscode/settings.json,
{
  "Lua.workspace.library": [
    // path to the CJSON addon
    "${addons}/lua-cjson/module/library",

    // this should point to this rock's types folder
    "lua_modules/lib/luarocks/rocks-5.X/lsp-lib/X.X.X/types"
  ]
}
```

## Usage

See the [`doc/`](./doc/) folder for a tutorial and examples.

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
