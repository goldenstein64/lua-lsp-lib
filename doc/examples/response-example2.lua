local lsp = require("lsp-lib")

-- a module that holds a reference to all opened documents
local documents = require("server.documents")

lsp.response["textDocument/didOpen"] = function(params)
  local document = params.textDocument

  documents[document.uri] = document
end