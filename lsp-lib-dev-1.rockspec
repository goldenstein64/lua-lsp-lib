package = "lsp-lib"
version = "dev-1"
source = {
   url = "*** please add URL for source tarball, zip or repository here ***"
}
description = {
   homepage = "*** please enter a project homepage ***",
   license = "*** please specify a license ***"
}
dependencies = {
   "lua ~> 5.1"
}
build = {
   type = "builtin",
   modules = {
      ["lsp-lib.enum.CodeActionKind"] = "lsp-lib/enum/CodeActionKind.lua",
      ["lsp-lib.enum.CodeActionTriggerKind"] = "lsp-lib/enum/CodeActionTriggerKind.lua",
      ["lsp-lib.enum.CompletionItemKind"] = "lsp-lib/enum/CompletionItemKind.lua",
      ["lsp-lib.enum.CompletionItemTag"] = "lsp-lib/enum/CompletionItemTag.lua",
      ["lsp-lib.enum.CompletionTriggerKind"] = "lsp-lib/enum/CompletionTriggerKind.lua",
      ["lsp-lib.enum.DiagnosticSeverity"] = "lsp-lib/enum/DiagnosticSeverity.lua",
      ["lsp-lib.enum.DiagnosticTag"] = "lsp-lib/enum/DiagnosticTag.lua",
      ["lsp-lib.enum.DocumentDiagnosticReportKind"] = "lsp-lib/enum/DocumentDiagnosticReportKind.lua",
      ["lsp-lib.enum.DocumentHighlightKind"] = "lsp-lib/enum/DocumentHighlightKind.lua",
      ["lsp-lib.enum.ErrorCodes"] = "lsp-lib/enum/ErrorCodes.lua",
      ["lsp-lib.enum.FailureHandlingKind"] = "lsp-lib/enum/FailureHandlingKind.lua",
      ["lsp-lib.enum.FileChangeType"] = "lsp-lib/enum/FileChangeType.lua",
      ["lsp-lib.enum.FileOperationPatternKind"] = "lsp-lib/enum/FileOperationPatternKind.lua",
      ["lsp-lib.enum.FoldingRangeKind"] = "lsp-lib/enum/FoldingRangeKind.lua",
      ["lsp-lib.enum.InlayHintKind"] = "lsp-lib/enum/InlayHintKind.lua",
      ["lsp-lib.enum.InsertTextFormat"] = "lsp-lib/enum/InsertTextFormat.lua",
      ["lsp-lib.enum.InsertTextMode"] = "lsp-lib/enum/InsertTextMode.lua",
      ["lsp-lib.enum.LSPErrorCodes"] = "lsp-lib/enum/LSPErrorCodes.lua",
      ["lsp-lib.enum.MarkupKind"] = "lsp-lib/enum/MarkupKind.lua",
      ["lsp-lib.enum.MessageType"] = "lsp-lib/enum/MessageType.lua",
      ["lsp-lib.enum.MonikerKind"] = "lsp-lib/enum/MonikerKind.lua",
      ["lsp-lib.enum.NotebookCellKind"] = "lsp-lib/enum/NotebookCellKind.lua",
      ["lsp-lib.enum.PositionEncodingKind"] = "lsp-lib/enum/PositionEncodingKind.lua",
      ["lsp-lib.enum.PrepareSupportDefaultBehavior"] = "lsp-lib/enum/PrepareSupportDefaultBehavior.lua",
      ["lsp-lib.enum.ResourceOperationKind"] = "lsp-lib/enum/ResourceOperationKind.lua",
      ["lsp-lib.enum.SemanticTokenModifiers"] = "lsp-lib/enum/SemanticTokenModifiers.lua",
      ["lsp-lib.enum.SemanticTokenTypes"] = "lsp-lib/enum/SemanticTokenTypes.lua",
      ["lsp-lib.enum.SignatureHelpTriggerKind"] = "lsp-lib/enum/SignatureHelpTriggerKind.lua",
      ["lsp-lib.enum.SymbolKind"] = "lsp-lib/enum/SymbolKind.lua",
      ["lsp-lib.enum.SymbolTag"] = "lsp-lib/enum/SymbolTag.lua",
      ["lsp-lib.enum.TextDocumentSaveReason"] = "lsp-lib/enum/TextDocumentSaveReason.lua",
      ["lsp-lib.enum.TextDocumentSyncKind"] = "lsp-lib/enum/TextDocumentSyncKind.lua",
      ["lsp-lib.enum.TokenFormat"] = "lsp-lib/enum/TokenFormat.lua",
      ["lsp-lib.enum.TraceValues"] = "lsp-lib/enum/TraceValues.lua",
      ["lsp-lib.enum.UniquenessLevel"] = "lsp-lib/enum/UniquenessLevel.lua",
      ["lsp-lib.enum.WatchKind"] = "lsp-lib/enum/WatchKind.lua",
      ["lsp-lib.handle.errors"] = "lsp-lib/handle/errors.lua",
      ["lsp-lib.handle.init"] = "lsp-lib/handle/init.lua",
      ["lsp-lib.io.init"] = "lsp-lib/io/init.lua",
      ["lsp-lib.response"] = "lsp-lib/response.lua",
      ["lsp-lib.transform.position"] = "lsp-lib/transform/position.lua",
      ["lsp-lib.transform.range"] = "lsp-lib/transform/range.lua",
      ["lsp-lib.io.stdio"] = "lsp-lib/io/stdio.lua",
      ["lsp-lib.error"] = "lsp-lib/error.lua",
      ["lsp-lib.init"] = "lsp-lib/init.lua",
      ["lsp-lib.notify"] = "lsp-lib/notify.lua",
      ["lsp-lib.request"] = "lsp-lib/request.lua",
   },
   copy_directories = { "doc", "types" }
}
