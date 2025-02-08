local null = require("cjson").null

local noop = function() end

---@type lsp*.Response
---@diagnostic disable-next-line: missing-fields
local defaults = {}

defaults["initialize"] = function(params)
	return { capabilities = {} }
end

defaults["initialized"] = noop

defaults["shutdown"] = function(params)
	return null
end

defaults["exit"] = noop

---a table that is meant to be populated with route implementations by the user.
---This is the default table `lsp.listen` uses to query routes.
---
---Below is an example of a route implementation for the `initialize` request.
---
---```lua
---local TextDocumentSyncKind = require("lsp-lib.enum.TextDocumentSyncKind")
---local lsp = require("lsp-lib")
---
---lsp.response['initialize'] = function(params)
---
---  ---@type lsp.ServerCapabilities
---  local capabilities = {
---    textDocumentSync = {
---      openClose = true,
---      change = TextDocumentSyncKind.Incremental,
---    },
---
---    diagnosticProvider = {
---      interFileDependencies = true,
---      workspaceDiagnostics = true,
---      documentSelector = {
---        { language = "plain", scheme = "file" },
---      },
---    },
---
---    -- other capabilities...
---  }
---
---  ---@type lsp.Response.initialize.result
---  local response = {
---    capabilities = capabilities,
---    serverInfo = {
---      name = "plain text language server",
---      version = "0.0.1",
---    },
---  }
---
---  return response
---end
---```
---
---And here is another example for the `textDocument/didOpen` notification.
---
---```lua
---local lsp = require("lsp-lib")
---
----- a module that holds a reference to all opened documents
---local documents = require("server.documents")
---
---lsp.response["textDocument/didOpen"] = function(params)
---  local document = params.textDocument
---
---  documents[document.uri] = document
---end
---```
---
---If a route throws an error, it could get handled in several ways based on the
---kind of error object that was passed:
---
---- When the error object is a table with a `message` and `code` field, it's
---  treated as a response error directly, and the `message` field is treated as
---  an error message.
---- Otherwise, a response error with an `InternalError` code is generated with
---  the given value as its `message` field.
---
---If the error was caught within a request route, a response error is sent. In
---all cases, the error message is logged.
---
---If a route is queried but unimplemented, an error is logged, and a response
---error with a `MethodNotFound` code is sent if required.
---
---If a request implementation does not return a response value, an error is
---logged, and a response error with an `InternalError` code is sent. If a
---notification implementation returns a value, an error is logged.
---
---All supported request and notification implementations are outlined in the
---[LSP 3.17 specification](https://microsoft.github.io/language-server-protocol/specifications/lsp/3.17/specification/),
---and custom requests and notifications can be implemented.
---@class lsp*.Response
local response = {}

setmetatable(response, { __index = defaults })

return response
