local TextDocumentSyncKind = require("lsp-lib.enum.TextDocumentSyncKind")
local lsp = require("lsp-lib")
local CodeActionKind = require("lsp-lib.enum.CodeActionKind")

lsp.response['initialize'] = function(params)

  ---@type lsp.ServerCapabilities
  local capabilities = {
    textDocumentSync = {
      openClose = true,
      change = TextDocumentSyncKind.Incremental,
    },

    diagnosticProvider = {
      interFileDependencies = true,
      workspaceDiagnostics = true,
      documentSelector = {
        { language = "plain", scheme = "file" },
      },
    },

    -- other capabilities...
  }

  ---@type lsp.Response.initialize.result
  local response = {
    capabilities = capabilities,
    serverInfo = {
      name = "plain text language server",
      version = "0.0.1",
    },
  }

  return response
end