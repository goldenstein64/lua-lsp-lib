---@meta

---@class lsp*.Response
local response = {}

---A request to resolve the implementation locations of a symbol at a given text
---document position. The request's parameter is of type {@link TextDocumentPositionParams}
---the response is of type {@link Definition} or a Thenable that resolves to such.
---@type fun(params: lsp.Request.textDocument-implementation.params): lsp.Response.textDocument-implementation.result
response["textDocument/implementation"] = nil

---A request to resolve the type definition locations of a symbol at a given text
---document position. The request's parameter is of type {@link TextDocumentPositionParams}
---the response is of type {@link Definition} or a Thenable that resolves to such.
---@type fun(params: lsp.Request.textDocument-typeDefinition.params): lsp.Response.textDocument-typeDefinition.result
response["textDocument/typeDefinition"] = nil

---A request to list all color symbols found in a given text document. The request's
---parameter is of type {@link DocumentColorParams} the
---response is of type {@link ColorInformation ColorInformation[]} or a Thenable
---that resolves to such.
---@type fun(params: lsp.Request.textDocument-documentColor.params): lsp.Response.textDocument-documentColor.result
response["textDocument/documentColor"] = nil

---A request to list all presentation for a color. The request's
---parameter is of type {@link ColorPresentationParams} the
---response is of type {@link ColorInformation ColorInformation[]} or a Thenable
---that resolves to such.
---@type fun(params: lsp.Request.textDocument-colorPresentation.params): lsp.Response.textDocument-colorPresentation.result
response["textDocument/colorPresentation"] = nil

---A request to provide folding ranges in a document. The request's
---parameter is of type {@link FoldingRangeParams}, the
---response is of type {@link FoldingRangeList} or a Thenable
---that resolves to such.
---@type fun(params: lsp.Request.textDocument-foldingRange.params): lsp.Response.textDocument-foldingRange.result
response["textDocument/foldingRange"] = nil

---A request to resolve the type definition locations of a symbol at a given text
---document position. The request's parameter is of type {@link TextDocumentPositionParams}
---the response is of type {@link Declaration} or a typed array of {@link DeclarationLink}
---or a Thenable that resolves to such.
---@type fun(params: lsp.Request.textDocument-declaration.params): lsp.Response.textDocument-declaration.result
response["textDocument/declaration"] = nil

---A request to provide selection ranges in a document. The request's
---parameter is of type {@link SelectionRangeParams}, the
---response is of type {@link SelectionRange SelectionRange[]} or a Thenable
---that resolves to such.
---@type fun(params: lsp.Request.textDocument-selectionRange.params): lsp.Response.textDocument-selectionRange.result
response["textDocument/selectionRange"] = nil

---A request to result a `CallHierarchyItem` in a document at a given position.
---Can be used as an input to an incoming or outgoing call hierarchy.
---@since 3.16.0
---@type fun(params: lsp.Request.textDocument-prepareCallHierarchy.params): lsp.Response.textDocument-prepareCallHierarchy.result
response["textDocument/prepareCallHierarchy"] = nil

---A request to resolve the incoming calls for a given `CallHierarchyItem`.
---@since 3.16.0
---@type fun(params: lsp.Request.callHierarchy-incomingCalls.params): lsp.Response.callHierarchy-incomingCalls.result
response["callHierarchy/incomingCalls"] = nil

---A request to resolve the outgoing calls for a given `CallHierarchyItem`.
---@since 3.16.0
---@type fun(params: lsp.Request.callHierarchy-outgoingCalls.params): lsp.Response.callHierarchy-outgoingCalls.result
response["callHierarchy/outgoingCalls"] = nil

---@since 3.16.0
---@type fun(params: lsp.Request.textDocument-semanticTokens-full.params): lsp.Response.textDocument-semanticTokens-full.result
response["textDocument/semanticTokens/full"] = nil

---@since 3.16.0
---@type fun(params: lsp.Request.textDocument-semanticTokens-full-delta.params): lsp.Response.textDocument-semanticTokens-full-delta.result
response["textDocument/semanticTokens/full/delta"] = nil

---@since 3.16.0
---@type fun(params: lsp.Request.textDocument-semanticTokens-range.params): lsp.Response.textDocument-semanticTokens-range.result
response["textDocument/semanticTokens/range"] = nil

---A request to provide ranges that can be edited together.
---@since 3.16.0
---@type fun(params: lsp.Request.textDocument-linkedEditingRange.params): lsp.Response.textDocument-linkedEditingRange.result
response["textDocument/linkedEditingRange"] = nil

---The will create files request is sent from the client to the server before files are actually
---created as long as the creation is triggered from within the client.
---The request can return a `WorkspaceEdit` which will be applied to workspace before the
---files are created. Hence the `WorkspaceEdit` can not manipulate the content of the file
---to be created.
---@since 3.16.0
---@type fun(params: lsp.Request.workspace-willCreateFiles.params): lsp.Response.workspace-willCreateFiles.result
response["workspace/willCreateFiles"] = nil

---The will rename files request is sent from the client to the server before files are actually
---renamed as long as the rename is triggered from within the client.
---@since 3.16.0
---@type fun(params: lsp.Request.workspace-willRenameFiles.params): lsp.Response.workspace-willRenameFiles.result
response["workspace/willRenameFiles"] = nil

---The did delete files notification is sent from the client to the server when
---files were deleted from within the client.
---@since 3.16.0
---@type fun(params: lsp.Request.workspace-willDeleteFiles.params): lsp.Response.workspace-willDeleteFiles.result
response["workspace/willDeleteFiles"] = nil

---A request to get the moniker of a symbol at a given text document position.
---The request parameter is of type {@link TextDocumentPositionParams}.
---The response is of type {@link Moniker Moniker[]} or `null`.
---@type fun(params: lsp.Request.textDocument-moniker.params): lsp.Response.textDocument-moniker.result
response["textDocument/moniker"] = nil

---A request to result a `TypeHierarchyItem` in a document at a given position.
---Can be used as an input to a subtypes or supertypes type hierarchy.
---@since 3.17.0
---@type fun(params: lsp.Request.textDocument-prepareTypeHierarchy.params): lsp.Response.textDocument-prepareTypeHierarchy.result
response["textDocument/prepareTypeHierarchy"] = nil

---A request to resolve the supertypes for a given `TypeHierarchyItem`.
---@since 3.17.0
---@type fun(params: lsp.Request.typeHierarchy-supertypes.params): lsp.Response.typeHierarchy-supertypes.result
response["typeHierarchy/supertypes"] = nil

---A request to resolve the subtypes for a given `TypeHierarchyItem`.
---@since 3.17.0
---@type fun(params: lsp.Request.typeHierarchy-subtypes.params): lsp.Response.typeHierarchy-subtypes.result
response["typeHierarchy/subtypes"] = nil

---A request to provide inline values in a document. The request's parameter is of
---type {@link InlineValueParams}, the response is of type
---{@link InlineValue InlineValue[]} or a Thenable that resolves to such.
---@since 3.17.0
---@type fun(params: lsp.Request.textDocument-inlineValue.params): lsp.Response.textDocument-inlineValue.result
response["textDocument/inlineValue"] = nil

---A request to provide inlay hints in a document. The request's parameter is of
---type {@link InlayHintsParams}, the response is of type
---{@link InlayHint InlayHint[]} or a Thenable that resolves to such.
---@since 3.17.0
---@type fun(params: lsp.Request.textDocument-inlayHint.params): lsp.Response.textDocument-inlayHint.result
response["textDocument/inlayHint"] = nil

---A request to resolve additional properties for an inlay hint.
---The request's parameter is of type {@link InlayHint}, the response is
---of type {@link InlayHint} or a Thenable that resolves to such.
---@since 3.17.0
---@type fun(params: lsp.Request.inlayHint-resolve.params): lsp.Response.inlayHint-resolve.result
response["inlayHint/resolve"] = nil

---The document diagnostic request definition.
---@since 3.17.0
---@type fun(params: lsp.Request.textDocument-diagnostic.params): lsp.Response.textDocument-diagnostic.result
response["textDocument/diagnostic"] = nil

---The workspace diagnostic request definition.
---@since 3.17.0
---@type fun(params: lsp.Request.workspace-diagnostic.params): lsp.Response.workspace-diagnostic.result
response["workspace/diagnostic"] = nil

---A request to provide inline completions in a document. The request's parameter is of
---type {@link InlineCompletionParams}, the response is of type
---{@link InlineCompletion InlineCompletion[]} or a Thenable that resolves to such.
---@since 3.18.0
---@proposed
---@type fun(params: lsp.Request.textDocument-inlineCompletion.params): lsp.Response.textDocument-inlineCompletion.result
response["textDocument/inlineCompletion"] = nil

---The initialize request is sent from the client to the server.
---It is sent once as the request after starting up the server.
---The requests parameter is of type {@link InitializeParams}
---the response if of type {@link InitializeResult} of a Thenable that
---resolves to such.
---@type fun(params: lsp.Request.initialize.params): lsp.Response.initialize.result
response["initialize"] = nil

---A shutdown request is sent from the client to the server.
---It is sent once when the client decides to shutdown the
---server. The only notification that is sent after a shutdown request
---is the exit event.
---@type fun(params: lsp.Request.shutdown.params): lsp.Response.shutdown.result
response["shutdown"] = nil

---A document will save request is sent from the client to the server before
---the document is actually saved. The request can return an array of TextEdits
---which will be applied to the text document before it is saved. Please note that
---clients might drop results if computing the text edits took too long or if a
---server constantly fails on this request. This is done to keep the save fast and
---reliable.
---@type fun(params: lsp.Request.textDocument-willSaveWaitUntil.params): lsp.Response.textDocument-willSaveWaitUntil.result
response["textDocument/willSaveWaitUntil"] = nil

---Request to request completion at a given text document position. The request's
---parameter is of type {@link TextDocumentPosition} the response
---is of type {@link CompletionItem CompletionItem[]} or {@link CompletionList}
---or a Thenable that resolves to such.
---The request can delay the computation of the {@link CompletionItem.detail `detail`}
---and {@link CompletionItem.documentation `documentation`} properties to the `completionItem/resolve`
---request. However, properties that are needed for the initial sorting and filtering, like `sortText`,
---`filterText`, `insertText`, and `textEdit`, must not be changed during resolve.
---@type fun(params: lsp.Request.textDocument-completion.params): lsp.Response.textDocument-completion.result
response["textDocument/completion"] = nil

---Request to resolve additional information for a given completion item.The request's
---parameter is of type {@link CompletionItem} the response
---is of type {@link CompletionItem} or a Thenable that resolves to such.
---@type fun(params: lsp.Request.completionItem-resolve.params): lsp.Response.completionItem-resolve.result
response["completionItem/resolve"] = nil

---Request to request hover information at a given text document position. The request's
---parameter is of type {@link TextDocumentPosition} the response is of
---type {@link Hover} or a Thenable that resolves to such.
---@type fun(params: lsp.Request.textDocument-hover.params): lsp.Response.textDocument-hover.result
response["textDocument/hover"] = nil

---@type fun(params: lsp.Request.textDocument-signatureHelp.params): lsp.Response.textDocument-signatureHelp.result
response["textDocument/signatureHelp"] = nil

---A request to resolve the definition location of a symbol at a given text
---document position. The request's parameter is of type {@link TextDocumentPosition}
---the response is of either type {@link Definition} or a typed array of
---{@link DefinitionLink} or a Thenable that resolves to such.
---@type fun(params: lsp.Request.textDocument-definition.params): lsp.Response.textDocument-definition.result
response["textDocument/definition"] = nil

---A request to resolve project-wide references for the symbol denoted
---by the given text document position. The request's parameter is of
---type {@link ReferenceParams} the response is of type
---{@link Location Location[]} or a Thenable that resolves to such.
---@type fun(params: lsp.Request.textDocument-references.params): lsp.Response.textDocument-references.result
response["textDocument/references"] = nil

---Request to resolve a {@link DocumentHighlight} for a given
---text document position. The request's parameter is of type {@link TextDocumentPosition}
---the request response is an array of type {@link DocumentHighlight}
---or a Thenable that resolves to such.
---@type fun(params: lsp.Request.textDocument-documentHighlight.params): lsp.Response.textDocument-documentHighlight.result
response["textDocument/documentHighlight"] = nil

---A request to list all symbols found in a given text document. The request's
---parameter is of type {@link TextDocumentIdentifier} the
---response is of type {@link SymbolInformation SymbolInformation[]} or a Thenable
---that resolves to such.
---@type fun(params: lsp.Request.textDocument-documentSymbol.params): lsp.Response.textDocument-documentSymbol.result
response["textDocument/documentSymbol"] = nil

---A request to provide commands for the given text document and range.
---@type fun(params: lsp.Request.textDocument-codeAction.params): lsp.Response.textDocument-codeAction.result
response["textDocument/codeAction"] = nil

---Request to resolve additional information for a given code action.The request's
---parameter is of type {@link CodeAction} the response
---is of type {@link CodeAction} or a Thenable that resolves to such.
---@type fun(params: lsp.Request.codeAction-resolve.params): lsp.Response.codeAction-resolve.result
response["codeAction/resolve"] = nil

---A request to list project-wide symbols matching the query string given
---by the {@link WorkspaceSymbolParams}. The response is
---of type {@link SymbolInformation SymbolInformation[]} or a Thenable that
---resolves to such.
---@since 3.17.0 - support for WorkspaceSymbol in the returned data. Clients
--- need to advertise support for WorkspaceSymbols via the client capability
--- `workspace.symbol.resolveSupport`.
---@type fun(params: lsp.Request.workspace-symbol.params): lsp.Response.workspace-symbol.result
response["workspace/symbol"] = nil

---A request to resolve the range inside the workspace
---symbol's location.
---@since 3.17.0
---@type fun(params: lsp.Request.workspaceSymbol-resolve.params): lsp.Response.workspaceSymbol-resolve.result
response["workspaceSymbol/resolve"] = nil

---A request to provide code lens for the given text document.
---@type fun(params: lsp.Request.textDocument-codeLens.params): lsp.Response.textDocument-codeLens.result
response["textDocument/codeLens"] = nil

---A request to resolve a command for a given code lens.
---@type fun(params: lsp.Request.codeLens-resolve.params): lsp.Response.codeLens-resolve.result
response["codeLens/resolve"] = nil

---A request to provide document links
---@type fun(params: lsp.Request.textDocument-documentLink.params): lsp.Response.textDocument-documentLink.result
response["textDocument/documentLink"] = nil

---Request to resolve additional information for a given document link. The request's
---parameter is of type {@link DocumentLink} the response
---is of type {@link DocumentLink} or a Thenable that resolves to such.
---@type fun(params: lsp.Request.documentLink-resolve.params): lsp.Response.documentLink-resolve.result
response["documentLink/resolve"] = nil

---A request to format a whole document.
---@type fun(params: lsp.Request.textDocument-formatting.params): lsp.Response.textDocument-formatting.result
response["textDocument/formatting"] = nil

---A request to format a range in a document.
---@type fun(params: lsp.Request.textDocument-rangeFormatting.params): lsp.Response.textDocument-rangeFormatting.result
response["textDocument/rangeFormatting"] = nil

---A request to format ranges in a document.
---@since 3.18.0
---@proposed
---@type fun(params: lsp.Request.textDocument-rangesFormatting.params): lsp.Response.textDocument-rangesFormatting.result
response["textDocument/rangesFormatting"] = nil

---A request to format a document on type.
---@type fun(params: lsp.Request.textDocument-onTypeFormatting.params): lsp.Response.textDocument-onTypeFormatting.result
response["textDocument/onTypeFormatting"] = nil

---A request to rename a symbol.
---@type fun(params: lsp.Request.textDocument-rename.params): lsp.Response.textDocument-rename.result
response["textDocument/rename"] = nil

---A request to test and perform the setup necessary for a rename.
---@since 3.16 - support for default behavior
---@type fun(params: lsp.Request.textDocument-prepareRename.params): lsp.Response.textDocument-prepareRename.result
response["textDocument/prepareRename"] = nil

---A request send from the client to the server to execute a command. The request might return
---a workspace edit which the client will apply to the workspace.
---@type fun(params: lsp.Request.workspace-executeCommand.params): lsp.Response.workspace-executeCommand.result
response["workspace/executeCommand"] = nil

---The `workspace/didChangeWorkspaceFolders` notification is sent from the client to the server when the workspace
---folder configuration changes.
---@type fun(params: lsp.Notification.workspace-didChangeWorkspaceFolders.params)
response["workspace/didChangeWorkspaceFolders"] = nil

---The `window/workDoneProgress/cancel` notification is sent from  the client to the server to cancel a progress
---initiated on the server side.
---@type fun(params: lsp.Notification.window-workDoneProgress-cancel.params)
response["window/workDoneProgress/cancel"] = nil

---The did create files notification is sent from the client to the server when
---files were created from within the client.
---@since 3.16.0
---@type fun(params: lsp.Notification.workspace-didCreateFiles.params)
response["workspace/didCreateFiles"] = nil

---The did rename files notification is sent from the client to the server when
---files were renamed from within the client.
---@since 3.16.0
---@type fun(params: lsp.Notification.workspace-didRenameFiles.params)
response["workspace/didRenameFiles"] = nil

---The will delete files request is sent from the client to the server before files are actually
---deleted as long as the deletion is triggered from within the client.
---@since 3.16.0
---@type fun(params: lsp.Notification.workspace-didDeleteFiles.params)
response["workspace/didDeleteFiles"] = nil

---A notification sent when a notebook opens.
---@since 3.17.0
---@type fun(params: lsp.Notification.notebookDocument-didOpen.params)
response["notebookDocument/didOpen"] = nil

---@type fun(params: lsp.Notification.notebookDocument-didChange.params)
response["notebookDocument/didChange"] = nil

---A notification sent when a notebook document is saved.
---@since 3.17.0
---@type fun(params: lsp.Notification.notebookDocument-didSave.params)
response["notebookDocument/didSave"] = nil

---A notification sent when a notebook closes.
---@since 3.17.0
---@type fun(params: lsp.Notification.notebookDocument-didClose.params)
response["notebookDocument/didClose"] = nil

---The initialized notification is sent from the client to the
---server after the client is fully initialized and the server
---is allowed to send requests from the server to the client.
---@type fun(params: lsp.Notification.initialized.params)
response["initialized"] = nil

---The exit event is sent from the client to the server to
---ask the server to exit its process.
---@type fun(params: lsp.Notification.exit.params)
response["exit"] = nil

---The configuration change notification is sent from the client to the server
---when the client's configuration has changed. The notification contains
---the changed configuration as defined by the language client.
---@type fun(params: lsp.Notification.workspace-didChangeConfiguration.params)
response["workspace/didChangeConfiguration"] = nil

---The document open notification is sent from the client to the server to signal
---newly opened text documents. The document's truth is now managed by the client
---and the server must not try to read the document's truth using the document's
---uri. Open in this sense means it is managed by the client. It doesn't necessarily
---mean that its content is presented in an editor. An open notification must not
---be sent more than once without a corresponding close notification send before.
---This means open and close notification must be balanced and the max open count
---is one.
---@type fun(params: lsp.Notification.textDocument-didOpen.params)
response["textDocument/didOpen"] = nil

---The document change notification is sent from the client to the server to signal
---changes to a text document.
---@type fun(params: lsp.Notification.textDocument-didChange.params)
response["textDocument/didChange"] = nil

---The document close notification is sent from the client to the server when
---the document got closed in the client. The document's truth now exists where
---the document's uri points to (e.g. if the document's uri is a file uri the
---truth now exists on disk). As with the open notification the close notification
---is about managing the document's content. Receiving a close notification
---doesn't mean that the document was open in an editor before. A close
---notification requires a previous open notification to be sent.
---@type fun(params: lsp.Notification.textDocument-didClose.params)
response["textDocument/didClose"] = nil

---The document save notification is sent from the client to the server when
---the document got saved in the client.
---@type fun(params: lsp.Notification.textDocument-didSave.params)
response["textDocument/didSave"] = nil

---A document will save notification is sent from the client to the server before
---the document is actually saved.
---@type fun(params: lsp.Notification.textDocument-willSave.params)
response["textDocument/willSave"] = nil

---The watched files notification is sent from the client to the server when
---the client detects changes to file watched by the language client.
---@type fun(params: lsp.Notification.workspace-didChangeWatchedFiles.params)
response["workspace/didChangeWatchedFiles"] = nil

---@type fun(params: lsp.Notification._-setTrace.params)
response["$/setTrace"] = nil

---@type fun(params: lsp.Notification._-cancelRequest.params)
response["$/cancelRequest"] = nil

---@type fun(params: lsp.Notification._-progress.params)
response["$/progress"] = nil

---@class lsp*.Request
local request = {}

---The `workspace/workspaceFolders` is sent from the server to the client to fetch the open workspace folders.
---@param params lsp.Request.workspace-workspaceFolders.params
---@return lsp.Response.workspace-workspaceFolders.result? result
---@return lsp.Response.workspace-workspaceFolders.error? error
request["workspace/workspaceFolders"] = function(params) end

---The 'workspace/configuration' request is sent from the server to the client to fetch a certain
---configuration setting.
---This pull model replaces the old push model were the client signaled configuration change via an
---event. If the server still needs to react to configuration changes (since the server caches the
---result of `workspace/configuration` requests) the server should register for an empty configuration
---change event and empty the cache if such an event is received.
---@param params lsp.Request.workspace-configuration.params
---@return lsp.Response.workspace-configuration.result? result
---@return lsp.Response.workspace-configuration.error? error
request["workspace/configuration"] = function(params) end

---@since 3.18.0
---@proposed
---@param params lsp.Request.workspace-foldingRange-refresh.params
---@return lsp.Response.workspace-foldingRange-refresh.result? result
---@return lsp.Response.workspace-foldingRange-refresh.error? error
request["workspace/foldingRange/refresh"] = function(params) end

---The `window/workDoneProgress/create` request is sent from the server to the client to initiate progress
---reporting from the server.
---@param params lsp.Request.window-workDoneProgress-create.params
---@return lsp.Response.window-workDoneProgress-create.result? result
---@return lsp.Response.window-workDoneProgress-create.error? error
request["window/workDoneProgress/create"] = function(params) end

---@since 3.16.0
---@param params lsp.Request.workspace-semanticTokens-refresh.params
---@return lsp.Response.workspace-semanticTokens-refresh.result? result
---@return lsp.Response.workspace-semanticTokens-refresh.error? error
request["workspace/semanticTokens/refresh"] = function(params) end

---A request to show a document. This request might open an
---external program depending on the value of the URI to open.
---For example a request to open `https://code.visualstudio.com/`
---will very likely open the URI in a WEB browser.
---@since 3.16.0
---@param params lsp.Request.window-showDocument.params
---@return lsp.Response.window-showDocument.result? result
---@return lsp.Response.window-showDocument.error? error
request["window/showDocument"] = function(params) end

---@since 3.17.0
---@param params lsp.Request.workspace-inlineValue-refresh.params
---@return lsp.Response.workspace-inlineValue-refresh.result? result
---@return lsp.Response.workspace-inlineValue-refresh.error? error
request["workspace/inlineValue/refresh"] = function(params) end

---@since 3.17.0
---@param params lsp.Request.workspace-inlayHint-refresh.params
---@return lsp.Response.workspace-inlayHint-refresh.result? result
---@return lsp.Response.workspace-inlayHint-refresh.error? error
request["workspace/inlayHint/refresh"] = function(params) end

---The diagnostic refresh request definition.
---@since 3.17.0
---@param params lsp.Request.workspace-diagnostic-refresh.params
---@return lsp.Response.workspace-diagnostic-refresh.result? result
---@return lsp.Response.workspace-diagnostic-refresh.error? error
request["workspace/diagnostic/refresh"] = function(params) end

---The `client/registerCapability` request is sent from the server to the client to register a new capability
---handler on the client side.
---@param params lsp.Request.client-registerCapability.params
---@return lsp.Response.client-registerCapability.result? result
---@return lsp.Response.client-registerCapability.error? error
request["client/registerCapability"] = function(params) end

---The `client/unregisterCapability` request is sent from the server to the client to unregister a previously registered capability
---handler on the client side.
---@param params lsp.Request.client-unregisterCapability.params
---@return lsp.Response.client-unregisterCapability.result? result
---@return lsp.Response.client-unregisterCapability.error? error
request["client/unregisterCapability"] = function(params) end

---The show message request is sent from the server to the client to show a message
---and a set of options actions to the user.
---@param params lsp.Request.window-showMessageRequest.params
---@return lsp.Response.window-showMessageRequest.result? result
---@return lsp.Response.window-showMessageRequest.error? error
request["window/showMessageRequest"] = function(params) end

---A request to refresh all code actions
---@since 3.16.0
---@param params lsp.Request.workspace-codeLens-refresh.params
---@return lsp.Response.workspace-codeLens-refresh.result? result
---@return lsp.Response.workspace-codeLens-refresh.error? error
request["workspace/codeLens/refresh"] = function(params) end

---A request sent from the server to the client to modified certain resources.
---@param params lsp.Request.workspace-applyEdit.params
---@return lsp.Response.workspace-applyEdit.result? result
---@return lsp.Response.workspace-applyEdit.error? error
request["workspace/applyEdit"] = function(params) end

---@class lsp*.Notify
local notify = {}

---The show message notification is sent from a server to a client to ask
---the client to display a particular message in the user interface.
---@param params lsp.Notification.window-showMessage.params
notify["window/showMessage"] = function(params) end

---The log message notification is sent from the server to the client to ask
---the client to log a particular message.
---@param params lsp.Notification.window-logMessage.params
notify["window/logMessage"] = function(params) end

---The telemetry event notification is sent from the server to the client to ask
---the client to log telemetry data.
---@param params lsp.Notification.telemetry-event.params
notify["telemetry/event"] = function(params) end

---Diagnostics notification are sent from the server to the client to signal
---results of validation runs.
---@param params lsp.Notification.textDocument-publishDiagnostics.params
notify["textDocument/publishDiagnostics"] = function(params) end

---@param params lsp.Notification._-logTrace.params
notify["$/logTrace"] = function(params) end

---@param params lsp.Notification._-cancelRequest.params
notify["$/cancelRequest"] = function(params) end

---@param params lsp.Notification._-progress.params
notify["$/progress"] = function(params) end
