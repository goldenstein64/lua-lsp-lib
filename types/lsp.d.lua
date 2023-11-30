---3.17.0

---@alias lsp.DocumentUri string

---@alias lsp.URI string

---A general message as defined by JSON-RPC. The language server protocol always
---uses "2.0" as the `jsonrpc` version.
---@class lsp.Message
---@field jsonrpc "2.0"

---A request message to describe a request between the client and the server.
---Every processed request must send a response back to the sender of the
---request.
---@class lsp.Request : lsp.Message
---The request id.
---@field id integer | string
---The method to be invoked.
---@field method string
---The method's params.
---@field params table?

---A Response Message sent as a result of a request. If a request doesn't
---provide a result value the receiver of a request still needs to return a
---response message to conform to the JSON-RPC specification. The result
---property of the ResponseMessage should be set to `null` in this case to
---signal a successful request.
---@class lsp.Response : lsp.Message
---The request id.
---@field id integer | string | cjson.null
---The result of a request. This member is REQUIRED on success. This member MUST
---NOT exist if there was an error invoking the method.
---@field result? unknown
---The error object in case a request fails.
---@field error? lsp.ResponseError

---A notification message. A processed notification message must not send a
---response back. They work like events.
---@class lsp.Notification : lsp.Message
---The method to be invoked.
---@field method string
---The notification's params.
---@field params table?

---The error object in case a request fails.
---@class lsp.ResponseError
---A number indicating the error type that occurred.
---@field code integer
---A string providing a short description of the error.
---@field message string
---A primitive or structured value that contains additional information about
---the error. Can be omitted.
---@field data? string | number | boolean | table | cjson.null

---@class lsp.ImplementationParams : lsp.TextDocumentPositionParams, lsp.WorkDoneProgressParams, lsp.PartialResultParams

---Represents a location inside a resource, such as a line
---inside a text file.
---@class lsp.Location
---@field uri lsp.DocumentUri
---@field range lsp.Range

---@class lsp.ImplementationRegistrationOptions : lsp.TextDocumentRegistrationOptions, lsp.ImplementationOptions, lsp.StaticRegistrationOptions

---@class lsp.TypeDefinitionParams : lsp.TextDocumentPositionParams, lsp.WorkDoneProgressParams, lsp.PartialResultParams

---@class lsp.TypeDefinitionRegistrationOptions : lsp.TextDocumentRegistrationOptions, lsp.TypeDefinitionOptions, lsp.StaticRegistrationOptions

---A workspace folder inside a client.
---@class lsp.WorkspaceFolder
---The associated URI for this workspace folder.
---@field uri lsp.URI
---The name of the workspace folder. Used to refer to this
---workspace folder in the user interface.
---@field name string

---The parameters of a `workspace/didChangeWorkspaceFolders` notification.
---@class lsp.DidChangeWorkspaceFoldersParams
---The actual workspace folder change event.
---@field event lsp.WorkspaceFoldersChangeEvent

---The parameters of a configuration request.
---@class lsp.ConfigurationParams
---@field items (lsp.ConfigurationItem)[]

---Parameters for a {@link DocumentColorRequest}.
---@class lsp.DocumentColorParams : lsp.WorkDoneProgressParams, lsp.PartialResultParams
---The text document.
---@field textDocument lsp.TextDocumentIdentifier

---Represents a color range from a document.
---@class lsp.ColorInformation
---The range in the document where this color appears.
---@field range lsp.Range
---The actual color value for this color range.
---@field color lsp.Color

---@class lsp.DocumentColorRegistrationOptions : lsp.TextDocumentRegistrationOptions, lsp.DocumentColorOptions, lsp.StaticRegistrationOptions

---Parameters for a {@link ColorPresentationRequest}.
---@class lsp.ColorPresentationParams : lsp.WorkDoneProgressParams, lsp.PartialResultParams
---The text document.
---@field textDocument lsp.TextDocumentIdentifier
---The color to request presentations for.
---@field color lsp.Color
---The range where the color would be inserted. Serves as a context.
---@field range lsp.Range

---@class lsp.ColorPresentation
---The label of this color presentation. It will be shown on the color
---picker header. By default this is also the text that is inserted when selecting
---this color presentation.
---@field label string
---An {@link TextEdit edit} which is applied to a document when selecting
---this presentation for the color.  When `falsy` the {@link ColorPresentation.label label}
---is used.
---@field textEdit? lsp.TextEdit
---An optional array of additional {@link TextEdit text edits} that are applied when
---selecting this color presentation. Edits must not overlap with the main {@link ColorPresentation.textEdit edit} nor with themselves.
---@field additionalTextEdits? (lsp.TextEdit)[]

---@class lsp.WorkDoneProgressOptions
---@field workDoneProgress? boolean

---General text document registration options.
---@class lsp.TextDocumentRegistrationOptions
---A document selector to identify the scope of the registration. If set to null
---the document selector provided on the client side will be used.
---@field documentSelector lsp.DocumentSelector | cjson.null

---Parameters for a {@link FoldingRangeRequest}.
---@class lsp.FoldingRangeParams : lsp.WorkDoneProgressParams, lsp.PartialResultParams
---The text document.
---@field textDocument lsp.TextDocumentIdentifier

---Represents a folding range. To be valid, start and end line must be bigger than zero and smaller
---than the number of lines in the document. Clients are free to ignore invalid ranges.
---@class lsp.FoldingRange
---The zero-based start line of the range to fold. The folded area starts after the line's last character.
---To be valid, the end must be zero or larger and smaller than the number of lines in the document.
---@field startLine integer
---The zero-based character offset from where the folded range starts. If not defined, defaults to the length of the start line.
---@field startCharacter? integer
---The zero-based end line of the range to fold. The folded area ends with the line's last character.
---To be valid, the end must be zero or larger and smaller than the number of lines in the document.
---@field endLine integer
---The zero-based character offset before the folded range ends. If not defined, defaults to the length of the end line.
---@field endCharacter? integer
---Describes the kind of the folding range such as `comment' or 'region'. The kind
---is used to categorize folding ranges and used by commands like 'Fold all comments'.
---See {@link FoldingRangeKind} for an enumeration of standardized kinds.
---@field kind? lsp.FoldingRangeKind
---The text that the client should show when the specified range is
---collapsed. If not defined or not supported by the client, a default
---will be chosen by the client.
---@since 3.17.0
---@field collapsedText? string

---@class lsp.FoldingRangeRegistrationOptions : lsp.TextDocumentRegistrationOptions, lsp.FoldingRangeOptions, lsp.StaticRegistrationOptions

---@class lsp.DeclarationParams : lsp.TextDocumentPositionParams, lsp.WorkDoneProgressParams, lsp.PartialResultParams

---@class lsp.DeclarationRegistrationOptions : lsp.DeclarationOptions, lsp.TextDocumentRegistrationOptions, lsp.StaticRegistrationOptions

---A parameter literal used in selection range requests.
---@class lsp.SelectionRangeParams : lsp.WorkDoneProgressParams, lsp.PartialResultParams
---The text document.
---@field textDocument lsp.TextDocumentIdentifier
---The positions inside the text document.
---@field positions (lsp.Position)[]

---A selection range represents a part of a selection hierarchy. A selection range
---may have a parent selection range that contains it.
---@class lsp.SelectionRange
---The {@link Range range} of this selection range.
---@field range lsp.Range
---The parent selection range containing this range. Therefore `parent.range` must contain `this.range`.
---@field parent? lsp.SelectionRange

---@class lsp.SelectionRangeRegistrationOptions : lsp.SelectionRangeOptions, lsp.TextDocumentRegistrationOptions, lsp.StaticRegistrationOptions

---@class lsp.WorkDoneProgressCreateParams
---The token to be used to report progress.
---@field token lsp.ProgressToken

---@class lsp.WorkDoneProgressCancelParams
---The token to be used to report progress.
---@field token lsp.ProgressToken

---The parameter of a `textDocument/prepareCallHierarchy` request.
---@since 3.16.0
---@class lsp.CallHierarchyPrepareParams : lsp.TextDocumentPositionParams, lsp.WorkDoneProgressParams

---Represents programming constructs like functions or constructors in the context
---of call hierarchy.
---@since 3.16.0
---@class lsp.CallHierarchyItem
---The name of this item.
---@field name string
---The kind of this item.
---@field kind lsp.SymbolKind
---Tags for this item.
---@field tags? (lsp.SymbolTag)[]
---More detail for this item, e.g. the signature of a function.
---@field detail? string
---The resource identifier of this item.
---@field uri lsp.DocumentUri
---The range enclosing this symbol not including leading/trailing whitespace but everything else, e.g. comments and code.
---@field range lsp.Range
---The range that should be selected and revealed when this symbol is being picked, e.g. the name of a function.
---Must be contained by the {@link CallHierarchyItem.range `range`}.
---@field selectionRange lsp.Range
---A data entry field that is preserved between a call hierarchy prepare and
---incoming calls or outgoing calls requests.
---@field data? lsp.LSPAny

---Call hierarchy options used during static or dynamic registration.
---@since 3.16.0
---@class lsp.CallHierarchyRegistrationOptions : lsp.TextDocumentRegistrationOptions, lsp.CallHierarchyOptions, lsp.StaticRegistrationOptions

---The parameter of a `callHierarchy/incomingCalls` request.
---@since 3.16.0
---@class lsp.CallHierarchyIncomingCallsParams : lsp.WorkDoneProgressParams, lsp.PartialResultParams
---@field item lsp.CallHierarchyItem

---Represents an incoming call, e.g. a caller of a method or constructor.
---@since 3.16.0
---@class lsp.CallHierarchyIncomingCall
---The item that makes the call.
---@field from lsp.CallHierarchyItem
---The ranges at which the calls appear. This is relative to the caller
---denoted by {@link CallHierarchyIncomingCall.from `this.from`}.
---@field fromRanges (lsp.Range)[]

---The parameter of a `callHierarchy/outgoingCalls` request.
---@since 3.16.0
---@class lsp.CallHierarchyOutgoingCallsParams : lsp.WorkDoneProgressParams, lsp.PartialResultParams
---@field item lsp.CallHierarchyItem

---Represents an outgoing call, e.g. calling a getter from a method or a method from a constructor etc.
---@since 3.16.0
---@class lsp.CallHierarchyOutgoingCall
---The item that is called.
---@field to lsp.CallHierarchyItem
---The range at which this item is called. This is the range relative to the caller, e.g the item
---passed to {@link CallHierarchyItemProvider.provideCallHierarchyOutgoingCalls `provideCallHierarchyOutgoingCalls`}
---and not {@link CallHierarchyOutgoingCall.to `this.to`}.
---@field fromRanges (lsp.Range)[]

---@since 3.16.0
---@class lsp.SemanticTokensParams : lsp.WorkDoneProgressParams, lsp.PartialResultParams
---The text document.
---@field textDocument lsp.TextDocumentIdentifier

---@since 3.16.0
---@class lsp.SemanticTokens
---An optional result id. If provided and clients support delta updating
---the client will include the result id in the next semantic token request.
---A server can then instead of computing all semantic tokens again simply
---send a delta.
---@field resultId? string
---The actual tokens.
---@field data (integer)[]

---@since 3.16.0
---@class lsp.SemanticTokensPartialResult
---@field data (integer)[]

---@since 3.16.0
---@class lsp.SemanticTokensRegistrationOptions : lsp.TextDocumentRegistrationOptions, lsp.SemanticTokensOptions, lsp.StaticRegistrationOptions

---@since 3.16.0
---@class lsp.SemanticTokensDeltaParams : lsp.WorkDoneProgressParams, lsp.PartialResultParams
---The text document.
---@field textDocument lsp.TextDocumentIdentifier
---The result id of a previous response. The result Id can either point to a full response
---or a delta response depending on what was received last.
---@field previousResultId string

---@since 3.16.0
---@class lsp.SemanticTokensDelta
---@field resultId? string
---The semantic token edits to transform a previous result into a new result.
---@field edits (lsp.SemanticTokensEdit)[]

---@since 3.16.0
---@class lsp.SemanticTokensDeltaPartialResult
---@field edits (lsp.SemanticTokensEdit)[]

---@since 3.16.0
---@class lsp.SemanticTokensRangeParams : lsp.WorkDoneProgressParams, lsp.PartialResultParams
---The text document.
---@field textDocument lsp.TextDocumentIdentifier
---The range the semantic tokens are requested for.
---@field range lsp.Range

---Params to show a resource in the UI.
---@since 3.16.0
---@class lsp.ShowDocumentParams
---The uri to show.
---@field uri lsp.URI
---Indicates to show the resource in an external program.
---To show, for example, `https://code.visualstudio.com/`
---in the default WEB browser set `external` to `true`.
---@field external? boolean
---An optional property to indicate whether the editor
---showing the document should take focus or not.
---Clients might ignore this property if an external
---program is started.
---@field takeFocus? boolean
---An optional selection range if the document is a text
---document. Clients might ignore the property if an
---external program is started or the file is not a text
---file.
---@field selection? lsp.Range

---The result of a showDocument request.
---@since 3.16.0
---@class lsp.ShowDocumentResult
---A boolean indicating if the show was successful.
---@field success boolean

---@class lsp.LinkedEditingRangeParams : lsp.TextDocumentPositionParams, lsp.WorkDoneProgressParams

---The result of a linked editing range request.
---@since 3.16.0
---@class lsp.LinkedEditingRanges
---A list of ranges that can be edited together. The ranges must have
---identical length and contain identical text content. The ranges cannot overlap.
---@field ranges (lsp.Range)[]
---An optional word pattern (regular expression) that describes valid contents for
---the given ranges. If no pattern is provided, the client configuration's word
---pattern will be used.
---@field wordPattern? string

---@class lsp.LinkedEditingRangeRegistrationOptions : lsp.TextDocumentRegistrationOptions, lsp.LinkedEditingRangeOptions, lsp.StaticRegistrationOptions

---The parameters sent in notifications/requests for user-initiated creation of
---files.
---@since 3.16.0
---@class lsp.CreateFilesParams
---An array of all files/folders created in this operation.
---@field files (lsp.FileCreate)[]

---A workspace edit represents changes to many resources managed in the workspace. The edit
---should either provide `changes` or `documentChanges`. If documentChanges are present
---they are preferred over `changes` if the client can handle versioned document edits.
---Since version 3.13.0 a workspace edit can contain resource operations as well. If resource
---operations are present clients need to execute the operations in the order in which they
---are provided. So a workspace edit for example can consist of the following two changes:
---(1) a create file a.txt and (2) a text document edit which insert text into file a.txt.
---An invalid sequence (e.g. (1) delete file a.txt and (2) insert text into file a.txt) will
---cause failure of the operation. How the client recovers from the failure is described by
---the client capability: `workspace.workspaceEdit.failureHandling`
---@class lsp.WorkspaceEdit
---Holds changes to existing resources.
---@field changes? { [lsp.DocumentUri]: (lsp.TextEdit)[] }
---Depending on the client capability `workspace.workspaceEdit.resourceOperations` document changes
---are either an array of `TextDocumentEdit`s to express changes to n different text documents
---where each text document edit addresses a specific version of a text document. Or it can contain
---above `TextDocumentEdit`s mixed with create, rename and delete file / folder operations.
---Whether a client supports versioned document edits is expressed via
---`workspace.workspaceEdit.documentChanges` client capability.
---If a client neither supports `documentChanges` nor `workspace.workspaceEdit.resourceOperations` then
---only plain `TextEdit`s using the `changes` property are supported.
---@field documentChanges? (lsp.TextDocumentEdit | lsp.CreateFile | lsp.RenameFile | lsp.DeleteFile)[]
---A map of change annotations that can be referenced in `AnnotatedTextEdit`s or create, rename and
---delete file / folder operations.
---Whether clients honor this property depends on the client capability `workspace.changeAnnotationSupport`.
---@since 3.16.0
---@field changeAnnotations? { [lsp.ChangeAnnotationIdentifier]: lsp.ChangeAnnotation }

---The options to register for file operations.
---@since 3.16.0
---@class lsp.FileOperationRegistrationOptions
---The actual filters.
---@field filters (lsp.FileOperationFilter)[]

---The parameters sent in notifications/requests for user-initiated renames of
---files.
---@since 3.16.0
---@class lsp.RenameFilesParams
---An array of all files/folders renamed in this operation. When a folder is renamed, only
---the folder will be included, and not its children.
---@field files (lsp.FileRename)[]

---The parameters sent in notifications/requests for user-initiated deletes of
---files.
---@since 3.16.0
---@class lsp.DeleteFilesParams
---An array of all files/folders deleted in this operation.
---@field files (lsp.FileDelete)[]

---@class lsp.MonikerParams : lsp.TextDocumentPositionParams, lsp.WorkDoneProgressParams, lsp.PartialResultParams

---Moniker definition to match LSIF 0.5 moniker definition.
---@since 3.16.0
---@class lsp.Moniker
---The scheme of the moniker. For example tsc or .Net
---@field scheme string
---The identifier of the moniker. The value is opaque in LSIF however
---schema owners are allowed to define the structure if they want.
---@field identifier string
---The scope in which the moniker is unique
---@field unique lsp.UniquenessLevel
---The moniker kind if known.
---@field kind? lsp.MonikerKind

---@class lsp.MonikerRegistrationOptions : lsp.TextDocumentRegistrationOptions, lsp.MonikerOptions

---The parameter of a `textDocument/prepareTypeHierarchy` request.
---@since 3.17.0
---@class lsp.TypeHierarchyPrepareParams : lsp.TextDocumentPositionParams, lsp.WorkDoneProgressParams

---@since 3.17.0
---@class lsp.TypeHierarchyItem
---The name of this item.
---@field name string
---The kind of this item.
---@field kind lsp.SymbolKind
---Tags for this item.
---@field tags? (lsp.SymbolTag)[]
---More detail for this item, e.g. the signature of a function.
---@field detail? string
---The resource identifier of this item.
---@field uri lsp.DocumentUri
---The range enclosing this symbol not including leading/trailing whitespace
---but everything else, e.g. comments and code.
---@field range lsp.Range
---The range that should be selected and revealed when this symbol is being
---picked, e.g. the name of a function. Must be contained by the
---{@link TypeHierarchyItem.range `range`}.
---@field selectionRange lsp.Range
---A data entry field that is preserved between a type hierarchy prepare and
---supertypes or subtypes requests. It could also be used to identify the
---type hierarchy in the server, helping improve the performance on
---resolving supertypes and subtypes.
---@field data? lsp.LSPAny

---Type hierarchy options used during static or dynamic registration.
---@since 3.17.0
---@class lsp.TypeHierarchyRegistrationOptions : lsp.TextDocumentRegistrationOptions, lsp.TypeHierarchyOptions, lsp.StaticRegistrationOptions

---The parameter of a `typeHierarchy/supertypes` request.
---@since 3.17.0
---@class lsp.TypeHierarchySupertypesParams : lsp.WorkDoneProgressParams, lsp.PartialResultParams
---@field item lsp.TypeHierarchyItem

---The parameter of a `typeHierarchy/subtypes` request.
---@since 3.17.0
---@class lsp.TypeHierarchySubtypesParams : lsp.WorkDoneProgressParams, lsp.PartialResultParams
---@field item lsp.TypeHierarchyItem

---A parameter literal used in inline value requests.
---@since 3.17.0
---@class lsp.InlineValueParams : lsp.WorkDoneProgressParams
---The text document.
---@field textDocument lsp.TextDocumentIdentifier
---The document range for which inline values should be computed.
---@field range lsp.Range
---Additional information about the context in which inline values were
---requested.
---@field context lsp.InlineValueContext

---Inline value options used during static or dynamic registration.
---@since 3.17.0
---@class lsp.InlineValueRegistrationOptions : lsp.InlineValueOptions, lsp.TextDocumentRegistrationOptions, lsp.StaticRegistrationOptions

---A parameter literal used in inlay hint requests.
---@since 3.17.0
---@class lsp.InlayHintParams : lsp.WorkDoneProgressParams
---The text document.
---@field textDocument lsp.TextDocumentIdentifier
---The document range for which inlay hints should be computed.
---@field range lsp.Range

---Inlay hint information.
---@since 3.17.0
---@class lsp.InlayHint
---The position of this hint.
---@field position lsp.Position
---The label of this hint. A human readable string or an array of
---InlayHintLabelPart label parts.
---*Note* that neither the string nor the label part can be empty.
---@field label string | (lsp.InlayHintLabelPart)[]
---The kind of this hint. Can be omitted in which case the client
---should fall back to a reasonable default.
---@field kind? lsp.InlayHintKind
---Optional text edits that are performed when accepting this inlay hint.
---*Note* that edits are expected to change the document so that the inlay
---hint (or its nearest variant) is now part of the document and the inlay
---hint itself is now obsolete.
---@field textEdits? (lsp.TextEdit)[]
---The tooltip text when you hover over this item.
---@field tooltip? string | lsp.MarkupContent
---Render padding before the hint.
---Note: Padding should use the editor's background color, not the
---background color of the hint itself. That means padding can be used
---to visually align/separate an inlay hint.
---@field paddingLeft? boolean
---Render padding after the hint.
---Note: Padding should use the editor's background color, not the
---background color of the hint itself. That means padding can be used
---to visually align/separate an inlay hint.
---@field paddingRight? boolean
---A data entry field that is preserved on an inlay hint between
---a `textDocument/inlayHint` and a `inlayHint/resolve` request.
---@field data? lsp.LSPAny

---Inlay hint options used during static or dynamic registration.
---@since 3.17.0
---@class lsp.InlayHintRegistrationOptions : lsp.InlayHintOptions, lsp.TextDocumentRegistrationOptions, lsp.StaticRegistrationOptions

---Parameters of the document diagnostic request.
---@since 3.17.0
---@class lsp.DocumentDiagnosticParams : lsp.WorkDoneProgressParams, lsp.PartialResultParams
---The text document.
---@field textDocument lsp.TextDocumentIdentifier
---The additional identifier  provided during registration.
---@field identifier? string
---The result id of a previous response if provided.
---@field previousResultId? string

---A partial result for a document diagnostic report.
---@since 3.17.0
---@class lsp.DocumentDiagnosticReportPartialResult
---@field relatedDocuments { [lsp.DocumentUri]: lsp.FullDocumentDiagnosticReport | lsp.UnchangedDocumentDiagnosticReport }

---Cancellation data returned from a diagnostic request.
---@since 3.17.0
---@class lsp.DiagnosticServerCancellationData
---@field retriggerRequest boolean

---Diagnostic registration options.
---@since 3.17.0
---@class lsp.DiagnosticRegistrationOptions : lsp.TextDocumentRegistrationOptions, lsp.DiagnosticOptions, lsp.StaticRegistrationOptions

---Parameters of the workspace diagnostic request.
---@since 3.17.0
---@class lsp.WorkspaceDiagnosticParams : lsp.WorkDoneProgressParams, lsp.PartialResultParams
---The additional identifier provided during registration.
---@field identifier? string
---The currently known diagnostic reports with their
---previous result ids.
---@field previousResultIds (lsp.PreviousResultId)[]

---A workspace diagnostic report.
---@since 3.17.0
---@class lsp.WorkspaceDiagnosticReport
---@field items (lsp.WorkspaceDocumentDiagnosticReport)[]

---A partial result for a workspace diagnostic report.
---@since 3.17.0
---@class lsp.WorkspaceDiagnosticReportPartialResult
---@field items (lsp.WorkspaceDocumentDiagnosticReport)[]

---The params sent in an open notebook document notification.
---@since 3.17.0
---@class lsp.DidOpenNotebookDocumentParams
---The notebook document that got opened.
---@field notebookDocument lsp.NotebookDocument
---The text documents that represent the content
---of a notebook cell.
---@field cellTextDocuments (lsp.TextDocumentItem)[]

---The params sent in a change notebook document notification.
---@since 3.17.0
---@class lsp.DidChangeNotebookDocumentParams
---The notebook document that did change. The version number points
---to the version after all provided changes have been applied. If
---only the text document content of a cell changes the notebook version
---doesn't necessarily have to change.
---@field notebookDocument lsp.VersionedNotebookDocumentIdentifier
---The actual changes to the notebook document.
---The changes describe single state changes to the notebook document.
---So if there are two changes c1 (at array index 0) and c2 (at array
---index 1) for a notebook in state S then c1 moves the notebook from
---S to S' and c2 from S' to S''. So c1 is computed on the state S and
---c2 is computed on the state S'.
---To mirror the content of a notebook using change events use the following approach:
---- start with the same initial content
---- apply the 'notebookDocument/didChange' notifications in the order you receive them.
---- apply the `NotebookChangeEvent`s in a single notification in the order
---  you receive them.
---@field change lsp.NotebookDocumentChangeEvent

---The params sent in a save notebook document notification.
---@since 3.17.0
---@class lsp.DidSaveNotebookDocumentParams
---The notebook document that got saved.
---@field notebookDocument lsp.NotebookDocumentIdentifier

---The params sent in a close notebook document notification.
---@since 3.17.0
---@class lsp.DidCloseNotebookDocumentParams
---The notebook document that got closed.
---@field notebookDocument lsp.NotebookDocumentIdentifier
---The text documents that represent the content
---of a notebook cell that got closed.
---@field cellTextDocuments (lsp.TextDocumentIdentifier)[]

---A parameter literal used in inline completion requests.
---@since 3.18.0
---@proposed
---@class lsp.InlineCompletionParams : lsp.TextDocumentPositionParams, lsp.WorkDoneProgressParams
---Additional information about the context in which inline completions were
---requested.
---@field context lsp.InlineCompletionContext

---Represents a collection of {@link InlineCompletionItem inline completion items} to be presented in the editor.
---@since 3.18.0
---@proposed
---@class lsp.InlineCompletionList
---The inline completion items
---@field items (lsp.InlineCompletionItem)[]

---An inline completion item represents a text snippet that is proposed inline to complete text that is being typed.
---@since 3.18.0
---@proposed
---@class lsp.InlineCompletionItem
---The text to replace the range with. Must be set.
---@field insertText string | lsp.StringValue
---A text that is used to decide if this inline completion should be shown. When `falsy` the {@link InlineCompletionItem.insertText} is used.
---@field filterText? string
---The range to replace. Must begin and end on the same line.
---@field range? lsp.Range
---An optional {@link Command} that is executed *after* inserting this completion.
---@field command? lsp.Command

---Inline completion options used during static or dynamic registration.
---@since 3.18.0
---@proposed
---@class lsp.InlineCompletionRegistrationOptions : lsp.InlineCompletionOptions, lsp.TextDocumentRegistrationOptions, lsp.StaticRegistrationOptions

---@class lsp.RegistrationParams
---@field registrations (lsp.Registration)[]

---@class lsp.UnregistrationParams
---@field unregisterations (lsp.Unregistration)[]

---@class lsp.InitializeParams : lsp._InitializeParams, lsp.WorkspaceFoldersInitializeParams

---The result returned from an initialize request.
---@class lsp.InitializeResult
---The capabilities the language server provides.
---@field capabilities lsp.ServerCapabilities
---Information about the server.
---@since 3.15.0
---@field serverInfo? lsp.InitializeResult.serverInfo

---The data type of the ResponseError if the
---initialize request fails.
---@class lsp.InitializeError
---Indicates whether the client execute the following retry logic:
---(1) show the message provided by the ResponseError to the user
---(2) user selects retry or cancel
---(3) if user selected retry the initialize method is sent again.
---@field retry boolean

---@class lsp.InitializedParams

---The parameters of a change configuration notification.
---@class lsp.DidChangeConfigurationParams
---The actual changed settings
---@field settings lsp.LSPAny

---@class lsp.DidChangeConfigurationRegistrationOptions
---@field section? string | (string)[]

---The parameters of a notification message.
---@class lsp.ShowMessageParams
---The message type. See {@link MessageType}
---@field type lsp.MessageType
---The actual message.
---@field message string

---@class lsp.ShowMessageRequestParams
---The message type. See {@link MessageType}
---@field type lsp.MessageType
---The actual message.
---@field message string
---The message action items to present.
---@field actions? (lsp.MessageActionItem)[]

---@class lsp.MessageActionItem
---A short title like 'Retry', 'Open Log' etc.
---@field title string

---The log message parameters.
---@class lsp.LogMessageParams
---The message type. See {@link MessageType}
---@field type lsp.MessageType
---The actual message.
---@field message string

---The parameters sent in an open text document notification
---@class lsp.DidOpenTextDocumentParams
---The document that was opened.
---@field textDocument lsp.TextDocumentItem

---The change text document notification's parameters.
---@class lsp.DidChangeTextDocumentParams
---The document that did change. The version number points
---to the version after all provided content changes have
---been applied.
---@field textDocument lsp.VersionedTextDocumentIdentifier
---The actual content changes. The content changes describe single state changes
---to the document. So if there are two content changes c1 (at array index 0) and
---c2 (at array index 1) for a document in state S then c1 moves the document from
---S to S' and c2 from S' to S''. So c1 is computed on the state S and c2 is computed
---on the state S'.
---To mirror the content of a document using change events use the following approach:
---- start with the same initial content
---- apply the 'textDocument/didChange' notifications in the order you receive them.
---- apply the `TextDocumentContentChangeEvent`s in a single notification in the order
---  you receive them.
---@field contentChanges (lsp.TextDocumentContentChangeEvent)[]

---Describe options to be used when registered for text document change events.
---@class lsp.TextDocumentChangeRegistrationOptions : lsp.TextDocumentRegistrationOptions
---How documents are synced to the server.
---@field syncKind lsp.TextDocumentSyncKind

---The parameters sent in a close text document notification
---@class lsp.DidCloseTextDocumentParams
---The document that was closed.
---@field textDocument lsp.TextDocumentIdentifier

---The parameters sent in a save text document notification
---@class lsp.DidSaveTextDocumentParams
---The document that was saved.
---@field textDocument lsp.TextDocumentIdentifier
---Optional the content when saved. Depends on the includeText value
---when the save notification was requested.
---@field text? string

---Save registration options.
---@class lsp.TextDocumentSaveRegistrationOptions : lsp.TextDocumentRegistrationOptions, lsp.SaveOptions

---The parameters sent in a will save text document notification.
---@class lsp.WillSaveTextDocumentParams
---The document that will be saved.
---@field textDocument lsp.TextDocumentIdentifier
---The 'TextDocumentSaveReason'.
---@field reason lsp.TextDocumentSaveReason

---A text edit applicable to a text document.
---@class lsp.TextEdit
---The range of the text document to be manipulated. To insert
---text into a document create a range where start === end.
---@field range lsp.Range
---The string to be inserted. For delete operations use an
---empty string.
---@field newText string

---The watched files change notification's parameters.
---@class lsp.DidChangeWatchedFilesParams
---The actual file events.
---@field changes (lsp.FileEvent)[]

---Describe options to be used when registered for text document change events.
---@class lsp.DidChangeWatchedFilesRegistrationOptions
---The watchers to register.
---@field watchers (lsp.FileSystemWatcher)[]

---The publish diagnostic notification's parameters.
---@class lsp.PublishDiagnosticsParams
---The URI for which diagnostic information is reported.
---@field uri lsp.DocumentUri
---Optional the version number of the document the diagnostics are published for.
---@since 3.15.0
---@field version? integer
---An array of diagnostic information items.
---@field diagnostics (lsp.Diagnostic)[]

---Completion parameters
---@class lsp.CompletionParams : lsp.TextDocumentPositionParams, lsp.WorkDoneProgressParams, lsp.PartialResultParams
---The completion context. This is only available it the client specifies
---to send this using the client capability `textDocument.completion.contextSupport === true`
---@field context? lsp.CompletionContext

---A completion item represents a text snippet that is
---proposed to complete text that is being typed.
---@class lsp.CompletionItem
---The label of this completion item.
---The label property is also by default the text that
---is inserted when selecting this completion.
---If label details are provided the label itself should
---be an unqualified name of the completion item.
---@field label string
---Additional details for the label
---@since 3.17.0
---@field labelDetails? lsp.CompletionItemLabelDetails
---The kind of this completion item. Based of the kind
---an icon is chosen by the editor.
---@field kind? lsp.CompletionItemKind
---Tags for this completion item.
---@since 3.15.0
---@field tags? (lsp.CompletionItemTag)[]
---A human-readable string with additional information
---about this item, like type or symbol information.
---@field detail? string
---A human-readable string that represents a doc-comment.
---@field documentation? string | lsp.MarkupContent
---Indicates if this item is deprecated.
---@deprecated Use `tags` instead.
---@field deprecated? boolean
---Select this item when showing.
---*Note* that only one completion item can be selected and that the
---tool / client decides which item that is. The rule is that the *first*
---item of those that match best is selected.
---@field preselect? boolean
---A string that should be used when comparing this item
---with other items. When `falsy` the {@link CompletionItem.label label}
---is used.
---@field sortText? string
---A string that should be used when filtering a set of
---completion items. When `falsy` the {@link CompletionItem.label label}
---is used.
---@field filterText? string
---A string that should be inserted into a document when selecting
---this completion. When `falsy` the {@link CompletionItem.label label}
---is used.
---The `insertText` is subject to interpretation by the client side.
---Some tools might not take the string literally. For example
---VS Code when code complete is requested in this example
---`con<cursor position>` and a completion item with an `insertText` of
---`console` is provided it will only insert `sole`. Therefore it is
---recommended to use `textEdit` instead since it avoids additional client
---side interpretation.
---@field insertText? string
---The format of the insert text. The format applies to both the
---`insertText` property and the `newText` property of a provided
---`textEdit`. If omitted defaults to `InsertTextFormat.PlainText`.
---Please note that the insertTextFormat doesn't apply to
---`additionalTextEdits`.
---@field insertTextFormat? lsp.InsertTextFormat
---How whitespace and indentation is handled during completion
---item insertion. If not provided the clients default value depends on
---the `textDocument.completion.insertTextMode` client capability.
---@since 3.16.0
---@field insertTextMode? lsp.InsertTextMode
---An {@link TextEdit edit} which is applied to a document when selecting
---this completion. When an edit is provided the value of
---{@link CompletionItem.insertText insertText} is ignored.
---Most editors support two different operations when accepting a completion
---item. One is to insert a completion text and the other is to replace an
---existing text with a completion text. Since this can usually not be
---predetermined by a server it can report both ranges. Clients need to
---signal support for `InsertReplaceEdits` via the
---`textDocument.completion.insertReplaceSupport` client capability
---property.
---*Note 1:* The text edit's range as well as both ranges from an insert
---replace edit must be a [single line] and they must contain the position
---at which completion has been requested.
---*Note 2:* If an `InsertReplaceEdit` is returned the edit's insert range
---must be a prefix of the edit's replace range, that means it must be
---contained and starting at the same position.
---@since 3.16.0 additional type `InsertReplaceEdit`
---@field textEdit? lsp.TextEdit | lsp.InsertReplaceEdit
---The edit text used if the completion item is part of a CompletionList and
---CompletionList defines an item default for the text edit range.
---Clients will only honor this property if they opt into completion list
---item defaults using the capability `completionList.itemDefaults`.
---If not provided and a list's default range is provided the label
---property is used as a text.
---@since 3.17.0
---@field textEditText? string
---An optional array of additional {@link TextEdit text edits} that are applied when
---selecting this completion. Edits must not overlap (including the same insert position)
---with the main {@link CompletionItem.textEdit edit} nor with themselves.
---Additional text edits should be used to change text unrelated to the current cursor position
---(for example adding an import statement at the top of the file if the completion item will
---insert an unqualified type).
---@field additionalTextEdits? (lsp.TextEdit)[]
---An optional set of characters that when pressed while this completion is active will accept it first and
---then type that character. *Note* that all commit characters should have `length=1` and that superfluous
---characters will be ignored.
---@field commitCharacters? (string)[]
---An optional {@link Command command} that is executed *after* inserting this completion. *Note* that
---additional modifications to the current document should be described with the
---{@link CompletionItem.additionalTextEdits additionalTextEdits}-property.
---@field command? lsp.Command
---A data entry field that is preserved on a completion item between a
---{@link CompletionRequest} and a {@link CompletionResolveRequest}.
---@field data? lsp.LSPAny

---Represents a collection of {@link CompletionItem completion items} to be presented
---in the editor.
---@class lsp.CompletionList
---This list it not complete. Further typing results in recomputing this list.
---Recomputed lists have all their items replaced (not appended) in the
---incomplete completion sessions.
---@field isIncomplete boolean
---In many cases the items of an actual completion result share the same
---value for properties like `commitCharacters` or the range of a text
---edit. A completion list can therefore define item defaults which will
---be used if a completion item itself doesn't specify the value.
---If a completion list specifies a default value and a completion item
---also specifies a corresponding value the one from the item is used.
---Servers are only allowed to return default values if the client
---signals support for this via the `completionList.itemDefaults`
---capability.
---@since 3.17.0
---@field itemDefaults? lsp.CompletionList.itemDefaults
---The completion items.
---@field items (lsp.CompletionItem)[]

---Registration options for a {@link CompletionRequest}.
---@class lsp.CompletionRegistrationOptions : lsp.TextDocumentRegistrationOptions, lsp.CompletionOptions

---Parameters for a {@link HoverRequest}.
---@class lsp.HoverParams : lsp.TextDocumentPositionParams, lsp.WorkDoneProgressParams

---The result of a hover request.
---@class lsp.Hover
---The hover's content
---@field contents lsp.MarkupContent | lsp.MarkedString | (lsp.MarkedString)[]
---An optional range inside the text document that is used to
---visualize the hover, e.g. by changing the background color.
---@field range? lsp.Range

---Registration options for a {@link HoverRequest}.
---@class lsp.HoverRegistrationOptions : lsp.TextDocumentRegistrationOptions, lsp.HoverOptions

---Parameters for a {@link SignatureHelpRequest}.
---@class lsp.SignatureHelpParams : lsp.TextDocumentPositionParams, lsp.WorkDoneProgressParams
---The signature help context. This is only available if the client specifies
---to send this using the client capability `textDocument.signatureHelp.contextSupport === true`
---@since 3.15.0
---@field context? lsp.SignatureHelpContext

---Signature help represents the signature of something
---callable. There can be multiple signature but only one
---active and only one active parameter.
---@class lsp.SignatureHelp
---One or more signatures.
---@field signatures (lsp.SignatureInformation)[]
---The active signature. If omitted or the value lies outside the
---range of `signatures` the value defaults to zero or is ignored if
---the `SignatureHelp` has no signatures.
---Whenever possible implementors should make an active decision about
---the active signature and shouldn't rely on a default value.
---In future version of the protocol this property might become
---mandatory to better express this.
---@field activeSignature? integer
---The active parameter of the active signature. If omitted or the value
---lies outside the range of `signatures[activeSignature].parameters`
---defaults to 0 if the active signature has parameters. If
---the active signature has no parameters it is ignored.
---In future version of the protocol this property might become
---mandatory to better express the active parameter if the
---active signature does have any.
---@field activeParameter? integer

---Registration options for a {@link SignatureHelpRequest}.
---@class lsp.SignatureHelpRegistrationOptions : lsp.TextDocumentRegistrationOptions, lsp.SignatureHelpOptions

---Parameters for a {@link DefinitionRequest}.
---@class lsp.DefinitionParams : lsp.TextDocumentPositionParams, lsp.WorkDoneProgressParams, lsp.PartialResultParams

---Registration options for a {@link DefinitionRequest}.
---@class lsp.DefinitionRegistrationOptions : lsp.TextDocumentRegistrationOptions, lsp.DefinitionOptions

---Parameters for a {@link ReferencesRequest}.
---@class lsp.ReferenceParams : lsp.TextDocumentPositionParams, lsp.WorkDoneProgressParams, lsp.PartialResultParams
---@field context lsp.ReferenceContext

---Registration options for a {@link ReferencesRequest}.
---@class lsp.ReferenceRegistrationOptions : lsp.TextDocumentRegistrationOptions, lsp.ReferenceOptions

---Parameters for a {@link DocumentHighlightRequest}.
---@class lsp.DocumentHighlightParams : lsp.TextDocumentPositionParams, lsp.WorkDoneProgressParams, lsp.PartialResultParams

---A document highlight is a range inside a text document which deserves
---special attention. Usually a document highlight is visualized by changing
---the background color of its range.
---@class lsp.DocumentHighlight
---The range this highlight applies to.
---@field range lsp.Range
---The highlight kind, default is {@link DocumentHighlightKind.Text text}.
---@field kind? lsp.DocumentHighlightKind

---Registration options for a {@link DocumentHighlightRequest}.
---@class lsp.DocumentHighlightRegistrationOptions : lsp.TextDocumentRegistrationOptions, lsp.DocumentHighlightOptions

---Parameters for a {@link DocumentSymbolRequest}.
---@class lsp.DocumentSymbolParams : lsp.WorkDoneProgressParams, lsp.PartialResultParams
---The text document.
---@field textDocument lsp.TextDocumentIdentifier

---Represents information about programming constructs like variables, classes,
---interfaces etc.
---@class lsp.SymbolInformation : lsp.BaseSymbolInformation
---Indicates if this symbol is deprecated.
---@deprecated Use tags instead
---@field deprecated? boolean
---The location of this symbol. The location's range is used by a tool
---to reveal the location in the editor. If the symbol is selected in the
---tool the range's start information is used to position the cursor. So
---the range usually spans more than the actual symbol's name and does
---normally include things like visibility modifiers.
---The range doesn't have to denote a node range in the sense of an abstract
---syntax tree. It can therefore not be used to re-construct a hierarchy of
---the symbols.
---@field location lsp.Location

---Represents programming constructs like variables, classes, interfaces etc.
---that appear in a document. Document symbols can be hierarchical and they
---have two ranges: one that encloses its definition and one that points to
---its most interesting range, e.g. the range of an identifier.
---@class lsp.DocumentSymbol
---The name of this symbol. Will be displayed in the user interface and therefore must not be
---an empty string or a string only consisting of white spaces.
---@field name string
---More detail for this symbol, e.g the signature of a function.
---@field detail? string
---The kind of this symbol.
---@field kind lsp.SymbolKind
---Tags for this document symbol.
---@since 3.16.0
---@field tags? (lsp.SymbolTag)[]
---Indicates if this symbol is deprecated.
---@deprecated Use tags instead
---@field deprecated? boolean
---The range enclosing this symbol not including leading/trailing whitespace but everything else
---like comments. This information is typically used to determine if the clients cursor is
---inside the symbol to reveal in the symbol in the UI.
---@field range lsp.Range
---The range that should be selected and revealed when this symbol is being picked, e.g the name of a function.
---Must be contained by the `range`.
---@field selectionRange lsp.Range
---Children of this symbol, e.g. properties of a class.
---@field children? (lsp.DocumentSymbol)[]

---Registration options for a {@link DocumentSymbolRequest}.
---@class lsp.DocumentSymbolRegistrationOptions : lsp.TextDocumentRegistrationOptions, lsp.DocumentSymbolOptions

---The parameters of a {@link CodeActionRequest}.
---@class lsp.CodeActionParams : lsp.WorkDoneProgressParams, lsp.PartialResultParams
---The document in which the command was invoked.
---@field textDocument lsp.TextDocumentIdentifier
---The range for which the command was invoked.
---@field range lsp.Range
---Context carrying additional information.
---@field context lsp.CodeActionContext

---Represents a reference to a command. Provides a title which
---will be used to represent a command in the UI and, optionally,
---an array of arguments which will be passed to the command handler
---function when invoked.
---@class lsp.Command
---Title of the command, like `save`.
---@field title string
---The identifier of the actual command handler.
---@field command string
---Arguments that the command handler should be
---invoked with.
---@field arguments? (lsp.LSPAny)[]

---A code action represents a change that can be performed in code, e.g. to fix a problem or
---to refactor code.
---A CodeAction must set either `edit` and/or a `command`. If both are supplied, the `edit` is applied first, then the `command` is executed.
---@class lsp.CodeAction
---A short, human-readable, title for this code action.
---@field title string
---The kind of the code action.
---Used to filter code actions.
---@field kind? lsp.CodeActionKind
---The diagnostics that this code action resolves.
---@field diagnostics? (lsp.Diagnostic)[]
---Marks this as a preferred action. Preferred actions are used by the `auto fix` command and can be targeted
---by keybindings.
---A quick fix should be marked preferred if it properly addresses the underlying error.
---A refactoring should be marked preferred if it is the most reasonable choice of actions to take.
---@since 3.15.0
---@field isPreferred? boolean
---Marks that the code action cannot currently be applied.
---Clients should follow the following guidelines regarding disabled code actions:
---  - Disabled code actions are not shown in automatic [lightbulbs](https://code.visualstudio.com/docs/editor/editingevolved#_code-action)
---    code action menus.
---  - Disabled actions are shown as faded out in the code action menu when the user requests a more specific type
---    of code action, such as refactorings.
---  - If the user has a [keybinding](https://code.visualstudio.com/docs/editor/refactoring#_keybindings-for-code-actions)
---    that auto applies a code action and only disabled code actions are returned, the client should show the user an
---    error message with `reason` in the editor.
---@since 3.16.0
---@field disabled? lsp.CodeAction.disabled
---The workspace edit this code action performs.
---@field edit? lsp.WorkspaceEdit
---A command this code action executes. If a code action
---provides an edit and a command, first the edit is
---executed and then the command.
---@field command? lsp.Command
---A data entry field that is preserved on a code action between
---a `textDocument/codeAction` and a `codeAction/resolve` request.
---@since 3.16.0
---@field data? lsp.LSPAny

---Registration options for a {@link CodeActionRequest}.
---@class lsp.CodeActionRegistrationOptions : lsp.TextDocumentRegistrationOptions, lsp.CodeActionOptions

---The parameters of a {@link WorkspaceSymbolRequest}.
---@class lsp.WorkspaceSymbolParams : lsp.WorkDoneProgressParams, lsp.PartialResultParams
---A query string to filter symbols by. Clients may send an empty
---string here to request all symbols.
---@field query string

---A special workspace symbol that supports locations without a range.
---See also SymbolInformation.
---@since 3.17.0
---@class lsp.WorkspaceSymbol : lsp.BaseSymbolInformation
---The location of the symbol. Whether a server is allowed to
---return a location without a range depends on the client
---capability `workspace.symbol.resolveSupport`.
---See SymbolInformation#location for more details.
---@field location lsp.Location | lsp.WorkspaceSymbol.location.2
---A data entry field that is preserved on a workspace symbol between a
---workspace symbol request and a workspace symbol resolve request.
---@field data? lsp.LSPAny

---Registration options for a {@link WorkspaceSymbolRequest}.
---@class lsp.WorkspaceSymbolRegistrationOptions : lsp.WorkspaceSymbolOptions

---The parameters of a {@link CodeLensRequest}.
---@class lsp.CodeLensParams : lsp.WorkDoneProgressParams, lsp.PartialResultParams
---The document to request code lens for.
---@field textDocument lsp.TextDocumentIdentifier

---A code lens represents a {@link Command command} that should be shown along with
---source text, like the number of references, a way to run tests, etc.
---A code lens is _unresolved_ when no command is associated to it. For performance
---reasons the creation of a code lens and resolving should be done in two stages.
---@class lsp.CodeLens
---The range in which this code lens is valid. Should only span a single line.
---@field range lsp.Range
---The command this code lens represents.
---@field command? lsp.Command
---A data entry field that is preserved on a code lens item between
---a {@link CodeLensRequest} and a {@link CodeLensResolveRequest}
---@field data? lsp.LSPAny

---Registration options for a {@link CodeLensRequest}.
---@class lsp.CodeLensRegistrationOptions : lsp.TextDocumentRegistrationOptions, lsp.CodeLensOptions

---The parameters of a {@link DocumentLinkRequest}.
---@class lsp.DocumentLinkParams : lsp.WorkDoneProgressParams, lsp.PartialResultParams
---The document to provide document links for.
---@field textDocument lsp.TextDocumentIdentifier

---A document link is a range in a text document that links to an internal or external resource, like another
---text document or a web site.
---@class lsp.DocumentLink
---The range this link applies to.
---@field range lsp.Range
---The uri this link points to. If missing a resolve request is sent later.
---@field target? lsp.URI
---The tooltip text when you hover over this link.
---If a tooltip is provided, is will be displayed in a string that includes instructions on how to
---trigger the link, such as `{0} (ctrl + click)`. The specific instructions vary depending on OS,
---user settings, and localization.
---@since 3.15.0
---@field tooltip? string
---A data entry field that is preserved on a document link between a
---DocumentLinkRequest and a DocumentLinkResolveRequest.
---@field data? lsp.LSPAny

---Registration options for a {@link DocumentLinkRequest}.
---@class lsp.DocumentLinkRegistrationOptions : lsp.TextDocumentRegistrationOptions, lsp.DocumentLinkOptions

---The parameters of a {@link DocumentFormattingRequest}.
---@class lsp.DocumentFormattingParams : lsp.WorkDoneProgressParams
---The document to format.
---@field textDocument lsp.TextDocumentIdentifier
---The format options.
---@field options lsp.FormattingOptions

---Registration options for a {@link DocumentFormattingRequest}.
---@class lsp.DocumentFormattingRegistrationOptions : lsp.TextDocumentRegistrationOptions, lsp.DocumentFormattingOptions

---The parameters of a {@link DocumentRangeFormattingRequest}.
---@class lsp.DocumentRangeFormattingParams : lsp.WorkDoneProgressParams
---The document to format.
---@field textDocument lsp.TextDocumentIdentifier
---The range to format
---@field range lsp.Range
---The format options
---@field options lsp.FormattingOptions

---Registration options for a {@link DocumentRangeFormattingRequest}.
---@class lsp.DocumentRangeFormattingRegistrationOptions : lsp.TextDocumentRegistrationOptions, lsp.DocumentRangeFormattingOptions

---The parameters of a {@link DocumentRangesFormattingRequest}.
---@since 3.18.0
---@proposed
---@class lsp.DocumentRangesFormattingParams : lsp.WorkDoneProgressParams
---The document to format.
---@field textDocument lsp.TextDocumentIdentifier
---The ranges to format
---@field ranges (lsp.Range)[]
---The format options
---@field options lsp.FormattingOptions

---The parameters of a {@link DocumentOnTypeFormattingRequest}.
---@class lsp.DocumentOnTypeFormattingParams
---The document to format.
---@field textDocument lsp.TextDocumentIdentifier
---The position around which the on type formatting should happen.
---This is not necessarily the exact position where the character denoted
---by the property `ch` got typed.
---@field position lsp.Position
---The character that has been typed that triggered the formatting
---on type request. That is not necessarily the last character that
---got inserted into the document since the client could auto insert
---characters as well (e.g. like automatic brace completion).
---@field ch string
---The formatting options.
---@field options lsp.FormattingOptions

---Registration options for a {@link DocumentOnTypeFormattingRequest}.
---@class lsp.DocumentOnTypeFormattingRegistrationOptions : lsp.TextDocumentRegistrationOptions, lsp.DocumentOnTypeFormattingOptions

---The parameters of a {@link RenameRequest}.
---@class lsp.RenameParams : lsp.WorkDoneProgressParams
---The document to rename.
---@field textDocument lsp.TextDocumentIdentifier
---The position at which this request was sent.
---@field position lsp.Position
---The new name of the symbol. If the given name is not valid the
---request must return a {@link ResponseError} with an
---appropriate message set.
---@field newName string

---Registration options for a {@link RenameRequest}.
---@class lsp.RenameRegistrationOptions : lsp.TextDocumentRegistrationOptions, lsp.RenameOptions

---@class lsp.PrepareRenameParams : lsp.TextDocumentPositionParams, lsp.WorkDoneProgressParams

---The parameters of a {@link ExecuteCommandRequest}.
---@class lsp.ExecuteCommandParams : lsp.WorkDoneProgressParams
---The identifier of the actual command handler.
---@field command string
---Arguments that the command should be invoked with.
---@field arguments? (lsp.LSPAny)[]

---Registration options for a {@link ExecuteCommandRequest}.
---@class lsp.ExecuteCommandRegistrationOptions : lsp.ExecuteCommandOptions

---The parameters passed via an apply workspace edit request.
---@class lsp.ApplyWorkspaceEditParams
---An optional label of the workspace edit. This label is
---presented in the user interface for example on an undo
---stack to undo the workspace edit.
---@field label? string
---The edits to apply.
---@field edit lsp.WorkspaceEdit

---The result returned from the apply workspace edit request.
---@since 3.17 renamed from ApplyWorkspaceEditResponse
---@class lsp.ApplyWorkspaceEditResult
---Indicates whether the edit was applied or not.
---@field applied boolean
---An optional textual description for why the edit was not applied.
---This may be used by the server for diagnostic logging or to provide
---a suitable error for a request that triggered the edit.
---@field failureReason? string
---Depending on the client's failure handling strategy `failedChange` might
---contain the index of the change that failed. This property is only available
---if the client signals a `failureHandlingStrategy` in its client capabilities.
---@field failedChange? integer

---@class lsp.WorkDoneProgressBegin
---@field kind "begin"
---Mandatory title of the progress operation. Used to briefly inform about
---the kind of operation being performed.
---Examples: "Indexing" or "Linking dependencies".
---@field title string
---Controls if a cancel button should show to allow the user to cancel the
---long running operation. Clients that don't support cancellation are allowed
---to ignore the setting.
---@field cancellable? boolean
---Optional, more detailed associated progress message. Contains
---complementary information to the `title`.
---Examples: "3/25 files", "project/src/module2", "node_modules/some_dep".
---If unset, the previous progress message (if any) is still valid.
---@field message? string
---Optional progress percentage to display (value 100 is considered 100%).
---If not provided infinite progress is assumed and clients are allowed
---to ignore the `percentage` value in subsequent in report notifications.
---The value should be steadily rising. Clients are free to ignore values
---that are not following this rule. The value range is [0, 100].
---@field percentage? integer

---@class lsp.WorkDoneProgressReport
---@field kind "report"
---Controls enablement state of a cancel button.
---Clients that don't support cancellation or don't support controlling the button's
---enablement state are allowed to ignore the property.
---@field cancellable? boolean
---Optional, more detailed associated progress message. Contains
---complementary information to the `title`.
---Examples: "3/25 files", "project/src/module2", "node_modules/some_dep".
---If unset, the previous progress message (if any) is still valid.
---@field message? string
---Optional progress percentage to display (value 100 is considered 100%).
---If not provided infinite progress is assumed and clients are allowed
---to ignore the `percentage` value in subsequent in report notifications.
---The value should be steadily rising. Clients are free to ignore values
---that are not following this rule. The value range is [0, 100]
---@field percentage? integer

---@class lsp.WorkDoneProgressEnd
---@field kind "end"
---Optional, a final message indicating to for example indicate the outcome
---of the operation.
---@field message? string

---@class lsp.SetTraceParams
---@field value lsp.TraceValues

---@class lsp.LogTraceParams
---@field message string
---@field verbose? string

---@class lsp.CancelParams
---The request id to cancel.
---@field id integer | string

---@class lsp.ProgressParams
---The progress token provided by the client or server.
---@field token lsp.ProgressToken
---The progress data.
---@field value lsp.LSPAny

---A parameter literal used in requests to pass a text document and a position inside that
---document.
---@class lsp.TextDocumentPositionParams
---The text document.
---@field textDocument lsp.TextDocumentIdentifier
---The position inside the text document.
---@field position lsp.Position

---@class lsp.WorkDoneProgressParams
---An optional token that a server can use to report work done progress.
---@field workDoneToken? lsp.ProgressToken

---@class lsp.PartialResultParams
---An optional token that a server can use to report partial results (e.g. streaming) to
---the client.
---@field partialResultToken? lsp.ProgressToken

---Represents the connection of two locations. Provides additional metadata over normal {@link Location locations},
---including an origin range.
---@class lsp.LocationLink
---Span of the origin of this link.
---Used as the underlined span for mouse interaction. Defaults to the word range at
---the definition position.
---@field originSelectionRange? lsp.Range
---The target resource identifier of this link.
---@field targetUri lsp.DocumentUri
---The full target range of this link. If the target for example is a symbol then target range is the
---range enclosing this symbol not including leading/trailing whitespace but everything else
---like comments. This information is typically used to highlight the range in the editor.
---@field targetRange lsp.Range
---The range that should be selected and revealed when this link is being followed, e.g the name of a function.
---Must be contained by the `targetRange`. See also `DocumentSymbol#range`
---@field targetSelectionRange lsp.Range

---A range in a text document expressed as (zero-based) start and end positions.
---If you want to specify a range that contains a line including the line ending
---character(s) then use an end position denoting the start of the next line.
---For example:
---```ts
---{
---    start: { line: 5, character: 23 }
---    end : { line 6, character : 0 }
---}
---```
---@class lsp.Range
---The range's start position.
---@field start lsp.Position
---The range's end position.
---@field end lsp.Position

---@class lsp.ImplementationOptions : lsp.WorkDoneProgressOptions

---Static registration options to be returned in the initialize
---request.
---@class lsp.StaticRegistrationOptions
---The id used to register the request. The id can be used to deregister
---the request again. See also Registration#id.
---@field id? string

---@class lsp.TypeDefinitionOptions : lsp.WorkDoneProgressOptions

---The workspace folder change event.
---@class lsp.WorkspaceFoldersChangeEvent
---The array of added workspace folders
---@field added (lsp.WorkspaceFolder)[]
---The array of the removed workspace folders
---@field removed (lsp.WorkspaceFolder)[]

---@class lsp.ConfigurationItem
---The scope to get the configuration section for.
---@field scopeUri? lsp.URI
---The configuration section asked for.
---@field section? string

---A literal to identify a text document in the client.
---@class lsp.TextDocumentIdentifier
---The text document's uri.
---@field uri lsp.DocumentUri

---Represents a color in RGBA space.
---@class lsp.Color
---The red component of this color in the range [0-1].
---@field red number
---The green component of this color in the range [0-1].
---@field green number
---The blue component of this color in the range [0-1].
---@field blue number
---The alpha component of this color in the range [0-1].
---@field alpha number

---@class lsp.DocumentColorOptions : lsp.WorkDoneProgressOptions

---@class lsp.FoldingRangeOptions : lsp.WorkDoneProgressOptions

---@class lsp.DeclarationOptions : lsp.WorkDoneProgressOptions

---Position in a text document expressed as zero-based line and character
---offset. Prior to 3.17 the offsets were always based on a UTF-16 string
---representation. So a string of the form `a𐐀b` the character offset of the
---character `a` is 0, the character offset of `𐐀` is 1 and the character
---offset of b is 3 since `𐐀` is represented using two code units in UTF-16.
---Since 3.17 clients and servers can agree on a different string encoding
---representation (e.g. UTF-8). The client announces it's supported encoding
---via the client capability [`general.positionEncodings`](https://microsoft.github.io/language-server-protocol/specifications/specification-current/#clientCapabilities).
---The value is an array of position encodings the client supports, with
---decreasing preference (e.g. the encoding at index `0` is the most preferred
---one). To stay backwards compatible the only mandatory encoding is UTF-16
---represented via the string `utf-16`. The server can pick one of the
---encodings offered by the client and signals that encoding back to the
---client via the initialize result's property
---[`capabilities.positionEncoding`](https://microsoft.github.io/language-server-protocol/specifications/specification-current/#serverCapabilities). If the string value
---`utf-16` is missing from the client's capability `general.positionEncodings`
---servers can safely assume that the client supports UTF-16. If the server
---omits the position encoding in its initialize result the encoding defaults
---to the string value `utf-16`. Implementation considerations: since the
---conversion from one encoding into another requires the content of the
---file / line the conversion is best done where the file is read which is
---usually on the server side.
---Positions are line end character agnostic. So you can not specify a position
---that denotes `\r|\n` or `\n|` where `|` represents the character offset.
---@since 3.17.0 - support for negotiated position encoding.
---@class lsp.Position
---Line position in a document (zero-based).
---If a line number is greater than the number of lines in a document, it defaults back to the number of lines in the document.
---If a line number is negative, it defaults to 0.
---@field line integer
---Character offset on a line in a document (zero-based).
---The meaning of this offset is determined by the negotiated
---`PositionEncodingKind`.
---If the character value is greater than the line length it defaults back to the
---line length.
---@field character integer

---@class lsp.SelectionRangeOptions : lsp.WorkDoneProgressOptions

---Call hierarchy options used during static registration.
---@since 3.16.0
---@class lsp.CallHierarchyOptions : lsp.WorkDoneProgressOptions

---@since 3.16.0
---@class lsp.SemanticTokensOptions : lsp.WorkDoneProgressOptions
---The legend used by the server
---@field legend lsp.SemanticTokensLegend
---Server supports providing semantic tokens for a specific range
---of a document.
---@field range? boolean | lsp.SemanticTokensOptions.range.2
---Server supports providing semantic tokens for a full document.
---@field full? boolean | lsp.SemanticTokensOptions.full.2

---@since 3.16.0
---@class lsp.SemanticTokensEdit
---The start offset of the edit.
---@field start integer
---The count of elements to remove.
---@field deleteCount integer
---The elements to insert.
---@field data? (integer)[]

---@class lsp.LinkedEditingRangeOptions : lsp.WorkDoneProgressOptions

---Represents information on a file/folder create.
---@since 3.16.0
---@class lsp.FileCreate
---A file:// URI for the location of the file/folder being created.
---@field uri string

---Describes textual changes on a text document. A TextDocumentEdit describes all changes
---on a document version Si and after they are applied move the document to version Si+1.
---So the creator of a TextDocumentEdit doesn't need to sort the array of edits or do any
---kind of ordering. However the edits must be non overlapping.
---@class lsp.TextDocumentEdit
---The text document to change.
---@field textDocument lsp.OptionalVersionedTextDocumentIdentifier
---The edits to be applied.
---@since 3.16.0 - support for AnnotatedTextEdit. This is guarded using a
---client capability.
---@field edits (lsp.TextEdit | lsp.AnnotatedTextEdit)[]

---Create file operation.
---@class lsp.CreateFile : lsp.ResourceOperation
---A create
---@field kind "create"
---The resource to create.
---@field uri lsp.DocumentUri
---Additional options
---@field options? lsp.CreateFileOptions

---Rename file operation
---@class lsp.RenameFile : lsp.ResourceOperation
---A rename
---@field kind "rename"
---The old (existing) location.
---@field oldUri lsp.DocumentUri
---The new location.
---@field newUri lsp.DocumentUri
---Rename options.
---@field options? lsp.RenameFileOptions

---Delete file operation
---@class lsp.DeleteFile : lsp.ResourceOperation
---A delete
---@field kind "delete"
---The file to delete.
---@field uri lsp.DocumentUri
---Delete options.
---@field options? lsp.DeleteFileOptions

---Additional information that describes document changes.
---@since 3.16.0
---@class lsp.ChangeAnnotation
---A human-readable string describing the actual change. The string
---is rendered prominent in the user interface.
---@field label string
---A flag which indicates that user confirmation is needed
---before applying the change.
---@field needsConfirmation? boolean
---A human-readable string which is rendered less prominent in
---the user interface.
---@field description? string

---A filter to describe in which file operation requests or notifications
---the server is interested in receiving.
---@since 3.16.0
---@class lsp.FileOperationFilter
---A Uri scheme like `file` or `untitled`.
---@field scheme? string
---The actual file operation pattern.
---@field pattern lsp.FileOperationPattern

---Represents information on a file/folder rename.
---@since 3.16.0
---@class lsp.FileRename
---A file:// URI for the original location of the file/folder being renamed.
---@field oldUri string
---A file:// URI for the new location of the file/folder being renamed.
---@field newUri string

---Represents information on a file/folder delete.
---@since 3.16.0
---@class lsp.FileDelete
---A file:// URI for the location of the file/folder being deleted.
---@field uri string

---@class lsp.MonikerOptions : lsp.WorkDoneProgressOptions

---Type hierarchy options used during static registration.
---@since 3.17.0
---@class lsp.TypeHierarchyOptions : lsp.WorkDoneProgressOptions

---@since 3.17.0
---@class lsp.InlineValueContext
---The stack frame (as a DAP Id) where the execution has stopped.
---@field frameId integer
---The document range where execution has stopped.
---Typically the end position of the range denotes the line where the inline values are shown.
---@field stoppedLocation lsp.Range

---Provide inline value as text.
---@since 3.17.0
---@class lsp.InlineValueText
---The document range for which the inline value applies.
---@field range lsp.Range
---The text of the inline value.
---@field text string

---Provide inline value through a variable lookup.
---If only a range is specified, the variable name will be extracted from the underlying document.
---An optional variable name can be used to override the extracted name.
---@since 3.17.0
---@class lsp.InlineValueVariableLookup
---The document range for which the inline value applies.
---The range is used to extract the variable name from the underlying document.
---@field range lsp.Range
---If specified the name of the variable to look up.
---@field variableName? string
---How to perform the lookup.
---@field caseSensitiveLookup boolean

---Provide an inline value through an expression evaluation.
---If only a range is specified, the expression will be extracted from the underlying document.
---An optional expression can be used to override the extracted expression.
---@since 3.17.0
---@class lsp.InlineValueEvaluatableExpression
---The document range for which the inline value applies.
---The range is used to extract the evaluatable expression from the underlying document.
---@field range lsp.Range
---If specified the expression overrides the extracted expression.
---@field expression? string

---Inline value options used during static registration.
---@since 3.17.0
---@class lsp.InlineValueOptions : lsp.WorkDoneProgressOptions

---An inlay hint label part allows for interactive and composite labels
---of inlay hints.
---@since 3.17.0
---@class lsp.InlayHintLabelPart
---The value of this label part.
---@field value string
---The tooltip text when you hover over this label part. Depending on
---the client capability `inlayHint.resolveSupport` clients might resolve
---this property late using the resolve request.
---@field tooltip? string | lsp.MarkupContent
---An optional source code location that represents this
---label part.
---The editor will use this location for the hover and for code navigation
---features: This part will become a clickable link that resolves to the
---definition of the symbol at the given location (not necessarily the
---location itself), it shows the hover that shows at the given location,
---and it shows a context menu with further code navigation commands.
---Depending on the client capability `inlayHint.resolveSupport` clients
---might resolve this property late using the resolve request.
---@field location? lsp.Location
---An optional command for this label part.
---Depending on the client capability `inlayHint.resolveSupport` clients
---might resolve this property late using the resolve request.
---@field command? lsp.Command

---A `MarkupContent` literal represents a string value which content is interpreted base on its
---kind flag. Currently the protocol supports `plaintext` and `markdown` as markup kinds.
---If the kind is `markdown` then the value can contain fenced code blocks like in GitHub issues.
---See https://help.github.com/articles/creating-and-highlighting-code-blocks/#syntax-highlighting
---Here is an example how such a string can be constructed using JavaScript / TypeScript:
---```ts
---let markdown: MarkdownContent = {
--- kind: MarkupKind.Markdown,
--- value: [
---   '# Header',
---   'Some text',
---   '```typescript',
---   'someCode();',
---   '```'
--- ].join('\n')
---};
---```
---*Please Note* that clients might sanitize the return markdown. A client could decide to
---remove HTML from the markdown to avoid script execution.
---@class lsp.MarkupContent
---The type of the Markup
---@field kind lsp.MarkupKind
---The content itself
---@field value string

---Inlay hint options used during static registration.
---@since 3.17.0
---@class lsp.InlayHintOptions : lsp.WorkDoneProgressOptions
---The server provides support to resolve additional
---information for an inlay hint item.
---@field resolveProvider? boolean

---A full diagnostic report with a set of related documents.
---@since 3.17.0
---@class lsp.RelatedFullDocumentDiagnosticReport : lsp.FullDocumentDiagnosticReport
---Diagnostics of related documents. This information is useful
---in programming languages where code in a file A can generate
---diagnostics in a file B which A depends on. An example of
---such a language is C/C++ where marco definitions in a file
---a.cpp and result in errors in a header file b.hpp.
---@since 3.17.0
---@field relatedDocuments? { [lsp.DocumentUri]: lsp.FullDocumentDiagnosticReport | lsp.UnchangedDocumentDiagnosticReport }

---An unchanged diagnostic report with a set of related documents.
---@since 3.17.0
---@class lsp.RelatedUnchangedDocumentDiagnosticReport : lsp.UnchangedDocumentDiagnosticReport
---Diagnostics of related documents. This information is useful
---in programming languages where code in a file A can generate
---diagnostics in a file B which A depends on. An example of
---such a language is C/C++ where marco definitions in a file
---a.cpp and result in errors in a header file b.hpp.
---@since 3.17.0
---@field relatedDocuments? { [lsp.DocumentUri]: lsp.FullDocumentDiagnosticReport | lsp.UnchangedDocumentDiagnosticReport }

---A diagnostic report with a full set of problems.
---@since 3.17.0
---@class lsp.FullDocumentDiagnosticReport
---A full document diagnostic report.
---@field kind "full"
---An optional result id. If provided it will
---be sent on the next diagnostic request for the
---same document.
---@field resultId? string
---The actual items.
---@field items (lsp.Diagnostic)[]

---A diagnostic report indicating that the last returned
---report is still accurate.
---@since 3.17.0
---@class lsp.UnchangedDocumentDiagnosticReport
---A document diagnostic report indicating
---no changes to the last result. A server can
---only return `unchanged` if result ids are
---provided.
---@field kind "unchanged"
---A result id which will be sent on the next
---diagnostic request for the same document.
---@field resultId string

---Diagnostic options.
---@since 3.17.0
---@class lsp.DiagnosticOptions : lsp.WorkDoneProgressOptions
---An optional identifier under which the diagnostics are
---managed by the client.
---@field identifier? string
---Whether the language has inter file dependencies meaning that
---editing code in one file can result in a different diagnostic
---set in another file. Inter file dependencies are common for
---most programming languages and typically uncommon for linters.
---@field interFileDependencies boolean
---The server provides support for workspace diagnostics as well.
---@field workspaceDiagnostics boolean

---A previous result id in a workspace pull request.
---@since 3.17.0
---@class lsp.PreviousResultId
---The URI for which the client knowns a
---result id.
---@field uri lsp.DocumentUri
---The value of the previous result id.
---@field value string

---A notebook document.
---@since 3.17.0
---@class lsp.NotebookDocument
---The notebook document's uri.
---@field uri lsp.URI
---The type of the notebook.
---@field notebookType string
---The version number of this document (it will increase after each
---change, including undo/redo).
---@field version integer
---Additional metadata stored with the notebook
---document.
---Note: should always be an object literal (e.g. LSPObject)
---@field metadata? lsp.LSPObject
---The cells of a notebook.
---@field cells (lsp.NotebookCell)[]

---An item to transfer a text document from the client to the
---server.
---@class lsp.TextDocumentItem
---The text document's uri.
---@field uri lsp.DocumentUri
---The text document's language identifier.
---@field languageId string
---The version number of this document (it will increase after each
---change, including undo/redo).
---@field version integer
---The content of the opened text document.
---@field text string

---A versioned notebook document identifier.
---@since 3.17.0
---@class lsp.VersionedNotebookDocumentIdentifier
---The version number of this notebook document.
---@field version integer
---The notebook document's uri.
---@field uri lsp.URI

---A change event for a notebook document.
---@since 3.17.0
---@class lsp.NotebookDocumentChangeEvent
---The changed meta data if any.
---Note: should always be an object literal (e.g. LSPObject)
---@field metadata? lsp.LSPObject
---Changes to cells
---@field cells? lsp.NotebookDocumentChangeEvent.cells

---A literal to identify a notebook document in the client.
---@since 3.17.0
---@class lsp.NotebookDocumentIdentifier
---The notebook document's uri.
---@field uri lsp.URI

---Provides information about the context in which an inline completion was requested.
---@since 3.18.0
---@proposed
---@class lsp.InlineCompletionContext
---Describes how the inline completion was triggered.
---@field triggerKind lsp.InlineCompletionTriggerKind
---Provides information about the currently selected item in the autocomplete widget if it is visible.
---@field selectedCompletionInfo? lsp.SelectedCompletionInfo

---A string value used as a snippet is a template which allows to insert text
---and to control the editor cursor when insertion happens.
---A snippet can define tab stops and placeholders with `$1`, `$2`
---and `${3:foo}`. `$0` defines the final tab stop, it defaults to
---the end of the snippet. Variables are defined with `$name` and
---`${name:default value}`.
---@since 3.18.0
---@proposed
---@class lsp.StringValue
---The kind of string value.
---@field kind "snippet"
---The snippet string.
---@field value string

---Inline completion options used during static registration.
---@since 3.18.0
---@proposed
---@class lsp.InlineCompletionOptions : lsp.WorkDoneProgressOptions

---General parameters to register for a notification or to register a provider.
---@class lsp.Registration
---The id used to register the request. The id can be used to deregister
---the request again.
---@field id string
---The method / capability to register for.
---@field method string
---Options necessary for the registration.
---@field registerOptions? lsp.LSPAny

---General parameters to unregister a request or notification.
---@class lsp.Unregistration
---The id used to unregister the request or notification. Usually an id
---provided during the register request.
---@field id string
---The method to unregister for.
---@field method string

---The initialize parameters
---@class lsp._InitializeParams : lsp.WorkDoneProgressParams
---The process Id of the parent process that started
---the server.
---Is `null` if the process has not been started by another process.
---If the parent process is not alive then the server should exit.
---@field processId integer | cjson.null
---Information about the client
---@since 3.15.0
---@field clientInfo? lsp._InitializeParams.clientInfo
---The locale the client is currently showing the user interface
---in. This must not necessarily be the locale of the operating
---system.
---Uses IETF language tags as the value's syntax
---(See https://en.wikipedia.org/wiki/IETF_language_tag)
---@since 3.16.0
---@field locale? string
---The rootPath of the workspace. Is null
---if no folder is open.
---@deprecated in favour of rootUri.
---@field rootPath? string | cjson.null
---The rootUri of the workspace. Is null if no
---folder is open. If both `rootPath` and `rootUri` are set
---`rootUri` wins.
---@deprecated in favour of workspaceFolders.
---@field rootUri lsp.DocumentUri | cjson.null
---The capabilities provided by the client (editor or tool)
---@field capabilities lsp.ClientCapabilities
---User provided initialization options.
---@field initializationOptions? lsp.LSPAny
---The initial trace setting. If omitted trace is disabled ('off').
---@field trace? lsp.TraceValues

---@class lsp.WorkspaceFoldersInitializeParams
---The workspace folders configured in the client when the server starts.
---This property is only available if the client supports workspace folders.
---It can be `null` if the client supports workspace folders but none are
---configured.
---@since 3.6.0
---@field workspaceFolders? (lsp.WorkspaceFolder)[] | cjson.null

---Defines the capabilities provided by a language
---server.
---@class lsp.ServerCapabilities
---The position encoding the server picked from the encodings offered
---by the client via the client capability `general.positionEncodings`.
---If the client didn't provide any position encodings the only valid
---value that a server can return is 'utf-16'.
---If omitted it defaults to 'utf-16'.
---@since 3.17.0
---@field positionEncoding? lsp.PositionEncodingKind
---Defines how text documents are synced. Is either a detailed structure
---defining each notification or for backwards compatibility the
---TextDocumentSyncKind number.
---@field textDocumentSync? lsp.TextDocumentSyncOptions | lsp.TextDocumentSyncKind
---Defines how notebook documents are synced.
---@since 3.17.0
---@field notebookDocumentSync? lsp.NotebookDocumentSyncOptions | lsp.NotebookDocumentSyncRegistrationOptions
---The server provides completion support.
---@field completionProvider? lsp.CompletionOptions
---The server provides hover support.
---@field hoverProvider? boolean | lsp.HoverOptions
---The server provides signature help support.
---@field signatureHelpProvider? lsp.SignatureHelpOptions
---The server provides Goto Declaration support.
---@field declarationProvider? boolean | lsp.DeclarationOptions | lsp.DeclarationRegistrationOptions
---The server provides goto definition support.
---@field definitionProvider? boolean | lsp.DefinitionOptions
---The server provides Goto Type Definition support.
---@field typeDefinitionProvider? boolean | lsp.TypeDefinitionOptions | lsp.TypeDefinitionRegistrationOptions
---The server provides Goto Implementation support.
---@field implementationProvider? boolean | lsp.ImplementationOptions | lsp.ImplementationRegistrationOptions
---The server provides find references support.
---@field referencesProvider? boolean | lsp.ReferenceOptions
---The server provides document highlight support.
---@field documentHighlightProvider? boolean | lsp.DocumentHighlightOptions
---The server provides document symbol support.
---@field documentSymbolProvider? boolean | lsp.DocumentSymbolOptions
---The server provides code actions. CodeActionOptions may only be
---specified if the client states that it supports
---`codeActionLiteralSupport` in its initial `initialize` request.
---@field codeActionProvider? boolean | lsp.CodeActionOptions
---The server provides code lens.
---@field codeLensProvider? lsp.CodeLensOptions
---The server provides document link support.
---@field documentLinkProvider? lsp.DocumentLinkOptions
---The server provides color provider support.
---@field colorProvider? boolean | lsp.DocumentColorOptions | lsp.DocumentColorRegistrationOptions
---The server provides workspace symbol support.
---@field workspaceSymbolProvider? boolean | lsp.WorkspaceSymbolOptions
---The server provides document formatting.
---@field documentFormattingProvider? boolean | lsp.DocumentFormattingOptions
---The server provides document range formatting.
---@field documentRangeFormattingProvider? boolean | lsp.DocumentRangeFormattingOptions
---The server provides document formatting on typing.
---@field documentOnTypeFormattingProvider? lsp.DocumentOnTypeFormattingOptions
---The server provides rename support. RenameOptions may only be
---specified if the client states that it supports
---`prepareSupport` in its initial `initialize` request.
---@field renameProvider? boolean | lsp.RenameOptions
---The server provides folding provider support.
---@field foldingRangeProvider? boolean | lsp.FoldingRangeOptions | lsp.FoldingRangeRegistrationOptions
---The server provides selection range support.
---@field selectionRangeProvider? boolean | lsp.SelectionRangeOptions | lsp.SelectionRangeRegistrationOptions
---The server provides execute command support.
---@field executeCommandProvider? lsp.ExecuteCommandOptions
---The server provides call hierarchy support.
---@since 3.16.0
---@field callHierarchyProvider? boolean | lsp.CallHierarchyOptions | lsp.CallHierarchyRegistrationOptions
---The server provides linked editing range support.
---@since 3.16.0
---@field linkedEditingRangeProvider? boolean | lsp.LinkedEditingRangeOptions | lsp.LinkedEditingRangeRegistrationOptions
---The server provides semantic tokens support.
---@since 3.16.0
---@field semanticTokensProvider? lsp.SemanticTokensOptions | lsp.SemanticTokensRegistrationOptions
---The server provides moniker support.
---@since 3.16.0
---@field monikerProvider? boolean | lsp.MonikerOptions | lsp.MonikerRegistrationOptions
---The server provides type hierarchy support.
---@since 3.17.0
---@field typeHierarchyProvider? boolean | lsp.TypeHierarchyOptions | lsp.TypeHierarchyRegistrationOptions
---The server provides inline values.
---@since 3.17.0
---@field inlineValueProvider? boolean | lsp.InlineValueOptions | lsp.InlineValueRegistrationOptions
---The server provides inlay hints.
---@since 3.17.0
---@field inlayHintProvider? boolean | lsp.InlayHintOptions | lsp.InlayHintRegistrationOptions
---The server has support for pull model diagnostics.
---@since 3.17.0
---@field diagnosticProvider? lsp.DiagnosticOptions | lsp.DiagnosticRegistrationOptions
---Inline completion options used during static registration.
---@since 3.18.0
---@proposed
---@field inlineCompletionProvider? boolean | lsp.InlineCompletionOptions
---Workspace specific server capabilities.
---@field workspace? lsp.ServerCapabilities.workspace
---Experimental server capabilities.
---@field experimental? lsp.LSPAny

---A text document identifier to denote a specific version of a text document.
---@class lsp.VersionedTextDocumentIdentifier : lsp.TextDocumentIdentifier
---The version number of this document.
---@field version integer

---Save options.
---@class lsp.SaveOptions
---The client is supposed to include the content on save.
---@field includeText? boolean

---An event describing a file change.
---@class lsp.FileEvent
---The file's uri.
---@field uri lsp.DocumentUri
---The change type.
---@field type lsp.FileChangeType

---@class lsp.FileSystemWatcher
---The glob pattern to watch. See {@link GlobPattern glob pattern} for more detail.
---@since 3.17.0 support for relative patterns.
---@field globPattern lsp.GlobPattern
---The kind of events of interest. If omitted it defaults
---to WatchKind.Create | WatchKind.Change | WatchKind.Delete
---which is 7.
---@field kind? lsp.WatchKind

---Represents a diagnostic, such as a compiler error or warning. Diagnostic objects
---are only valid in the scope of a resource.
---@class lsp.Diagnostic
---The range at which the message applies
---@field range lsp.Range
---The diagnostic's severity. Can be omitted. If omitted it is up to the
---client to interpret diagnostics as error, warning, info or hint.
---@field severity? lsp.DiagnosticSeverity
---The diagnostic's code, which usually appear in the user interface.
---@field code? integer | string
---An optional property to describe the error code.
---Requires the code field (above) to be present/not null.
---@since 3.16.0
---@field codeDescription? lsp.CodeDescription
---A human-readable string describing the source of this
---diagnostic, e.g. 'typescript' or 'super lint'. It usually
---appears in the user interface.
---@field source? string
---The diagnostic's message. It usually appears in the user interface
---@field message string
---Additional metadata about the diagnostic.
---@since 3.15.0
---@field tags? (lsp.DiagnosticTag)[]
---An array of related diagnostic information, e.g. when symbol-names within
---a scope collide all definitions can be marked via this property.
---@field relatedInformation? (lsp.DiagnosticRelatedInformation)[]
---A data entry field that is preserved between a `textDocument/publishDiagnostics`
---notification and `textDocument/codeAction` request.
---@since 3.16.0
---@field data? lsp.LSPAny

---Contains additional information about the context in which a completion request is triggered.
---@class lsp.CompletionContext
---How the completion was triggered.
---@field triggerKind lsp.CompletionTriggerKind
---The trigger character (a single character) that has trigger code complete.
---Is undefined if `triggerKind !== CompletionTriggerKind.TriggerCharacter`
---@field triggerCharacter? string

---Additional details for a completion item label.
---@since 3.17.0
---@class lsp.CompletionItemLabelDetails
---An optional string which is rendered less prominently directly after {@link CompletionItem.label label},
---without any spacing. Should be used for function signatures and type annotations.
---@field detail? string
---An optional string which is rendered less prominently after {@link CompletionItem.detail}. Should be used
---for fully qualified names and file paths.
---@field description? string

---A special text edit to provide an insert and a replace operation.
---@since 3.16.0
---@class lsp.InsertReplaceEdit
---The string to be inserted.
---@field newText string
---The range if the insert is requested
---@field insert lsp.Range
---The range if the replace is requested.
---@field replace lsp.Range

---Completion options.
---@class lsp.CompletionOptions : lsp.WorkDoneProgressOptions
---Most tools trigger completion request automatically without explicitly requesting
---it using a keyboard shortcut (e.g. Ctrl+Space). Typically they do so when the user
---starts to type an identifier. For example if the user types `c` in a JavaScript file
---code complete will automatically pop up present `console` besides others as a
---completion item. Characters that make up identifiers don't need to be listed here.
---If code complete should automatically be trigger on characters not being valid inside
---an identifier (for example `.` in JavaScript) list them in `triggerCharacters`.
---@field triggerCharacters? (string)[]
---The list of all possible characters that commit a completion. This field can be used
---if clients don't support individual commit characters per completion item. See
---`ClientCapabilities.textDocument.completion.completionItem.commitCharactersSupport`
---If a server provides both `allCommitCharacters` and commit characters on an individual
---completion item the ones on the completion item win.
---@since 3.2.0
---@field allCommitCharacters? (string)[]
---The server provides support to resolve additional
---information for a completion item.
---@field resolveProvider? boolean
---The server supports the following `CompletionItem` specific
---capabilities.
---@since 3.17.0
---@field completionItem? lsp.CompletionOptions.completionItem

---Hover options.
---@class lsp.HoverOptions : lsp.WorkDoneProgressOptions

---Additional information about the context in which a signature help request was triggered.
---@since 3.15.0
---@class lsp.SignatureHelpContext
---Action that caused signature help to be triggered.
---@field triggerKind lsp.SignatureHelpTriggerKind
---Character that caused signature help to be triggered.
---This is undefined when `triggerKind !== SignatureHelpTriggerKind.TriggerCharacter`
---@field triggerCharacter? string
---`true` if signature help was already showing when it was triggered.
---Retriggers occurs when the signature help is already active and can be caused by actions such as
---typing a trigger character, a cursor move, or document content changes.
---@field isRetrigger boolean
---The currently active `SignatureHelp`.
---The `activeSignatureHelp` has its `SignatureHelp.activeSignature` field updated based on
---the user navigating through available signatures.
---@field activeSignatureHelp? lsp.SignatureHelp

---Represents the signature of something callable. A signature
---can have a label, like a function-name, a doc-comment, and
---a set of parameters.
---@class lsp.SignatureInformation
---The label of this signature. Will be shown in
---the UI.
---@field label string
---The human-readable doc-comment of this signature. Will be shown
---in the UI but can be omitted.
---@field documentation? string | lsp.MarkupContent
---The parameters of this signature.
---@field parameters? (lsp.ParameterInformation)[]
---The index of the active parameter.
---If provided, this is used in place of `SignatureHelp.activeParameter`.
---@since 3.16.0
---@field activeParameter? integer

---Server Capabilities for a {@link SignatureHelpRequest}.
---@class lsp.SignatureHelpOptions : lsp.WorkDoneProgressOptions
---List of characters that trigger signature help automatically.
---@field triggerCharacters? (string)[]
---List of characters that re-trigger signature help.
---These trigger characters are only active when signature help is already showing. All trigger characters
---are also counted as re-trigger characters.
---@since 3.15.0
---@field retriggerCharacters? (string)[]

---Server Capabilities for a {@link DefinitionRequest}.
---@class lsp.DefinitionOptions : lsp.WorkDoneProgressOptions

---Value-object that contains additional information when
---requesting references.
---@class lsp.ReferenceContext
---Include the declaration of the current symbol.
---@field includeDeclaration boolean

---Reference options.
---@class lsp.ReferenceOptions : lsp.WorkDoneProgressOptions

---Provider options for a {@link DocumentHighlightRequest}.
---@class lsp.DocumentHighlightOptions : lsp.WorkDoneProgressOptions

---A base for all symbol information.
---@class lsp.BaseSymbolInformation
---The name of this symbol.
---@field name string
---The kind of this symbol.
---@field kind lsp.SymbolKind
---Tags for this symbol.
---@since 3.16.0
---@field tags? (lsp.SymbolTag)[]
---The name of the symbol containing this symbol. This information is for
---user interface purposes (e.g. to render a qualifier in the user interface
---if necessary). It can't be used to re-infer a hierarchy for the document
---symbols.
---@field containerName? string

---Provider options for a {@link DocumentSymbolRequest}.
---@class lsp.DocumentSymbolOptions : lsp.WorkDoneProgressOptions
---A human-readable string that is shown when multiple outlines trees
---are shown for the same document.
---@since 3.16.0
---@field label? string

---Contains additional diagnostic information about the context in which
---a {@link CodeActionProvider.provideCodeActions code action} is run.
---@class lsp.CodeActionContext
---An array of diagnostics known on the client side overlapping the range provided to the
---`textDocument/codeAction` request. They are provided so that the server knows which
---errors are currently presented to the user for the given range. There is no guarantee
---that these accurately reflect the error state of the resource. The primary parameter
---to compute code actions is the provided range.
---@field diagnostics (lsp.Diagnostic)[]
---Requested kind of actions to return.
---Actions not of this kind are filtered out by the client before being shown. So servers
---can omit computing them.
---@field only? (lsp.CodeActionKind)[]
---The reason why code actions were requested.
---@since 3.17.0
---@field triggerKind? lsp.CodeActionTriggerKind

---Provider options for a {@link CodeActionRequest}.
---@class lsp.CodeActionOptions : lsp.WorkDoneProgressOptions
---CodeActionKinds that this server may return.
---The list of kinds may be generic, such as `CodeActionKind.Refactor`, or the server
---may list out every specific kind they provide.
---@field codeActionKinds? (lsp.CodeActionKind)[]
---The server provides support to resolve additional
---information for a code action.
---@since 3.16.0
---@field resolveProvider? boolean

---Server capabilities for a {@link WorkspaceSymbolRequest}.
---@class lsp.WorkspaceSymbolOptions : lsp.WorkDoneProgressOptions
---The server provides support to resolve additional
---information for a workspace symbol.
---@since 3.17.0
---@field resolveProvider? boolean

---Code Lens provider options of a {@link CodeLensRequest}.
---@class lsp.CodeLensOptions : lsp.WorkDoneProgressOptions
---Code lens has a resolve provider as well.
---@field resolveProvider? boolean

---Provider options for a {@link DocumentLinkRequest}.
---@class lsp.DocumentLinkOptions : lsp.WorkDoneProgressOptions
---Document links have a resolve provider as well.
---@field resolveProvider? boolean

---Value-object describing what options formatting should use.
---@class lsp.FormattingOptions
---Size of a tab in spaces.
---@field tabSize integer
---Prefer spaces over tabs.
---@field insertSpaces boolean
---Trim trailing whitespace on a line.
---@since 3.15.0
---@field trimTrailingWhitespace? boolean
---Insert a newline character at the end of the file if one does not exist.
---@since 3.15.0
---@field insertFinalNewline? boolean
---Trim all newlines after the final newline at the end of the file.
---@since 3.15.0
---@field trimFinalNewlines? boolean

---Provider options for a {@link DocumentFormattingRequest}.
---@class lsp.DocumentFormattingOptions : lsp.WorkDoneProgressOptions

---Provider options for a {@link DocumentRangeFormattingRequest}.
---@class lsp.DocumentRangeFormattingOptions : lsp.WorkDoneProgressOptions
---Whether the server supports formatting multiple ranges at once.
---@since 3.18.0
---@proposed
---@field rangesSupport? boolean

---Provider options for a {@link DocumentOnTypeFormattingRequest}.
---@class lsp.DocumentOnTypeFormattingOptions
---A character on which formatting should be triggered, like `{`.
---@field firstTriggerCharacter string
---More trigger characters.
---@field moreTriggerCharacter? (string)[]

---Provider options for a {@link RenameRequest}.
---@class lsp.RenameOptions : lsp.WorkDoneProgressOptions
---Renames should be checked and tested before being executed.
---@since version 3.12.0
---@field prepareProvider? boolean

---The server capabilities of a {@link ExecuteCommandRequest}.
---@class lsp.ExecuteCommandOptions : lsp.WorkDoneProgressOptions
---The commands to be executed on the server
---@field commands (string)[]

---@since 3.16.0
---@class lsp.SemanticTokensLegend
---The token types a server uses.
---@field tokenTypes (string)[]
---The token modifiers a server uses.
---@field tokenModifiers (string)[]

---A text document identifier to optionally denote a specific version of a text document.
---@class lsp.OptionalVersionedTextDocumentIdentifier : lsp.TextDocumentIdentifier
---The version number of this document. If a versioned text document identifier
---is sent from the server to the client and the file is not open in the editor
---(the server has not received an open notification before) the server can send
---`null` to indicate that the version is unknown and the content on disk is the
---truth (as specified with document content ownership).
---@field version integer | cjson.null

---A special text edit with an additional change annotation.
---@since 3.16.0.
---@class lsp.AnnotatedTextEdit : lsp.TextEdit
---The actual identifier of the change annotation
---@field annotationId lsp.ChangeAnnotationIdentifier

---A generic resource operation.
---@class lsp.ResourceOperation
---The resource operation kind.
---@field kind string
---An optional annotation identifier describing the operation.
---@since 3.16.0
---@field annotationId? lsp.ChangeAnnotationIdentifier

---Options to create a file.
---@class lsp.CreateFileOptions
---Overwrite existing file. Overwrite wins over `ignoreIfExists`
---@field overwrite? boolean
---Ignore if exists.
---@field ignoreIfExists? boolean

---Rename file options
---@class lsp.RenameFileOptions
---Overwrite target if existing. Overwrite wins over `ignoreIfExists`
---@field overwrite? boolean
---Ignores if target exists.
---@field ignoreIfExists? boolean

---Delete file options
---@class lsp.DeleteFileOptions
---Delete the content recursively if a folder is denoted.
---@field recursive? boolean
---Ignore the operation if the file doesn't exist.
---@field ignoreIfNotExists? boolean

---A pattern to describe in which file operation requests or notifications
---the server is interested in receiving.
---@since 3.16.0
---@class lsp.FileOperationPattern
---The glob pattern to match. Glob patterns can have the following syntax:
---- `*` to match one or more characters in a path segment
---- `?` to match on one character in a path segment
---- `**` to match any number of path segments, including none
---- `{}` to group sub patterns into an OR expression. (e.g. `**​/*.{ts,js}` matches all TypeScript and JavaScript files)
---- `[]` to declare a range of characters to match in a path segment (e.g., `example.[0-9]` to match on `example.0`, `example.1`, …)
---- `[!...]` to negate a range of characters to match in a path segment (e.g., `example.[!0-9]` to match on `example.a`, `example.b`, but not `example.0`)
---@field glob string
---Whether to match files or folders with this pattern.
---Matches both if undefined.
---@field matches? lsp.FileOperationPatternKind
---Additional options used during matching.
---@field options? lsp.FileOperationPatternOptions

---A full document diagnostic report for a workspace diagnostic result.
---@since 3.17.0
---@class lsp.WorkspaceFullDocumentDiagnosticReport : lsp.FullDocumentDiagnosticReport
---The URI for which diagnostic information is reported.
---@field uri lsp.DocumentUri
---The version number for which the diagnostics are reported.
---If the document is not marked as open `null` can be provided.
---@field version integer | cjson.null

---An unchanged document diagnostic report for a workspace diagnostic result.
---@since 3.17.0
---@class lsp.WorkspaceUnchangedDocumentDiagnosticReport : lsp.UnchangedDocumentDiagnosticReport
---The URI for which diagnostic information is reported.
---@field uri lsp.DocumentUri
---The version number for which the diagnostics are reported.
---If the document is not marked as open `null` can be provided.
---@field version integer | cjson.null

---A notebook cell.
---A cell's document URI must be unique across ALL notebook
---cells and can therefore be used to uniquely identify a
---notebook cell or the cell's text document.
---@since 3.17.0
---@class lsp.NotebookCell
---The cell's kind
---@field kind lsp.NotebookCellKind
---The URI of the cell's text document
---content.
---@field document lsp.DocumentUri
---Additional metadata stored with the cell.
---Note: should always be an object literal (e.g. LSPObject)
---@field metadata? lsp.LSPObject
---Additional execution summary information
---if supported by the client.
---@field executionSummary? lsp.ExecutionSummary

---A change describing how to move a `NotebookCell`
---array from state S to S'.
---@since 3.17.0
---@class lsp.NotebookCellArrayChange
---The start oftest of the cell that changed.
---@field start integer
---The deleted cells
---@field deleteCount integer
---The new cells, if any
---@field cells? (lsp.NotebookCell)[]

---Describes the currently selected completion item.
---@since 3.18.0
---@proposed
---@class lsp.SelectedCompletionInfo
---The range that will be replaced if this completion item is accepted.
---@field range lsp.Range
---The text the range will be replaced with if this completion is accepted.
---@field text string

---Defines the capabilities provided by the client.
---@class lsp.ClientCapabilities
---Workspace specific client capabilities.
---@field workspace? lsp.WorkspaceClientCapabilities
---Text document specific client capabilities.
---@field textDocument? lsp.TextDocumentClientCapabilities
---Capabilities specific to the notebook document support.
---@since 3.17.0
---@field notebookDocument? lsp.NotebookDocumentClientCapabilities
---Window specific client capabilities.
---@field window? lsp.WindowClientCapabilities
---General client capabilities.
---@since 3.16.0
---@field general? lsp.GeneralClientCapabilities
---Experimental client capabilities.
---@field experimental? lsp.LSPAny

---@class lsp.TextDocumentSyncOptions
---Open and close notifications are sent to the server. If omitted open close notification should not
---be sent.
---@field openClose? boolean
---Change notifications are sent to the server. See TextDocumentSyncKind.None, TextDocumentSyncKind.Full
---and TextDocumentSyncKind.Incremental. If omitted it defaults to TextDocumentSyncKind.None.
---@field change? lsp.TextDocumentSyncKind
---If present will save notifications are sent to the server. If omitted the notification should not be
---sent.
---@field willSave? boolean
---If present will save wait until requests are sent to the server. If omitted the request should not be
---sent.
---@field willSaveWaitUntil? boolean
---If present save notifications are sent to the server. If omitted the notification should not be
---sent.
---@field save? boolean | lsp.SaveOptions

---Options specific to a notebook plus its cells
---to be synced to the server.
---If a selector provides a notebook document
---filter but no cell selector all cells of a
---matching notebook document will be synced.
---If a selector provides no notebook document
---filter but only a cell selector all notebook
---document that contain at least one matching
---cell will be synced.
---@since 3.17.0
---@class lsp.NotebookDocumentSyncOptions
---The notebooks to be synced
---@field notebookSelector (lsp.NotebookDocumentSyncOptions.notebookSelector.1 | lsp.NotebookDocumentSyncOptions.notebookSelector.2)[]
---Whether save notification should be forwarded to
---the server. Will only be honored if mode === `notebook`.
---@field save? boolean

---Registration options specific to a notebook.
---@since 3.17.0
---@class lsp.NotebookDocumentSyncRegistrationOptions : lsp.NotebookDocumentSyncOptions, lsp.StaticRegistrationOptions

---@class lsp.WorkspaceFoldersServerCapabilities
---The server has support for workspace folders
---@field supported? boolean
---Whether the server wants to receive workspace folder
---change notifications.
---If a string is provided the string is treated as an ID
---under which the notification is registered on the client
---side. The ID can be used to unregister for these events
---using the `client/unregisterCapability` request.
---@field changeNotifications? string | boolean

---Options for notifications/requests for user operations on files.
---@since 3.16.0
---@class lsp.FileOperationOptions
---The server is interested in receiving didCreateFiles notifications.
---@field didCreate? lsp.FileOperationRegistrationOptions
---The server is interested in receiving willCreateFiles requests.
---@field willCreate? lsp.FileOperationRegistrationOptions
---The server is interested in receiving didRenameFiles notifications.
---@field didRename? lsp.FileOperationRegistrationOptions
---The server is interested in receiving willRenameFiles requests.
---@field willRename? lsp.FileOperationRegistrationOptions
---The server is interested in receiving didDeleteFiles file notifications.
---@field didDelete? lsp.FileOperationRegistrationOptions
---The server is interested in receiving willDeleteFiles file requests.
---@field willDelete? lsp.FileOperationRegistrationOptions

---Structure to capture a description for an error code.
---@since 3.16.0
---@class lsp.CodeDescription
---An URI to open with more information about the diagnostic error.
---@field href lsp.URI

---Represents a related message and source code location for a diagnostic. This should be
---used to point to code locations that cause or related to a diagnostics, e.g when duplicating
---a symbol in a scope.
---@class lsp.DiagnosticRelatedInformation
---The location of this related diagnostic information.
---@field location lsp.Location
---The message of this related diagnostic information.
---@field message string

---Represents a parameter of a callable-signature. A parameter can
---have a label and a doc-comment.
---@class lsp.ParameterInformation
---The label of this parameter information.
---Either a string or an inclusive start and exclusive end offsets within its containing
---signature label. (see SignatureInformation.label). The offsets are based on a UTF-16
---string representation as `Position` and `Range` does.
---*Note*: a label of type string should be a substring of its containing signature label.
---Its intended use case is to highlight the parameter label part in the `SignatureInformation.label`.
---@field label string | { [1]: integer, [2]: integer, }
---The human-readable doc-comment of this parameter. Will be shown
---in the UI but can be omitted.
---@field documentation? string | lsp.MarkupContent

---A notebook cell text document filter denotes a cell text
---document by different properties.
---@since 3.17.0
---@class lsp.NotebookCellTextDocumentFilter
---A filter that matches against the notebook
---containing the notebook cell. If a string
---value is provided it matches against the
---notebook type. '*' matches every notebook.
---@field notebook string | lsp.NotebookDocumentFilter
---A language id like `python`.
---Will be matched against the language id of the
---notebook cell document. '*' matches every language.
---@field language? string

---Matching options for the file operation pattern.
---@since 3.16.0
---@class lsp.FileOperationPatternOptions
---The pattern should be matched ignoring casing.
---@field ignoreCase? boolean

---@class lsp.ExecutionSummary
---A strict monotonically increasing value
---indicating the execution order of a cell
---inside a notebook.
---@field executionOrder integer
---Whether the execution was successful or
---not if known by the client.
---@field success? boolean

---Workspace specific client capabilities.
---@class lsp.WorkspaceClientCapabilities
---The client supports applying batch edits
---to the workspace by supporting the request
---'workspace/applyEdit'
---@field applyEdit? boolean
---Capabilities specific to `WorkspaceEdit`s.
---@field workspaceEdit? lsp.WorkspaceEditClientCapabilities
---Capabilities specific to the `workspace/didChangeConfiguration` notification.
---@field didChangeConfiguration? lsp.DidChangeConfigurationClientCapabilities
---Capabilities specific to the `workspace/didChangeWatchedFiles` notification.
---@field didChangeWatchedFiles? lsp.DidChangeWatchedFilesClientCapabilities
---Capabilities specific to the `workspace/symbol` request.
---@field symbol? lsp.WorkspaceSymbolClientCapabilities
---Capabilities specific to the `workspace/executeCommand` request.
---@field executeCommand? lsp.ExecuteCommandClientCapabilities
---The client has support for workspace folders.
---@since 3.6.0
---@field workspaceFolders? boolean
---The client supports `workspace/configuration` requests.
---@since 3.6.0
---@field configuration? boolean
---Capabilities specific to the semantic token requests scoped to the
---workspace.
---@since 3.16.0.
---@field semanticTokens? lsp.SemanticTokensWorkspaceClientCapabilities
---Capabilities specific to the code lens requests scoped to the
---workspace.
---@since 3.16.0.
---@field codeLens? lsp.CodeLensWorkspaceClientCapabilities
---The client has support for file notifications/requests for user operations on files.
---Since 3.16.0
---@field fileOperations? lsp.FileOperationClientCapabilities
---Capabilities specific to the inline values requests scoped to the
---workspace.
---@since 3.17.0.
---@field inlineValue? lsp.InlineValueWorkspaceClientCapabilities
---Capabilities specific to the inlay hint requests scoped to the
---workspace.
---@since 3.17.0.
---@field inlayHint? lsp.InlayHintWorkspaceClientCapabilities
---Capabilities specific to the diagnostic requests scoped to the
---workspace.
---@since 3.17.0.
---@field diagnostics? lsp.DiagnosticWorkspaceClientCapabilities
---Capabilities specific to the folding range requests scoped to the workspace.
---@since 3.18.0
---@proposed
---@field foldingRange? lsp.FoldingRangeWorkspaceClientCapabilities

---Text document specific client capabilities.
---@class lsp.TextDocumentClientCapabilities
---Defines which synchronization capabilities the client supports.
---@field synchronization? lsp.TextDocumentSyncClientCapabilities
---Capabilities specific to the `textDocument/completion` request.
---@field completion? lsp.CompletionClientCapabilities
---Capabilities specific to the `textDocument/hover` request.
---@field hover? lsp.HoverClientCapabilities
---Capabilities specific to the `textDocument/signatureHelp` request.
---@field signatureHelp? lsp.SignatureHelpClientCapabilities
---Capabilities specific to the `textDocument/declaration` request.
---@since 3.14.0
---@field declaration? lsp.DeclarationClientCapabilities
---Capabilities specific to the `textDocument/definition` request.
---@field definition? lsp.DefinitionClientCapabilities
---Capabilities specific to the `textDocument/typeDefinition` request.
---@since 3.6.0
---@field typeDefinition? lsp.TypeDefinitionClientCapabilities
---Capabilities specific to the `textDocument/implementation` request.
---@since 3.6.0
---@field implementation? lsp.ImplementationClientCapabilities
---Capabilities specific to the `textDocument/references` request.
---@field references? lsp.ReferenceClientCapabilities
---Capabilities specific to the `textDocument/documentHighlight` request.
---@field documentHighlight? lsp.DocumentHighlightClientCapabilities
---Capabilities specific to the `textDocument/documentSymbol` request.
---@field documentSymbol? lsp.DocumentSymbolClientCapabilities
---Capabilities specific to the `textDocument/codeAction` request.
---@field codeAction? lsp.CodeActionClientCapabilities
---Capabilities specific to the `textDocument/codeLens` request.
---@field codeLens? lsp.CodeLensClientCapabilities
---Capabilities specific to the `textDocument/documentLink` request.
---@field documentLink? lsp.DocumentLinkClientCapabilities
---Capabilities specific to the `textDocument/documentColor` and the
---`textDocument/colorPresentation` request.
---@since 3.6.0
---@field colorProvider? lsp.DocumentColorClientCapabilities
---Capabilities specific to the `textDocument/formatting` request.
---@field formatting? lsp.DocumentFormattingClientCapabilities
---Capabilities specific to the `textDocument/rangeFormatting` request.
---@field rangeFormatting? lsp.DocumentRangeFormattingClientCapabilities
---Capabilities specific to the `textDocument/onTypeFormatting` request.
---@field onTypeFormatting? lsp.DocumentOnTypeFormattingClientCapabilities
---Capabilities specific to the `textDocument/rename` request.
---@field rename? lsp.RenameClientCapabilities
---Capabilities specific to the `textDocument/foldingRange` request.
---@since 3.10.0
---@field foldingRange? lsp.FoldingRangeClientCapabilities
---Capabilities specific to the `textDocument/selectionRange` request.
---@since 3.15.0
---@field selectionRange? lsp.SelectionRangeClientCapabilities
---Capabilities specific to the `textDocument/publishDiagnostics` notification.
---@field publishDiagnostics? lsp.PublishDiagnosticsClientCapabilities
---Capabilities specific to the various call hierarchy requests.
---@since 3.16.0
---@field callHierarchy? lsp.CallHierarchyClientCapabilities
---Capabilities specific to the various semantic token request.
---@since 3.16.0
---@field semanticTokens? lsp.SemanticTokensClientCapabilities
---Capabilities specific to the `textDocument/linkedEditingRange` request.
---@since 3.16.0
---@field linkedEditingRange? lsp.LinkedEditingRangeClientCapabilities
---Client capabilities specific to the `textDocument/moniker` request.
---@since 3.16.0
---@field moniker? lsp.MonikerClientCapabilities
---Capabilities specific to the various type hierarchy requests.
---@since 3.17.0
---@field typeHierarchy? lsp.TypeHierarchyClientCapabilities
---Capabilities specific to the `textDocument/inlineValue` request.
---@since 3.17.0
---@field inlineValue? lsp.InlineValueClientCapabilities
---Capabilities specific to the `textDocument/inlayHint` request.
---@since 3.17.0
---@field inlayHint? lsp.InlayHintClientCapabilities
---Capabilities specific to the diagnostic pull model.
---@since 3.17.0
---@field diagnostic? lsp.DiagnosticClientCapabilities
---Client capabilities specific to inline completions.
---@since 3.18.0
---@proposed
---@field inlineCompletion? lsp.InlineCompletionClientCapabilities

---Capabilities specific to the notebook document support.
---@since 3.17.0
---@class lsp.NotebookDocumentClientCapabilities
---Capabilities specific to notebook document synchronization
---@since 3.17.0
---@field synchronization lsp.NotebookDocumentSyncClientCapabilities

---@class lsp.WindowClientCapabilities
---It indicates whether the client supports server initiated
---progress using the `window/workDoneProgress/create` request.
---The capability also controls Whether client supports handling
---of progress notifications. If set servers are allowed to report a
---`workDoneProgress` property in the request specific server
---capabilities.
---@since 3.15.0
---@field workDoneProgress? boolean
---Capabilities specific to the showMessage request.
---@since 3.16.0
---@field showMessage? lsp.ShowMessageRequestClientCapabilities
---Capabilities specific to the showDocument request.
---@since 3.16.0
---@field showDocument? lsp.ShowDocumentClientCapabilities

---General client capabilities.
---@since 3.16.0
---@class lsp.GeneralClientCapabilities
---Client capability that signals how the client
---handles stale requests (e.g. a request
---for which the client will not process the response
---anymore since the information is outdated).
---@since 3.17.0
---@field staleRequestSupport? lsp.GeneralClientCapabilities.staleRequestSupport
---Client capabilities specific to regular expressions.
---@since 3.16.0
---@field regularExpressions? lsp.RegularExpressionsClientCapabilities
---Client capabilities specific to the client's markdown parser.
---@since 3.16.0
---@field markdown? lsp.MarkdownClientCapabilities
---The position encodings supported by the client. Client and server
---have to agree on the same position encoding to ensure that offsets
---(e.g. character position in a line) are interpreted the same on both
---sides.
---To keep the protocol backwards compatible the following applies: if
---the value 'utf-16' is missing from the array of position encodings
---servers can assume that the client supports UTF-16. UTF-16 is
---therefore a mandatory encoding.
---If omitted it defaults to ['utf-16'].
---Implementation considerations: since the conversion from one encoding
---into another requires the content of the file / line the conversion
---is best done where the file is read which is usually on the server
---side.
---@since 3.17.0
---@field positionEncodings? (lsp.PositionEncodingKind)[]

---A relative pattern is a helper to construct glob patterns that are matched
---relatively to a base URI. The common value for a `baseUri` is a workspace
---folder root, but it can be another absolute URI as well.
---@since 3.17.0
---@class lsp.RelativePattern
---A workspace folder or a base URI to which this pattern will be matched
---against relatively.
---@field baseUri lsp.WorkspaceFolder | lsp.URI
---The actual glob pattern;
---@field pattern lsp.Pattern

---@class lsp.WorkspaceEditClientCapabilities
---The client supports versioned document changes in `WorkspaceEdit`s
---@field documentChanges? boolean
---The resource operations the client supports. Clients should at least
---support 'create', 'rename' and 'delete' files and folders.
---@since 3.13.0
---@field resourceOperations? (lsp.ResourceOperationKind)[]
---The failure handling strategy of a client if applying the workspace edit
---fails.
---@since 3.13.0
---@field failureHandling? lsp.FailureHandlingKind
---Whether the client normalizes line endings to the client specific
---setting.
---If set to `true` the client will normalize line ending characters
---in a workspace edit to the client-specified new line
---character.
---@since 3.16.0
---@field normalizesLineEndings? boolean
---Whether the client in general supports change annotations on text edits,
---create file, rename file and delete file changes.
---@since 3.16.0
---@field changeAnnotationSupport? lsp.WorkspaceEditClientCapabilities.changeAnnotationSupport

---@class lsp.DidChangeConfigurationClientCapabilities
---Did change configuration notification supports dynamic registration.
---@field dynamicRegistration? boolean

---@class lsp.DidChangeWatchedFilesClientCapabilities
---Did change watched files notification supports dynamic registration. Please note
---that the current protocol doesn't support static configuration for file changes
---from the server side.
---@field dynamicRegistration? boolean
---Whether the client has support for {@link  RelativePattern relative pattern}
---or not.
---@since 3.17.0
---@field relativePatternSupport? boolean

---Client capabilities for a {@link WorkspaceSymbolRequest}.
---@class lsp.WorkspaceSymbolClientCapabilities
---Symbol request supports dynamic registration.
---@field dynamicRegistration? boolean
---Specific capabilities for the `SymbolKind` in the `workspace/symbol` request.
---@field symbolKind? lsp.WorkspaceSymbolClientCapabilities.symbolKind
---The client supports tags on `SymbolInformation`.
---Clients supporting tags have to handle unknown tags gracefully.
---@since 3.16.0
---@field tagSupport? lsp.WorkspaceSymbolClientCapabilities.tagSupport
---The client support partial workspace symbols. The client will send the
---request `workspaceSymbol/resolve` to the server to resolve additional
---properties.
---@since 3.17.0
---@field resolveSupport? lsp.WorkspaceSymbolClientCapabilities.resolveSupport

---The client capabilities of a {@link ExecuteCommandRequest}.
---@class lsp.ExecuteCommandClientCapabilities
---Execute command supports dynamic registration.
---@field dynamicRegistration? boolean

---@since 3.16.0
---@class lsp.SemanticTokensWorkspaceClientCapabilities
---Whether the client implementation supports a refresh request sent from
---the server to the client.
---Note that this event is global and will force the client to refresh all
---semantic tokens currently shown. It should be used with absolute care
---and is useful for situation where a server for example detects a project
---wide change that requires such a calculation.
---@field refreshSupport? boolean

---@since 3.16.0
---@class lsp.CodeLensWorkspaceClientCapabilities
---Whether the client implementation supports a refresh request sent from the
---server to the client.
---Note that this event is global and will force the client to refresh all
---code lenses currently shown. It should be used with absolute care and is
---useful for situation where a server for example detect a project wide
---change that requires such a calculation.
---@field refreshSupport? boolean

---Capabilities relating to events from file operations by the user in the client.
---These events do not come from the file system, they come from user operations
---like renaming a file in the UI.
---@since 3.16.0
---@class lsp.FileOperationClientCapabilities
---Whether the client supports dynamic registration for file requests/notifications.
---@field dynamicRegistration? boolean
---The client has support for sending didCreateFiles notifications.
---@field didCreate? boolean
---The client has support for sending willCreateFiles requests.
---@field willCreate? boolean
---The client has support for sending didRenameFiles notifications.
---@field didRename? boolean
---The client has support for sending willRenameFiles requests.
---@field willRename? boolean
---The client has support for sending didDeleteFiles notifications.
---@field didDelete? boolean
---The client has support for sending willDeleteFiles requests.
---@field willDelete? boolean

---Client workspace capabilities specific to inline values.
---@since 3.17.0
---@class lsp.InlineValueWorkspaceClientCapabilities
---Whether the client implementation supports a refresh request sent from the
---server to the client.
---Note that this event is global and will force the client to refresh all
---inline values currently shown. It should be used with absolute care and is
---useful for situation where a server for example detects a project wide
---change that requires such a calculation.
---@field refreshSupport? boolean

---Client workspace capabilities specific to inlay hints.
---@since 3.17.0
---@class lsp.InlayHintWorkspaceClientCapabilities
---Whether the client implementation supports a refresh request sent from
---the server to the client.
---Note that this event is global and will force the client to refresh all
---inlay hints currently shown. It should be used with absolute care and
---is useful for situation where a server for example detects a project wide
---change that requires such a calculation.
---@field refreshSupport? boolean

---Workspace client capabilities specific to diagnostic pull requests.
---@since 3.17.0
---@class lsp.DiagnosticWorkspaceClientCapabilities
---Whether the client implementation supports a refresh request sent from
---the server to the client.
---Note that this event is global and will force the client to refresh all
---pulled diagnostics currently shown. It should be used with absolute care and
---is useful for situation where a server for example detects a project wide
---change that requires such a calculation.
---@field refreshSupport? boolean

---Client workspace capabilities specific to folding ranges
---@since 3.18.0
---@proposed
---@class lsp.FoldingRangeWorkspaceClientCapabilities
---Whether the client implementation supports a refresh request sent from the
---server to the client.
---Note that this event is global and will force the client to refresh all
---folding ranges currently shown. It should be used with absolute care and is
---useful for situation where a server for example detects a project wide
---change that requires such a calculation.
---@since 3.18.0
---@proposed
---@field refreshSupport? boolean

---@class lsp.TextDocumentSyncClientCapabilities
---Whether text document synchronization supports dynamic registration.
---@field dynamicRegistration? boolean
---The client supports sending will save notifications.
---@field willSave? boolean
---The client supports sending a will save request and
---waits for a response providing text edits which will
---be applied to the document before it is saved.
---@field willSaveWaitUntil? boolean
---The client supports did save notifications.
---@field didSave? boolean

---Completion client capabilities
---@class lsp.CompletionClientCapabilities
---Whether completion supports dynamic registration.
---@field dynamicRegistration? boolean
---The client supports the following `CompletionItem` specific
---capabilities.
---@field completionItem? lsp.CompletionClientCapabilities.completionItem
---@field completionItemKind? lsp.CompletionClientCapabilities.completionItemKind
---Defines how the client handles whitespace and indentation
---when accepting a completion item that uses multi line
---text in either `insertText` or `textEdit`.
---@since 3.17.0
---@field insertTextMode? lsp.InsertTextMode
---The client supports to send additional context information for a
---`textDocument/completion` request.
---@field contextSupport? boolean
---The client supports the following `CompletionList` specific
---capabilities.
---@since 3.17.0
---@field completionList? lsp.CompletionClientCapabilities.completionList

---@class lsp.HoverClientCapabilities
---Whether hover supports dynamic registration.
---@field dynamicRegistration? boolean
---Client supports the following content formats for the content
---property. The order describes the preferred format of the client.
---@field contentFormat? (lsp.MarkupKind)[]

---Client Capabilities for a {@link SignatureHelpRequest}.
---@class lsp.SignatureHelpClientCapabilities
---Whether signature help supports dynamic registration.
---@field dynamicRegistration? boolean
---The client supports the following `SignatureInformation`
---specific properties.
---@field signatureInformation? lsp.SignatureHelpClientCapabilities.signatureInformation
---The client supports to send additional context information for a
---`textDocument/signatureHelp` request. A client that opts into
---contextSupport will also support the `retriggerCharacters` on
---`SignatureHelpOptions`.
---@since 3.15.0
---@field contextSupport? boolean

---@since 3.14.0
---@class lsp.DeclarationClientCapabilities
---Whether declaration supports dynamic registration. If this is set to `true`
---the client supports the new `DeclarationRegistrationOptions` return value
---for the corresponding server capability as well.
---@field dynamicRegistration? boolean
---The client supports additional metadata in the form of declaration links.
---@field linkSupport? boolean

---Client Capabilities for a {@link DefinitionRequest}.
---@class lsp.DefinitionClientCapabilities
---Whether definition supports dynamic registration.
---@field dynamicRegistration? boolean
---The client supports additional metadata in the form of definition links.
---@since 3.14.0
---@field linkSupport? boolean

---Since 3.6.0
---@class lsp.TypeDefinitionClientCapabilities
---Whether implementation supports dynamic registration. If this is set to `true`
---the client supports the new `TypeDefinitionRegistrationOptions` return value
---for the corresponding server capability as well.
---@field dynamicRegistration? boolean
---The client supports additional metadata in the form of definition links.
---Since 3.14.0
---@field linkSupport? boolean

---@since 3.6.0
---@class lsp.ImplementationClientCapabilities
---Whether implementation supports dynamic registration. If this is set to `true`
---the client supports the new `ImplementationRegistrationOptions` return value
---for the corresponding server capability as well.
---@field dynamicRegistration? boolean
---The client supports additional metadata in the form of definition links.
---@since 3.14.0
---@field linkSupport? boolean

---Client Capabilities for a {@link ReferencesRequest}.
---@class lsp.ReferenceClientCapabilities
---Whether references supports dynamic registration.
---@field dynamicRegistration? boolean

---Client Capabilities for a {@link DocumentHighlightRequest}.
---@class lsp.DocumentHighlightClientCapabilities
---Whether document highlight supports dynamic registration.
---@field dynamicRegistration? boolean

---Client Capabilities for a {@link DocumentSymbolRequest}.
---@class lsp.DocumentSymbolClientCapabilities
---Whether document symbol supports dynamic registration.
---@field dynamicRegistration? boolean
---Specific capabilities for the `SymbolKind` in the
---`textDocument/documentSymbol` request.
---@field symbolKind? lsp.DocumentSymbolClientCapabilities.symbolKind
---The client supports hierarchical document symbols.
---@field hierarchicalDocumentSymbolSupport? boolean
---The client supports tags on `SymbolInformation`. Tags are supported on
---`DocumentSymbol` if `hierarchicalDocumentSymbolSupport` is set to true.
---Clients supporting tags have to handle unknown tags gracefully.
---@since 3.16.0
---@field tagSupport? lsp.DocumentSymbolClientCapabilities.tagSupport
---The client supports an additional label presented in the UI when
---registering a document symbol provider.
---@since 3.16.0
---@field labelSupport? boolean

---The Client Capabilities of a {@link CodeActionRequest}.
---@class lsp.CodeActionClientCapabilities
---Whether code action supports dynamic registration.
---@field dynamicRegistration? boolean
---The client support code action literals of type `CodeAction` as a valid
---response of the `textDocument/codeAction` request. If the property is not
---set the request can only return `Command` literals.
---@since 3.8.0
---@field codeActionLiteralSupport? lsp.CodeActionClientCapabilities.codeActionLiteralSupport
---Whether code action supports the `isPreferred` property.
---@since 3.15.0
---@field isPreferredSupport? boolean
---Whether code action supports the `disabled` property.
---@since 3.16.0
---@field disabledSupport? boolean
---Whether code action supports the `data` property which is
---preserved between a `textDocument/codeAction` and a
---`codeAction/resolve` request.
---@since 3.16.0
---@field dataSupport? boolean
---Whether the client supports resolving additional code action
---properties via a separate `codeAction/resolve` request.
---@since 3.16.0
---@field resolveSupport? lsp.CodeActionClientCapabilities.resolveSupport
---Whether the client honors the change annotations in
---text edits and resource operations returned via the
---`CodeAction#edit` property by for example presenting
---the workspace edit in the user interface and asking
---for confirmation.
---@since 3.16.0
---@field honorsChangeAnnotations? boolean

---The client capabilities  of a {@link CodeLensRequest}.
---@class lsp.CodeLensClientCapabilities
---Whether code lens supports dynamic registration.
---@field dynamicRegistration? boolean

---The client capabilities of a {@link DocumentLinkRequest}.
---@class lsp.DocumentLinkClientCapabilities
---Whether document link supports dynamic registration.
---@field dynamicRegistration? boolean
---Whether the client supports the `tooltip` property on `DocumentLink`.
---@since 3.15.0
---@field tooltipSupport? boolean

---@class lsp.DocumentColorClientCapabilities
---Whether implementation supports dynamic registration. If this is set to `true`
---the client supports the new `DocumentColorRegistrationOptions` return value
---for the corresponding server capability as well.
---@field dynamicRegistration? boolean

---Client capabilities of a {@link DocumentFormattingRequest}.
---@class lsp.DocumentFormattingClientCapabilities
---Whether formatting supports dynamic registration.
---@field dynamicRegistration? boolean

---Client capabilities of a {@link DocumentRangeFormattingRequest}.
---@class lsp.DocumentRangeFormattingClientCapabilities
---Whether range formatting supports dynamic registration.
---@field dynamicRegistration? boolean
---Whether the client supports formatting multiple ranges at once.
---@since 3.18.0
---@proposed
---@field rangesSupport? boolean

---Client capabilities of a {@link DocumentOnTypeFormattingRequest}.
---@class lsp.DocumentOnTypeFormattingClientCapabilities
---Whether on type formatting supports dynamic registration.
---@field dynamicRegistration? boolean

---@class lsp.RenameClientCapabilities
---Whether rename supports dynamic registration.
---@field dynamicRegistration? boolean
---Client supports testing for validity of rename operations
---before execution.
---@since 3.12.0
---@field prepareSupport? boolean
---Client supports the default behavior result.
---The value indicates the default behavior used by the
---client.
---@since 3.16.0
---@field prepareSupportDefaultBehavior? lsp.PrepareSupportDefaultBehavior
---Whether the client honors the change annotations in
---text edits and resource operations returned via the
---rename request's workspace edit by for example presenting
---the workspace edit in the user interface and asking
---for confirmation.
---@since 3.16.0
---@field honorsChangeAnnotations? boolean

---@class lsp.FoldingRangeClientCapabilities
---Whether implementation supports dynamic registration for folding range
---providers. If this is set to `true` the client supports the new
---`FoldingRangeRegistrationOptions` return value for the corresponding
---server capability as well.
---@field dynamicRegistration? boolean
---The maximum number of folding ranges that the client prefers to receive
---per document. The value serves as a hint, servers are free to follow the
---limit.
---@field rangeLimit? integer
---If set, the client signals that it only supports folding complete lines.
---If set, client will ignore specified `startCharacter` and `endCharacter`
---properties in a FoldingRange.
---@field lineFoldingOnly? boolean
---Specific options for the folding range kind.
---@since 3.17.0
---@field foldingRangeKind? lsp.FoldingRangeClientCapabilities.foldingRangeKind
---Specific options for the folding range.
---@since 3.17.0
---@field foldingRange? lsp.FoldingRangeClientCapabilities.foldingRange

---@class lsp.SelectionRangeClientCapabilities
---Whether implementation supports dynamic registration for selection range providers. If this is set to `true`
---the client supports the new `SelectionRangeRegistrationOptions` return value for the corresponding server
---capability as well.
---@field dynamicRegistration? boolean

---The publish diagnostic client capabilities.
---@class lsp.PublishDiagnosticsClientCapabilities
---Whether the clients accepts diagnostics with related information.
---@field relatedInformation? boolean
---Client supports the tag property to provide meta data about a diagnostic.
---Clients supporting tags have to handle unknown tags gracefully.
---@since 3.15.0
---@field tagSupport? lsp.PublishDiagnosticsClientCapabilities.tagSupport
---Whether the client interprets the version property of the
---`textDocument/publishDiagnostics` notification's parameter.
---@since 3.15.0
---@field versionSupport? boolean
---Client supports a codeDescription property
---@since 3.16.0
---@field codeDescriptionSupport? boolean
---Whether code action supports the `data` property which is
---preserved between a `textDocument/publishDiagnostics` and
---`textDocument/codeAction` request.
---@since 3.16.0
---@field dataSupport? boolean

---@since 3.16.0
---@class lsp.CallHierarchyClientCapabilities
---Whether implementation supports dynamic registration. If this is set to `true`
---the client supports the new `(TextDocumentRegistrationOptions & StaticRegistrationOptions)`
---return value for the corresponding server capability as well.
---@field dynamicRegistration? boolean

---@since 3.16.0
---@class lsp.SemanticTokensClientCapabilities
---Whether implementation supports dynamic registration. If this is set to `true`
---the client supports the new `(TextDocumentRegistrationOptions & StaticRegistrationOptions)`
---return value for the corresponding server capability as well.
---@field dynamicRegistration? boolean
---Which requests the client supports and might send to the server
---depending on the server's capability. Please note that clients might not
---show semantic tokens or degrade some of the user experience if a range
---or full request is advertised by the client but not provided by the
---server. If for example the client capability `requests.full` and
---`request.range` are both set to true but the server only provides a
---range provider the client might not render a minimap correctly or might
---even decide to not show any semantic tokens at all.
---@field requests lsp.SemanticTokensClientCapabilities.requests
---The token types that the client supports.
---@field tokenTypes (string)[]
---The token modifiers that the client supports.
---@field tokenModifiers (string)[]
---The token formats the clients supports.
---@field formats (lsp.TokenFormat)[]
---Whether the client supports tokens that can overlap each other.
---@field overlappingTokenSupport? boolean
---Whether the client supports tokens that can span multiple lines.
---@field multilineTokenSupport? boolean
---Whether the client allows the server to actively cancel a
---semantic token request, e.g. supports returning
---LSPErrorCodes.ServerCancelled. If a server does the client
---needs to retrigger the request.
---@since 3.17.0
---@field serverCancelSupport? boolean
---Whether the client uses semantic tokens to augment existing
---syntax tokens. If set to `true` client side created syntax
---tokens and semantic tokens are both used for colorization. If
---set to `false` the client only uses the returned semantic tokens
---for colorization.
---If the value is `undefined` then the client behavior is not
---specified.
---@since 3.17.0
---@field augmentsSyntaxTokens? boolean

---Client capabilities for the linked editing range request.
---@since 3.16.0
---@class lsp.LinkedEditingRangeClientCapabilities
---Whether implementation supports dynamic registration. If this is set to `true`
---the client supports the new `(TextDocumentRegistrationOptions & StaticRegistrationOptions)`
---return value for the corresponding server capability as well.
---@field dynamicRegistration? boolean

---Client capabilities specific to the moniker request.
---@since 3.16.0
---@class lsp.MonikerClientCapabilities
---Whether moniker supports dynamic registration. If this is set to `true`
---the client supports the new `MonikerRegistrationOptions` return value
---for the corresponding server capability as well.
---@field dynamicRegistration? boolean

---@since 3.17.0
---@class lsp.TypeHierarchyClientCapabilities
---Whether implementation supports dynamic registration. If this is set to `true`
---the client supports the new `(TextDocumentRegistrationOptions & StaticRegistrationOptions)`
---return value for the corresponding server capability as well.
---@field dynamicRegistration? boolean

---Client capabilities specific to inline values.
---@since 3.17.0
---@class lsp.InlineValueClientCapabilities
---Whether implementation supports dynamic registration for inline value providers.
---@field dynamicRegistration? boolean

---Inlay hint client capabilities.
---@since 3.17.0
---@class lsp.InlayHintClientCapabilities
---Whether inlay hints support dynamic registration.
---@field dynamicRegistration? boolean
---Indicates which properties a client can resolve lazily on an inlay
---hint.
---@field resolveSupport? lsp.InlayHintClientCapabilities.resolveSupport

---Client capabilities specific to diagnostic pull requests.
---@since 3.17.0
---@class lsp.DiagnosticClientCapabilities
---Whether implementation supports dynamic registration. If this is set to `true`
---the client supports the new `(TextDocumentRegistrationOptions & StaticRegistrationOptions)`
---return value for the corresponding server capability as well.
---@field dynamicRegistration? boolean
---Whether the clients supports related documents for document diagnostic pulls.
---@field relatedDocumentSupport? boolean

---Client capabilities specific to inline completions.
---@since 3.18.0
---@proposed
---@class lsp.InlineCompletionClientCapabilities
---Whether implementation supports dynamic registration for inline completion providers.
---@field dynamicRegistration? boolean

---Notebook specific client capabilities.
---@since 3.17.0
---@class lsp.NotebookDocumentSyncClientCapabilities
---Whether implementation supports dynamic registration. If this is
---set to `true` the client supports the new
---`(TextDocumentRegistrationOptions & StaticRegistrationOptions)`
---return value for the corresponding server capability as well.
---@field dynamicRegistration? boolean
---The client supports sending execution summary data per cell.
---@field executionSummarySupport? boolean

---Show message request client capabilities
---@class lsp.ShowMessageRequestClientCapabilities
---Capabilities specific to the `MessageActionItem` type.
---@field messageActionItem? lsp.ShowMessageRequestClientCapabilities.messageActionItem

---Client capabilities for the showDocument request.
---@since 3.16.0
---@class lsp.ShowDocumentClientCapabilities
---The client has support for the showDocument
---request.
---@field support boolean

---Client capabilities specific to regular expressions.
---@since 3.16.0
---@class lsp.RegularExpressionsClientCapabilities
---The engine's name.
---@field engine string
---The engine's version.
---@field version? string

---Client capabilities specific to the used markdown parser.
---@since 3.16.0
---@class lsp.MarkdownClientCapabilities
---The name of the parser.
---@field parser string
---The version of the parser.
---@field version? string
---A list of HTML tags that the client allows / supports in
---Markdown.
---@since 3.17.0
---@field allowedTags? (string)[]

---The definition of a symbol represented as one or many {@link Location locations}.
---For most programming languages there is only one location at which a symbol is
---defined.
---Servers should prefer returning `DefinitionLink` over `Definition` if supported
---by the client.
---@alias lsp.Definition lsp.Location | (lsp.Location)[]

---Information about where a symbol is defined.
---Provides additional metadata over normal {@link Location location} definitions, including the range of
---the defining symbol
---@alias lsp.DefinitionLink lsp.LocationLink

---LSP arrays.
---@since 3.17.0
---@alias lsp.LSPArray (lsp.LSPAny)[]

---The LSP any type.
---Please note that strictly speaking a property with the value `undefined`
---can't be converted into JSON preserving the property name. However for
---convenience it is allowed and assumed that all these properties are
---optional as well.
---@since 3.17.0
---@alias lsp.LSPAny lsp.LSPObject | lsp.LSPArray | string | integer | integer | number | boolean | cjson.null

---The declaration of a symbol representation as one or many {@link Location locations}.
---@alias lsp.Declaration lsp.Location | (lsp.Location)[]

---Information about where a symbol is declared.
---Provides additional metadata over normal {@link Location location} declarations, including the range of
---the declaring symbol.
---Servers should prefer returning `DeclarationLink` over `Declaration` if supported
---by the client.
---@alias lsp.DeclarationLink lsp.LocationLink

---Inline value information can be provided by different means:
---- directly as a text value (class InlineValueText).
---- as a name to use for a variable lookup (class InlineValueVariableLookup)
---- as an evaluatable expression (class InlineValueEvaluatableExpression)
---The InlineValue types combines all inline value types into one type.
---@since 3.17.0
---@alias lsp.InlineValue lsp.InlineValueText | lsp.InlineValueVariableLookup | lsp.InlineValueEvaluatableExpression

---The result of a document diagnostic pull request. A report can
---either be a full report containing all diagnostics for the
---requested document or an unchanged report indicating that nothing
---has changed in terms of diagnostics in comparison to the last
---pull request.
---@since 3.17.0
---@alias lsp.DocumentDiagnosticReport lsp.RelatedFullDocumentDiagnosticReport | lsp.RelatedUnchangedDocumentDiagnosticReport

---@alias lsp.PrepareRenameResult lsp.Range | lsp.PrepareRenameResult.alias.2 | lsp.PrepareRenameResult.alias.3

---A document selector is the combination of one or many document filters.
---@sample `let sel:DocumentSelector = [{ language: 'typescript' }, { language: 'json', pattern: '**∕tsconfig.json' }]`;
---The use of a string as a document filter is deprecated @since 3.16.0.
---@alias lsp.DocumentSelector (lsp.DocumentFilter)[]

---@alias lsp.ProgressToken integer | string

---An identifier to refer to a change annotation stored with a workspace edit.
---@alias lsp.ChangeAnnotationIdentifier string

---A workspace diagnostic document report.
---@since 3.17.0
---@alias lsp.WorkspaceDocumentDiagnosticReport lsp.WorkspaceFullDocumentDiagnosticReport | lsp.WorkspaceUnchangedDocumentDiagnosticReport

---An event describing a change to a text document. If only a text is provided
---it is considered to be the full content of the document.
---@alias lsp.TextDocumentContentChangeEvent lsp.TextDocumentContentChangeEvent.alias.1 | lsp.TextDocumentContentChangeEvent.alias.2

---MarkedString can be used to render human readable text. It is either a markdown string
---or a code-block that provides a language and a code snippet. The language identifier
---is semantically equal to the optional language identifier in fenced code blocks in GitHub
---issues. See https://help.github.com/articles/creating-and-highlighting-code-blocks/#syntax-highlighting
---The pair of a language and a value is an equivalent to markdown:
---```${language}
---${value}
---```
---Note that markdown strings will be sanitized - that means html will be escaped.
---@deprecated use MarkupContent instead.
---@alias lsp.MarkedString string | lsp.MarkedString.alias.2

---A document filter describes a top level text document or
---a notebook cell document.
---@since 3.17.0 - proposed support for NotebookCellTextDocumentFilter.
---@alias lsp.DocumentFilter lsp.TextDocumentFilter | lsp.NotebookCellTextDocumentFilter

---LSP object definition.
---@since 3.17.0
---@alias lsp.LSPObject { [string]: lsp.LSPAny }

---The glob pattern. Either a string pattern or a relative pattern.
---@since 3.17.0
---@alias lsp.GlobPattern lsp.Pattern | lsp.RelativePattern

---A document filter denotes a document by different properties like
---the {@link TextDocument.languageId language}, the {@link Uri.scheme scheme} of
---its resource, or a glob-pattern that is applied to the {@link TextDocument.fileName path}.
---Glob patterns can have the following syntax:
---- `*` to match one or more characters in a path segment
---- `?` to match on one character in a path segment
---- `**` to match any number of path segments, including none
---- `{}` to group sub patterns into an OR expression. (e.g. `**​/*.{ts,js}` matches all TypeScript and JavaScript files)
---- `[]` to declare a range of characters to match in a path segment (e.g., `example.[0-9]` to match on `example.0`, `example.1`, …)
---- `[!...]` to negate a range of characters to match in a path segment (e.g., `example.[!0-9]` to match on `example.a`, `example.b`, but not `example.0`)
---@sample A language filter that applies to typescript files on disk: `{ language: 'typescript', scheme: 'file' }`
---@sample A language filter that applies to all package.json paths: `{ language: 'json', pattern: '**package.json' }`
---@since 3.17.0
---@alias lsp.TextDocumentFilter lsp.TextDocumentFilter.alias.1 | lsp.TextDocumentFilter.alias.2 | lsp.TextDocumentFilter.alias.3

---A notebook document filter denotes a notebook document by
---different properties. The properties will be match
---against the notebook's URI (same as with documents)
---@since 3.17.0
---@alias lsp.NotebookDocumentFilter lsp.NotebookDocumentFilter.alias.1 | lsp.NotebookDocumentFilter.alias.2 | lsp.NotebookDocumentFilter.alias.3

---The glob pattern to watch relative to the base path. Glob patterns can have the following syntax:
---- `*` to match one or more characters in a path segment
---- `?` to match on one character in a path segment
---- `**` to match any number of path segments, including none
---- `{}` to group conditions (e.g. `**​/*.{ts,js}` matches all TypeScript and JavaScript files)
---- `[]` to declare a range of characters to match in a path segment (e.g., `example.[0-9]` to match on `example.0`, `example.1`, …)
---- `[!...]` to negate a range of characters to match in a path segment (e.g., `example.[!0-9]` to match on `example.a`, `example.b`, but not `example.0`)
---@since 3.17.0
---@alias lsp.Pattern string

---The `workspace/didChangeWorkspaceFolders` notification is sent from the client to the server when the workspace
---folder configuration changes.
---
---Message Direction: Client --> Server
---@class lsp.Notification.workspace-didChangeWorkspaceFolders : lsp.Notification
---@field method "workspace/didChangeWorkspaceFolders"
---@field params lsp.Notification.workspace-didChangeWorkspaceFolders.params

---The `workspace/didChangeWorkspaceFolders` notification is sent from the client to the server when the workspace
---folder configuration changes.
---
---Message Direction: Client --> Server
---@alias lsp.Notification.workspace-didChangeWorkspaceFolders.params lsp.DidChangeWorkspaceFoldersParams

---The `window/workDoneProgress/cancel` notification is sent from  the client to the server to cancel a progress
---initiated on the server side.
---
---Message Direction: Client --> Server
---@class lsp.Notification.window-workDoneProgress-cancel : lsp.Notification
---@field method "window/workDoneProgress/cancel"
---@field params lsp.Notification.window-workDoneProgress-cancel.params

---The `window/workDoneProgress/cancel` notification is sent from  the client to the server to cancel a progress
---initiated on the server side.
---
---Message Direction: Client --> Server
---@alias lsp.Notification.window-workDoneProgress-cancel.params lsp.WorkDoneProgressCancelParams

---The did create files notification is sent from the client to the server when
---files were created from within the client.
---@since 3.16.0
---
---Message Direction: Client --> Server
---@class lsp.Notification.workspace-didCreateFiles : lsp.Notification
---@field method "workspace/didCreateFiles"
---@field params lsp.Notification.workspace-didCreateFiles.params

---The did create files notification is sent from the client to the server when
---files were created from within the client.
---@since 3.16.0
---
---Message Direction: Client --> Server
---@alias lsp.Notification.workspace-didCreateFiles.params lsp.CreateFilesParams

---The did rename files notification is sent from the client to the server when
---files were renamed from within the client.
---@since 3.16.0
---
---Message Direction: Client --> Server
---@class lsp.Notification.workspace-didRenameFiles : lsp.Notification
---@field method "workspace/didRenameFiles"
---@field params lsp.Notification.workspace-didRenameFiles.params

---The did rename files notification is sent from the client to the server when
---files were renamed from within the client.
---@since 3.16.0
---
---Message Direction: Client --> Server
---@alias lsp.Notification.workspace-didRenameFiles.params lsp.RenameFilesParams

---The will delete files request is sent from the client to the server before files are actually
---deleted as long as the deletion is triggered from within the client.
---@since 3.16.0
---
---Message Direction: Client --> Server
---@class lsp.Notification.workspace-didDeleteFiles : lsp.Notification
---@field method "workspace/didDeleteFiles"
---@field params lsp.Notification.workspace-didDeleteFiles.params

---The will delete files request is sent from the client to the server before files are actually
---deleted as long as the deletion is triggered from within the client.
---@since 3.16.0
---
---Message Direction: Client --> Server
---@alias lsp.Notification.workspace-didDeleteFiles.params lsp.DeleteFilesParams

---A notification sent when a notebook opens.
---@since 3.17.0
---
---Message Direction: Client --> Server
---@class lsp.Notification.notebookDocument-didOpen : lsp.Notification
---@field method "notebookDocument/didOpen"
---@field params lsp.Notification.notebookDocument-didOpen.params

---A notification sent when a notebook opens.
---@since 3.17.0
---
---Message Direction: Client --> Server
---@alias lsp.Notification.notebookDocument-didOpen.params lsp.DidOpenNotebookDocumentParams

---Message Direction: Client --> Server
---@class lsp.Notification.notebookDocument-didChange : lsp.Notification
---@field method "notebookDocument/didChange"
---@field params lsp.Notification.notebookDocument-didChange.params

---Message Direction: Client --> Server
---@alias lsp.Notification.notebookDocument-didChange.params lsp.DidChangeNotebookDocumentParams

---A notification sent when a notebook document is saved.
---@since 3.17.0
---
---Message Direction: Client --> Server
---@class lsp.Notification.notebookDocument-didSave : lsp.Notification
---@field method "notebookDocument/didSave"
---@field params lsp.Notification.notebookDocument-didSave.params

---A notification sent when a notebook document is saved.
---@since 3.17.0
---
---Message Direction: Client --> Server
---@alias lsp.Notification.notebookDocument-didSave.params lsp.DidSaveNotebookDocumentParams

---A notification sent when a notebook closes.
---@since 3.17.0
---
---Message Direction: Client --> Server
---@class lsp.Notification.notebookDocument-didClose : lsp.Notification
---@field method "notebookDocument/didClose"
---@field params lsp.Notification.notebookDocument-didClose.params

---A notification sent when a notebook closes.
---@since 3.17.0
---
---Message Direction: Client --> Server
---@alias lsp.Notification.notebookDocument-didClose.params lsp.DidCloseNotebookDocumentParams

---The initialized notification is sent from the client to the
---server after the client is fully initialized and the server
---is allowed to send requests from the server to the client.
---
---Message Direction: Client --> Server
---@class lsp.Notification.initialized : lsp.Notification
---@field method "initialized"
---@field params lsp.Notification.initialized.params

---The initialized notification is sent from the client to the
---server after the client is fully initialized and the server
---is allowed to send requests from the server to the client.
---
---Message Direction: Client --> Server
---@alias lsp.Notification.initialized.params lsp.InitializedParams

---The exit event is sent from the client to the server to
---ask the server to exit its process.
---
---Message Direction: Client --> Server
---@class lsp.Notification.exit : lsp.Notification
---@field method "exit"
---@field params lsp.Notification.exit.params

---The exit event is sent from the client to the server to
---ask the server to exit its process.
---
---Message Direction: Client --> Server
---@alias lsp.Notification.exit.params cjson.null?

---The configuration change notification is sent from the client to the server
---when the client's configuration has changed. The notification contains
---the changed configuration as defined by the language client.
---
---Message Direction: Client --> Server
---@class lsp.Notification.workspace-didChangeConfiguration : lsp.Notification
---@field method "workspace/didChangeConfiguration"
---@field params lsp.Notification.workspace-didChangeConfiguration.params

---The configuration change notification is sent from the client to the server
---when the client's configuration has changed. The notification contains
---the changed configuration as defined by the language client.
---
---Message Direction: Client --> Server
---@alias lsp.Notification.workspace-didChangeConfiguration.params lsp.DidChangeConfigurationParams

---The show message notification is sent from a server to a client to ask
---the client to display a particular message in the user interface.
---
---Message Direction: Client <-- Server
---@class lsp.Notification.window-showMessage : lsp.Notification
---@field method "window/showMessage"
---@field params lsp.Notification.window-showMessage.params

---The show message notification is sent from a server to a client to ask
---the client to display a particular message in the user interface.
---
---Message Direction: Client <-- Server
---@alias lsp.Notification.window-showMessage.params lsp.ShowMessageParams

---The log message notification is sent from the server to the client to ask
---the client to log a particular message.
---
---Message Direction: Client <-- Server
---@class lsp.Notification.window-logMessage : lsp.Notification
---@field method "window/logMessage"
---@field params lsp.Notification.window-logMessage.params

---The log message notification is sent from the server to the client to ask
---the client to log a particular message.
---
---Message Direction: Client <-- Server
---@alias lsp.Notification.window-logMessage.params lsp.LogMessageParams

---The telemetry event notification is sent from the server to the client to ask
---the client to log telemetry data.
---
---Message Direction: Client <-- Server
---@class lsp.Notification.telemetry-event : lsp.Notification
---@field method "telemetry/event"
---@field params lsp.Notification.telemetry-event.params

---The telemetry event notification is sent from the server to the client to ask
---the client to log telemetry data.
---
---Message Direction: Client <-- Server
---@alias lsp.Notification.telemetry-event.params lsp.LSPAny

---The document open notification is sent from the client to the server to signal
---newly opened text documents. The document's truth is now managed by the client
---and the server must not try to read the document's truth using the document's
---uri. Open in this sense means it is managed by the client. It doesn't necessarily
---mean that its content is presented in an editor. An open notification must not
---be sent more than once without a corresponding close notification send before.
---This means open and close notification must be balanced and the max open count
---is one.
---
---Message Direction: Client --> Server
---@class lsp.Notification.textDocument-didOpen : lsp.Notification
---@field method "textDocument/didOpen"
---@field params lsp.Notification.textDocument-didOpen.params

---The document open notification is sent from the client to the server to signal
---newly opened text documents. The document's truth is now managed by the client
---and the server must not try to read the document's truth using the document's
---uri. Open in this sense means it is managed by the client. It doesn't necessarily
---mean that its content is presented in an editor. An open notification must not
---be sent more than once without a corresponding close notification send before.
---This means open and close notification must be balanced and the max open count
---is one.
---
---Message Direction: Client --> Server
---@alias lsp.Notification.textDocument-didOpen.params lsp.DidOpenTextDocumentParams

---The document change notification is sent from the client to the server to signal
---changes to a text document.
---
---Message Direction: Client --> Server
---@class lsp.Notification.textDocument-didChange : lsp.Notification
---@field method "textDocument/didChange"
---@field params lsp.Notification.textDocument-didChange.params

---The document change notification is sent from the client to the server to signal
---changes to a text document.
---
---Message Direction: Client --> Server
---@alias lsp.Notification.textDocument-didChange.params lsp.DidChangeTextDocumentParams

---The document close notification is sent from the client to the server when
---the document got closed in the client. The document's truth now exists where
---the document's uri points to (e.g. if the document's uri is a file uri the
---truth now exists on disk). As with the open notification the close notification
---is about managing the document's content. Receiving a close notification
---doesn't mean that the document was open in an editor before. A close
---notification requires a previous open notification to be sent.
---
---Message Direction: Client --> Server
---@class lsp.Notification.textDocument-didClose : lsp.Notification
---@field method "textDocument/didClose"
---@field params lsp.Notification.textDocument-didClose.params

---The document close notification is sent from the client to the server when
---the document got closed in the client. The document's truth now exists where
---the document's uri points to (e.g. if the document's uri is a file uri the
---truth now exists on disk). As with the open notification the close notification
---is about managing the document's content. Receiving a close notification
---doesn't mean that the document was open in an editor before. A close
---notification requires a previous open notification to be sent.
---
---Message Direction: Client --> Server
---@alias lsp.Notification.textDocument-didClose.params lsp.DidCloseTextDocumentParams

---The document save notification is sent from the client to the server when
---the document got saved in the client.
---
---Message Direction: Client --> Server
---@class lsp.Notification.textDocument-didSave : lsp.Notification
---@field method "textDocument/didSave"
---@field params lsp.Notification.textDocument-didSave.params

---The document save notification is sent from the client to the server when
---the document got saved in the client.
---
---Message Direction: Client --> Server
---@alias lsp.Notification.textDocument-didSave.params lsp.DidSaveTextDocumentParams

---A document will save notification is sent from the client to the server before
---the document is actually saved.
---
---Message Direction: Client --> Server
---@class lsp.Notification.textDocument-willSave : lsp.Notification
---@field method "textDocument/willSave"
---@field params lsp.Notification.textDocument-willSave.params

---A document will save notification is sent from the client to the server before
---the document is actually saved.
---
---Message Direction: Client --> Server
---@alias lsp.Notification.textDocument-willSave.params lsp.WillSaveTextDocumentParams

---The watched files notification is sent from the client to the server when
---the client detects changes to file watched by the language client.
---
---Message Direction: Client --> Server
---@class lsp.Notification.workspace-didChangeWatchedFiles : lsp.Notification
---@field method "workspace/didChangeWatchedFiles"
---@field params lsp.Notification.workspace-didChangeWatchedFiles.params

---The watched files notification is sent from the client to the server when
---the client detects changes to file watched by the language client.
---
---Message Direction: Client --> Server
---@alias lsp.Notification.workspace-didChangeWatchedFiles.params lsp.DidChangeWatchedFilesParams

---Diagnostics notification are sent from the server to the client to signal
---results of validation runs.
---
---Message Direction: Client <-- Server
---@class lsp.Notification.textDocument-publishDiagnostics : lsp.Notification
---@field method "textDocument/publishDiagnostics"
---@field params lsp.Notification.textDocument-publishDiagnostics.params

---Diagnostics notification are sent from the server to the client to signal
---results of validation runs.
---
---Message Direction: Client <-- Server
---@alias lsp.Notification.textDocument-publishDiagnostics.params lsp.PublishDiagnosticsParams

---Message Direction: Client --> Server
---@class lsp.Notification._-setTrace : lsp.Notification
---@field method "$/setTrace"
---@field params lsp.Notification._-setTrace.params

---Message Direction: Client --> Server
---@alias lsp.Notification._-setTrace.params lsp.SetTraceParams

---Message Direction: Client <-- Server
---@class lsp.Notification._-logTrace : lsp.Notification
---@field method "$/logTrace"
---@field params lsp.Notification._-logTrace.params

---Message Direction: Client <-- Server
---@alias lsp.Notification._-logTrace.params lsp.LogTraceParams

---Message Direction: Client <--> Server
---@class lsp.Notification._-cancelRequest : lsp.Notification
---@field method "$/cancelRequest"
---@field params lsp.Notification._-cancelRequest.params

---Message Direction: Client <--> Server
---@alias lsp.Notification._-cancelRequest.params lsp.CancelParams

---Message Direction: Client <--> Server
---@class lsp.Notification._-progress : lsp.Notification
---@field method "$/progress"
---@field params lsp.Notification._-progress.params

---Message Direction: Client <--> Server
---@alias lsp.Notification._-progress.params lsp.ProgressParams

---A request to resolve the implementation locations of a symbol at a given text
---document position. The request's parameter is of type {@link TextDocumentPositionParams}
---the response is of type {@link Definition} or a Thenable that resolves to such.
---
---Message Direction: Client --> Server
---
---Registration Options:
---@see lsp.ImplementationRegistrationOptions
---@class lsp.Request.textDocument-implementation : lsp.Request
---@field method "textDocument/implementation"
---@field params lsp.Request.textDocument-implementation.params

---A request to resolve the implementation locations of a symbol at a given text
---document position. The request's parameter is of type {@link TextDocumentPositionParams}
---the response is of type {@link Definition} or a Thenable that resolves to such.
---
---Message Direction: Client --> Server
---
---Registration Options:
---@see lsp.ImplementationRegistrationOptions
---@alias lsp.Request.textDocument-implementation.params lsp.ImplementationParams

---A request to resolve the implementation locations of a symbol at a given text
---document position. The request's parameter is of type {@link TextDocumentPositionParams}
---the response is of type {@link Definition} or a Thenable that resolves to such.
---
---Message Direction: Client --> Server
---
---Registration Options:
---@see lsp.ImplementationRegistrationOptions
---@class lsp.Response.textDocument-implementation : lsp.Response
---@field result? lsp.Response.textDocument-implementation.result
---@field error? lsp.Response.textDocument-implementation.error

---A request to resolve the type definition locations of a symbol at a given text
---document position. The request's parameter is of type {@link TextDocumentPositionParams}
---the response is of type {@link Definition} or a Thenable that resolves to such.
---
---Message Direction: Client --> Server
---
---Registration Options:
---@see lsp.TypeDefinitionRegistrationOptions
---@class lsp.Request.textDocument-typeDefinition : lsp.Request
---@field method "textDocument/typeDefinition"
---@field params lsp.Request.textDocument-typeDefinition.params

---A request to resolve the type definition locations of a symbol at a given text
---document position. The request's parameter is of type {@link TextDocumentPositionParams}
---the response is of type {@link Definition} or a Thenable that resolves to such.
---
---Message Direction: Client --> Server
---
---Registration Options:
---@see lsp.TypeDefinitionRegistrationOptions
---@alias lsp.Request.textDocument-typeDefinition.params lsp.TypeDefinitionParams

---A request to resolve the type definition locations of a symbol at a given text
---document position. The request's parameter is of type {@link TextDocumentPositionParams}
---the response is of type {@link Definition} or a Thenable that resolves to such.
---
---Message Direction: Client --> Server
---
---Registration Options:
---@see lsp.TypeDefinitionRegistrationOptions
---@class lsp.Response.textDocument-typeDefinition : lsp.Response
---@field result? lsp.Response.textDocument-typeDefinition.result
---@field error? lsp.Response.textDocument-typeDefinition.error

---The `workspace/workspaceFolders` is sent from the server to the client to fetch the open workspace folders.
---
---Message Direction: Client <-- Server
---@class lsp.Request.workspace-workspaceFolders : lsp.Request
---@field method "workspace/workspaceFolders"
---@field params lsp.Request.workspace-workspaceFolders.params

---The `workspace/workspaceFolders` is sent from the server to the client to fetch the open workspace folders.
---
---Message Direction: Client <-- Server
---@alias lsp.Request.workspace-workspaceFolders.params cjson.null?

---The `workspace/workspaceFolders` is sent from the server to the client to fetch the open workspace folders.
---
---Message Direction: Client <-- Server
---@class lsp.Response.workspace-workspaceFolders : lsp.Response
---@field result? lsp.Response.workspace-workspaceFolders.result
---@field error? lsp.Response.workspace-workspaceFolders.error

---The 'workspace/configuration' request is sent from the server to the client to fetch a certain
---configuration setting.
---This pull model replaces the old push model were the client signaled configuration change via an
---event. If the server still needs to react to configuration changes (since the server caches the
---result of `workspace/configuration` requests) the server should register for an empty configuration
---change event and empty the cache if such an event is received.
---
---Message Direction: Client <-- Server
---@class lsp.Request.workspace-configuration : lsp.Request
---@field method "workspace/configuration"
---@field params lsp.Request.workspace-configuration.params

---The 'workspace/configuration' request is sent from the server to the client to fetch a certain
---configuration setting.
---This pull model replaces the old push model were the client signaled configuration change via an
---event. If the server still needs to react to configuration changes (since the server caches the
---result of `workspace/configuration` requests) the server should register for an empty configuration
---change event and empty the cache if such an event is received.
---
---Message Direction: Client <-- Server
---@alias lsp.Request.workspace-configuration.params lsp.ConfigurationParams

---The 'workspace/configuration' request is sent from the server to the client to fetch a certain
---configuration setting.
---This pull model replaces the old push model were the client signaled configuration change via an
---event. If the server still needs to react to configuration changes (since the server caches the
---result of `workspace/configuration` requests) the server should register for an empty configuration
---change event and empty the cache if such an event is received.
---
---Message Direction: Client <-- Server
---@class lsp.Response.workspace-configuration : lsp.Response
---@field result? lsp.Response.workspace-configuration.result
---@field error? lsp.Response.workspace-configuration.error

---A request to list all color symbols found in a given text document. The request's
---parameter is of type {@link DocumentColorParams} the
---response is of type {@link ColorInformation ColorInformation[]} or a Thenable
---that resolves to such.
---
---Message Direction: Client --> Server
---
---Registration Options:
---@see lsp.DocumentColorRegistrationOptions
---@class lsp.Request.textDocument-documentColor : lsp.Request
---@field method "textDocument/documentColor"
---@field params lsp.Request.textDocument-documentColor.params

---A request to list all color symbols found in a given text document. The request's
---parameter is of type {@link DocumentColorParams} the
---response is of type {@link ColorInformation ColorInformation[]} or a Thenable
---that resolves to such.
---
---Message Direction: Client --> Server
---
---Registration Options:
---@see lsp.DocumentColorRegistrationOptions
---@alias lsp.Request.textDocument-documentColor.params lsp.DocumentColorParams

---A request to list all color symbols found in a given text document. The request's
---parameter is of type {@link DocumentColorParams} the
---response is of type {@link ColorInformation ColorInformation[]} or a Thenable
---that resolves to such.
---
---Message Direction: Client --> Server
---
---Registration Options:
---@see lsp.DocumentColorRegistrationOptions
---@class lsp.Response.textDocument-documentColor : lsp.Response
---@field result? lsp.Response.textDocument-documentColor.result
---@field error? lsp.Response.textDocument-documentColor.error

---A request to list all presentation for a color. The request's
---parameter is of type {@link ColorPresentationParams} the
---response is of type {@link ColorInformation ColorInformation[]} or a Thenable
---that resolves to such.
---
---Message Direction: Client --> Server
---
---Registration Options:
---@see lsp.Request.textDocument-colorPresentation.registrationOptions
---@class lsp.Request.textDocument-colorPresentation : lsp.Request
---@field method "textDocument/colorPresentation"
---@field params lsp.Request.textDocument-colorPresentation.params

---A request to list all presentation for a color. The request's
---parameter is of type {@link ColorPresentationParams} the
---response is of type {@link ColorInformation ColorInformation[]} or a Thenable
---that resolves to such.
---
---Message Direction: Client --> Server
---
---Registration Options:
---@see lsp.Request.textDocument-colorPresentation.registrationOptions
---@alias lsp.Request.textDocument-colorPresentation.params lsp.ColorPresentationParams

---A request to list all presentation for a color. The request's
---parameter is of type {@link ColorPresentationParams} the
---response is of type {@link ColorInformation ColorInformation[]} or a Thenable
---that resolves to such.
---
---Message Direction: Client --> Server
---
---Registration Options:
---@see lsp.Request.textDocument-colorPresentation.registrationOptions
---@class lsp.Response.textDocument-colorPresentation : lsp.Response
---@field result? lsp.Response.textDocument-colorPresentation.result
---@field error? lsp.Response.textDocument-colorPresentation.error

---A request to provide folding ranges in a document. The request's
---parameter is of type {@link FoldingRangeParams}, the
---response is of type {@link FoldingRangeList} or a Thenable
---that resolves to such.
---
---Message Direction: Client --> Server
---
---Registration Options:
---@see lsp.FoldingRangeRegistrationOptions
---@class lsp.Request.textDocument-foldingRange : lsp.Request
---@field method "textDocument/foldingRange"
---@field params lsp.Request.textDocument-foldingRange.params

---A request to provide folding ranges in a document. The request's
---parameter is of type {@link FoldingRangeParams}, the
---response is of type {@link FoldingRangeList} or a Thenable
---that resolves to such.
---
---Message Direction: Client --> Server
---
---Registration Options:
---@see lsp.FoldingRangeRegistrationOptions
---@alias lsp.Request.textDocument-foldingRange.params lsp.FoldingRangeParams

---A request to provide folding ranges in a document. The request's
---parameter is of type {@link FoldingRangeParams}, the
---response is of type {@link FoldingRangeList} or a Thenable
---that resolves to such.
---
---Message Direction: Client --> Server
---
---Registration Options:
---@see lsp.FoldingRangeRegistrationOptions
---@class lsp.Response.textDocument-foldingRange : lsp.Response
---@field result? lsp.Response.textDocument-foldingRange.result
---@field error? lsp.Response.textDocument-foldingRange.error

---@since 3.18.0
---@proposed
---
---Message Direction: Client <-- Server
---@class lsp.Request.workspace-foldingRange-refresh : lsp.Request
---@field method "workspace/foldingRange/refresh"
---@field params lsp.Request.workspace-foldingRange-refresh.params

---@since 3.18.0
---@proposed
---
---Message Direction: Client <-- Server
---@alias lsp.Request.workspace-foldingRange-refresh.params cjson.null?

---@since 3.18.0
---@proposed
---
---Message Direction: Client <-- Server
---@class lsp.Response.workspace-foldingRange-refresh : lsp.Response
---@field result? lsp.Response.workspace-foldingRange-refresh.result
---@field error? lsp.Response.workspace-foldingRange-refresh.error

---A request to resolve the type definition locations of a symbol at a given text
---document position. The request's parameter is of type {@link TextDocumentPositionParams}
---the response is of type {@link Declaration} or a typed array of {@link DeclarationLink}
---or a Thenable that resolves to such.
---
---Message Direction: Client --> Server
---
---Registration Options:
---@see lsp.DeclarationRegistrationOptions
---@class lsp.Request.textDocument-declaration : lsp.Request
---@field method "textDocument/declaration"
---@field params lsp.Request.textDocument-declaration.params

---A request to resolve the type definition locations of a symbol at a given text
---document position. The request's parameter is of type {@link TextDocumentPositionParams}
---the response is of type {@link Declaration} or a typed array of {@link DeclarationLink}
---or a Thenable that resolves to such.
---
---Message Direction: Client --> Server
---
---Registration Options:
---@see lsp.DeclarationRegistrationOptions
---@alias lsp.Request.textDocument-declaration.params lsp.DeclarationParams

---A request to resolve the type definition locations of a symbol at a given text
---document position. The request's parameter is of type {@link TextDocumentPositionParams}
---the response is of type {@link Declaration} or a typed array of {@link DeclarationLink}
---or a Thenable that resolves to such.
---
---Message Direction: Client --> Server
---
---Registration Options:
---@see lsp.DeclarationRegistrationOptions
---@class lsp.Response.textDocument-declaration : lsp.Response
---@field result? lsp.Response.textDocument-declaration.result
---@field error? lsp.Response.textDocument-declaration.error

---A request to provide selection ranges in a document. The request's
---parameter is of type {@link SelectionRangeParams}, the
---response is of type {@link SelectionRange SelectionRange[]} or a Thenable
---that resolves to such.
---
---Message Direction: Client --> Server
---
---Registration Options:
---@see lsp.SelectionRangeRegistrationOptions
---@class lsp.Request.textDocument-selectionRange : lsp.Request
---@field method "textDocument/selectionRange"
---@field params lsp.Request.textDocument-selectionRange.params

---A request to provide selection ranges in a document. The request's
---parameter is of type {@link SelectionRangeParams}, the
---response is of type {@link SelectionRange SelectionRange[]} or a Thenable
---that resolves to such.
---
---Message Direction: Client --> Server
---
---Registration Options:
---@see lsp.SelectionRangeRegistrationOptions
---@alias lsp.Request.textDocument-selectionRange.params lsp.SelectionRangeParams

---A request to provide selection ranges in a document. The request's
---parameter is of type {@link SelectionRangeParams}, the
---response is of type {@link SelectionRange SelectionRange[]} or a Thenable
---that resolves to such.
---
---Message Direction: Client --> Server
---
---Registration Options:
---@see lsp.SelectionRangeRegistrationOptions
---@class lsp.Response.textDocument-selectionRange : lsp.Response
---@field result? lsp.Response.textDocument-selectionRange.result
---@field error? lsp.Response.textDocument-selectionRange.error

---The `window/workDoneProgress/create` request is sent from the server to the client to initiate progress
---reporting from the server.
---
---Message Direction: Client <-- Server
---@class lsp.Request.window-workDoneProgress-create : lsp.Request
---@field method "window/workDoneProgress/create"
---@field params lsp.Request.window-workDoneProgress-create.params

---The `window/workDoneProgress/create` request is sent from the server to the client to initiate progress
---reporting from the server.
---
---Message Direction: Client <-- Server
---@alias lsp.Request.window-workDoneProgress-create.params lsp.WorkDoneProgressCreateParams

---The `window/workDoneProgress/create` request is sent from the server to the client to initiate progress
---reporting from the server.
---
---Message Direction: Client <-- Server
---@class lsp.Response.window-workDoneProgress-create : lsp.Response
---@field result? lsp.Response.window-workDoneProgress-create.result
---@field error? lsp.Response.window-workDoneProgress-create.error

---A request to result a `CallHierarchyItem` in a document at a given position.
---Can be used as an input to an incoming or outgoing call hierarchy.
---@since 3.16.0
---
---Message Direction: Client --> Server
---
---Registration Options:
---@see lsp.CallHierarchyRegistrationOptions
---@class lsp.Request.textDocument-prepareCallHierarchy : lsp.Request
---@field method "textDocument/prepareCallHierarchy"
---@field params lsp.Request.textDocument-prepareCallHierarchy.params

---A request to result a `CallHierarchyItem` in a document at a given position.
---Can be used as an input to an incoming or outgoing call hierarchy.
---@since 3.16.0
---
---Message Direction: Client --> Server
---
---Registration Options:
---@see lsp.CallHierarchyRegistrationOptions
---@alias lsp.Request.textDocument-prepareCallHierarchy.params lsp.CallHierarchyPrepareParams

---A request to result a `CallHierarchyItem` in a document at a given position.
---Can be used as an input to an incoming or outgoing call hierarchy.
---@since 3.16.0
---
---Message Direction: Client --> Server
---
---Registration Options:
---@see lsp.CallHierarchyRegistrationOptions
---@class lsp.Response.textDocument-prepareCallHierarchy : lsp.Response
---@field result? lsp.Response.textDocument-prepareCallHierarchy.result
---@field error? lsp.Response.textDocument-prepareCallHierarchy.error

---A request to resolve the incoming calls for a given `CallHierarchyItem`.
---@since 3.16.0
---
---Message Direction: Client --> Server
---@class lsp.Request.callHierarchy-incomingCalls : lsp.Request
---@field method "callHierarchy/incomingCalls"
---@field params lsp.Request.callHierarchy-incomingCalls.params

---A request to resolve the incoming calls for a given `CallHierarchyItem`.
---@since 3.16.0
---
---Message Direction: Client --> Server
---@alias lsp.Request.callHierarchy-incomingCalls.params lsp.CallHierarchyIncomingCallsParams

---A request to resolve the incoming calls for a given `CallHierarchyItem`.
---@since 3.16.0
---
---Message Direction: Client --> Server
---@class lsp.Response.callHierarchy-incomingCalls : lsp.Response
---@field result? lsp.Response.callHierarchy-incomingCalls.result
---@field error? lsp.Response.callHierarchy-incomingCalls.error

---A request to resolve the outgoing calls for a given `CallHierarchyItem`.
---@since 3.16.0
---
---Message Direction: Client --> Server
---@class lsp.Request.callHierarchy-outgoingCalls : lsp.Request
---@field method "callHierarchy/outgoingCalls"
---@field params lsp.Request.callHierarchy-outgoingCalls.params

---A request to resolve the outgoing calls for a given `CallHierarchyItem`.
---@since 3.16.0
---
---Message Direction: Client --> Server
---@alias lsp.Request.callHierarchy-outgoingCalls.params lsp.CallHierarchyOutgoingCallsParams

---A request to resolve the outgoing calls for a given `CallHierarchyItem`.
---@since 3.16.0
---
---Message Direction: Client --> Server
---@class lsp.Response.callHierarchy-outgoingCalls : lsp.Response
---@field result? lsp.Response.callHierarchy-outgoingCalls.result
---@field error? lsp.Response.callHierarchy-outgoingCalls.error

---@since 3.16.0
---
---Message Direction: Client --> Server
---
---Registration Method: `textDocument/semanticTokens`
---
---Registration Options:
---@see lsp.SemanticTokensRegistrationOptions
---@class lsp.Request.textDocument-semanticTokens-full : lsp.Request
---@field method "textDocument/semanticTokens/full"
---@field params lsp.Request.textDocument-semanticTokens-full.params

---@since 3.16.0
---
---Message Direction: Client --> Server
---
---Registration Method: `textDocument/semanticTokens`
---
---Registration Options:
---@see lsp.SemanticTokensRegistrationOptions
---@alias lsp.Request.textDocument-semanticTokens-full.params lsp.SemanticTokensParams

---@since 3.16.0
---
---Message Direction: Client --> Server
---
---Registration Method: `textDocument/semanticTokens`
---
---Registration Options:
---@see lsp.SemanticTokensRegistrationOptions
---@class lsp.Response.textDocument-semanticTokens-full : lsp.Response
---@field result? lsp.Response.textDocument-semanticTokens-full.result
---@field error? lsp.Response.textDocument-semanticTokens-full.error

---@since 3.16.0
---
---Message Direction: Client --> Server
---
---Registration Method: `textDocument/semanticTokens`
---
---Registration Options:
---@see lsp.SemanticTokensRegistrationOptions
---@class lsp.Request.textDocument-semanticTokens-full-delta : lsp.Request
---@field method "textDocument/semanticTokens/full/delta"
---@field params lsp.Request.textDocument-semanticTokens-full-delta.params

---@since 3.16.0
---
---Message Direction: Client --> Server
---
---Registration Method: `textDocument/semanticTokens`
---
---Registration Options:
---@see lsp.SemanticTokensRegistrationOptions
---@alias lsp.Request.textDocument-semanticTokens-full-delta.params lsp.SemanticTokensDeltaParams

---@since 3.16.0
---
---Message Direction: Client --> Server
---
---Registration Method: `textDocument/semanticTokens`
---
---Registration Options:
---@see lsp.SemanticTokensRegistrationOptions
---@class lsp.Response.textDocument-semanticTokens-full-delta : lsp.Response
---@field result? lsp.Response.textDocument-semanticTokens-full-delta.result
---@field error? lsp.Response.textDocument-semanticTokens-full-delta.error

---@since 3.16.0
---
---Message Direction: Client --> Server
---
---Registration Method: `textDocument/semanticTokens`
---@class lsp.Request.textDocument-semanticTokens-range : lsp.Request
---@field method "textDocument/semanticTokens/range"
---@field params lsp.Request.textDocument-semanticTokens-range.params

---@since 3.16.0
---
---Message Direction: Client --> Server
---
---Registration Method: `textDocument/semanticTokens`
---@alias lsp.Request.textDocument-semanticTokens-range.params lsp.SemanticTokensRangeParams

---@since 3.16.0
---
---Message Direction: Client --> Server
---
---Registration Method: `textDocument/semanticTokens`
---@class lsp.Response.textDocument-semanticTokens-range : lsp.Response
---@field result? lsp.Response.textDocument-semanticTokens-range.result
---@field error? lsp.Response.textDocument-semanticTokens-range.error

---@since 3.16.0
---
---Message Direction: Client <-- Server
---@class lsp.Request.workspace-semanticTokens-refresh : lsp.Request
---@field method "workspace/semanticTokens/refresh"
---@field params lsp.Request.workspace-semanticTokens-refresh.params

---@since 3.16.0
---
---Message Direction: Client <-- Server
---@alias lsp.Request.workspace-semanticTokens-refresh.params cjson.null?

---@since 3.16.0
---
---Message Direction: Client <-- Server
---@class lsp.Response.workspace-semanticTokens-refresh : lsp.Response
---@field result? lsp.Response.workspace-semanticTokens-refresh.result
---@field error? lsp.Response.workspace-semanticTokens-refresh.error

---A request to show a document. This request might open an
---external program depending on the value of the URI to open.
---For example a request to open `https://code.visualstudio.com/`
---will very likely open the URI in a WEB browser.
---@since 3.16.0
---
---Message Direction: Client <-- Server
---@class lsp.Request.window-showDocument : lsp.Request
---@field method "window/showDocument"
---@field params lsp.Request.window-showDocument.params

---A request to show a document. This request might open an
---external program depending on the value of the URI to open.
---For example a request to open `https://code.visualstudio.com/`
---will very likely open the URI in a WEB browser.
---@since 3.16.0
---
---Message Direction: Client <-- Server
---@alias lsp.Request.window-showDocument.params lsp.ShowDocumentParams

---A request to show a document. This request might open an
---external program depending on the value of the URI to open.
---For example a request to open `https://code.visualstudio.com/`
---will very likely open the URI in a WEB browser.
---@since 3.16.0
---
---Message Direction: Client <-- Server
---@class lsp.Response.window-showDocument : lsp.Response
---@field result? lsp.Response.window-showDocument.result
---@field error? lsp.Response.window-showDocument.error

---A request to provide ranges that can be edited together.
---@since 3.16.0
---
---Message Direction: Client --> Server
---
---Registration Options:
---@see lsp.LinkedEditingRangeRegistrationOptions
---@class lsp.Request.textDocument-linkedEditingRange : lsp.Request
---@field method "textDocument/linkedEditingRange"
---@field params lsp.Request.textDocument-linkedEditingRange.params

---A request to provide ranges that can be edited together.
---@since 3.16.0
---
---Message Direction: Client --> Server
---
---Registration Options:
---@see lsp.LinkedEditingRangeRegistrationOptions
---@alias lsp.Request.textDocument-linkedEditingRange.params lsp.LinkedEditingRangeParams

---A request to provide ranges that can be edited together.
---@since 3.16.0
---
---Message Direction: Client --> Server
---
---Registration Options:
---@see lsp.LinkedEditingRangeRegistrationOptions
---@class lsp.Response.textDocument-linkedEditingRange : lsp.Response
---@field result? lsp.Response.textDocument-linkedEditingRange.result
---@field error? lsp.Response.textDocument-linkedEditingRange.error

---The will create files request is sent from the client to the server before files are actually
---created as long as the creation is triggered from within the client.
---The request can return a `WorkspaceEdit` which will be applied to workspace before the
---files are created. Hence the `WorkspaceEdit` can not manipulate the content of the file
---to be created.
---@since 3.16.0
---
---Message Direction: Client --> Server
---
---Registration Options:
---@see lsp.FileOperationRegistrationOptions
---@class lsp.Request.workspace-willCreateFiles : lsp.Request
---@field method "workspace/willCreateFiles"
---@field params lsp.Request.workspace-willCreateFiles.params

---The will create files request is sent from the client to the server before files are actually
---created as long as the creation is triggered from within the client.
---The request can return a `WorkspaceEdit` which will be applied to workspace before the
---files are created. Hence the `WorkspaceEdit` can not manipulate the content of the file
---to be created.
---@since 3.16.0
---
---Message Direction: Client --> Server
---
---Registration Options:
---@see lsp.FileOperationRegistrationOptions
---@alias lsp.Request.workspace-willCreateFiles.params lsp.CreateFilesParams

---The will create files request is sent from the client to the server before files are actually
---created as long as the creation is triggered from within the client.
---The request can return a `WorkspaceEdit` which will be applied to workspace before the
---files are created. Hence the `WorkspaceEdit` can not manipulate the content of the file
---to be created.
---@since 3.16.0
---
---Message Direction: Client --> Server
---
---Registration Options:
---@see lsp.FileOperationRegistrationOptions
---@class lsp.Response.workspace-willCreateFiles : lsp.Response
---@field result? lsp.Response.workspace-willCreateFiles.result
---@field error? lsp.Response.workspace-willCreateFiles.error

---The will rename files request is sent from the client to the server before files are actually
---renamed as long as the rename is triggered from within the client.
---@since 3.16.0
---
---Message Direction: Client --> Server
---
---Registration Options:
---@see lsp.FileOperationRegistrationOptions
---@class lsp.Request.workspace-willRenameFiles : lsp.Request
---@field method "workspace/willRenameFiles"
---@field params lsp.Request.workspace-willRenameFiles.params

---The will rename files request is sent from the client to the server before files are actually
---renamed as long as the rename is triggered from within the client.
---@since 3.16.0
---
---Message Direction: Client --> Server
---
---Registration Options:
---@see lsp.FileOperationRegistrationOptions
---@alias lsp.Request.workspace-willRenameFiles.params lsp.RenameFilesParams

---The will rename files request is sent from the client to the server before files are actually
---renamed as long as the rename is triggered from within the client.
---@since 3.16.0
---
---Message Direction: Client --> Server
---
---Registration Options:
---@see lsp.FileOperationRegistrationOptions
---@class lsp.Response.workspace-willRenameFiles : lsp.Response
---@field result? lsp.Response.workspace-willRenameFiles.result
---@field error? lsp.Response.workspace-willRenameFiles.error

---The did delete files notification is sent from the client to the server when
---files were deleted from within the client.
---@since 3.16.0
---
---Message Direction: Client --> Server
---
---Registration Options:
---@see lsp.FileOperationRegistrationOptions
---@class lsp.Request.workspace-willDeleteFiles : lsp.Request
---@field method "workspace/willDeleteFiles"
---@field params lsp.Request.workspace-willDeleteFiles.params

---The did delete files notification is sent from the client to the server when
---files were deleted from within the client.
---@since 3.16.0
---
---Message Direction: Client --> Server
---
---Registration Options:
---@see lsp.FileOperationRegistrationOptions
---@alias lsp.Request.workspace-willDeleteFiles.params lsp.DeleteFilesParams

---The did delete files notification is sent from the client to the server when
---files were deleted from within the client.
---@since 3.16.0
---
---Message Direction: Client --> Server
---
---Registration Options:
---@see lsp.FileOperationRegistrationOptions
---@class lsp.Response.workspace-willDeleteFiles : lsp.Response
---@field result? lsp.Response.workspace-willDeleteFiles.result
---@field error? lsp.Response.workspace-willDeleteFiles.error

---A request to get the moniker of a symbol at a given text document position.
---The request parameter is of type {@link TextDocumentPositionParams}.
---The response is of type {@link Moniker Moniker[]} or `null`.
---
---Message Direction: Client --> Server
---
---Registration Options:
---@see lsp.MonikerRegistrationOptions
---@class lsp.Request.textDocument-moniker : lsp.Request
---@field method "textDocument/moniker"
---@field params lsp.Request.textDocument-moniker.params

---A request to get the moniker of a symbol at a given text document position.
---The request parameter is of type {@link TextDocumentPositionParams}.
---The response is of type {@link Moniker Moniker[]} or `null`.
---
---Message Direction: Client --> Server
---
---Registration Options:
---@see lsp.MonikerRegistrationOptions
---@alias lsp.Request.textDocument-moniker.params lsp.MonikerParams

---A request to get the moniker of a symbol at a given text document position.
---The request parameter is of type {@link TextDocumentPositionParams}.
---The response is of type {@link Moniker Moniker[]} or `null`.
---
---Message Direction: Client --> Server
---
---Registration Options:
---@see lsp.MonikerRegistrationOptions
---@class lsp.Response.textDocument-moniker : lsp.Response
---@field result? lsp.Response.textDocument-moniker.result
---@field error? lsp.Response.textDocument-moniker.error

---A request to result a `TypeHierarchyItem` in a document at a given position.
---Can be used as an input to a subtypes or supertypes type hierarchy.
---@since 3.17.0
---
---Message Direction: Client --> Server
---
---Registration Options:
---@see lsp.TypeHierarchyRegistrationOptions
---@class lsp.Request.textDocument-prepareTypeHierarchy : lsp.Request
---@field method "textDocument/prepareTypeHierarchy"
---@field params lsp.Request.textDocument-prepareTypeHierarchy.params

---A request to result a `TypeHierarchyItem` in a document at a given position.
---Can be used as an input to a subtypes or supertypes type hierarchy.
---@since 3.17.0
---
---Message Direction: Client --> Server
---
---Registration Options:
---@see lsp.TypeHierarchyRegistrationOptions
---@alias lsp.Request.textDocument-prepareTypeHierarchy.params lsp.TypeHierarchyPrepareParams

---A request to result a `TypeHierarchyItem` in a document at a given position.
---Can be used as an input to a subtypes or supertypes type hierarchy.
---@since 3.17.0
---
---Message Direction: Client --> Server
---
---Registration Options:
---@see lsp.TypeHierarchyRegistrationOptions
---@class lsp.Response.textDocument-prepareTypeHierarchy : lsp.Response
---@field result? lsp.Response.textDocument-prepareTypeHierarchy.result
---@field error? lsp.Response.textDocument-prepareTypeHierarchy.error

---A request to resolve the supertypes for a given `TypeHierarchyItem`.
---@since 3.17.0
---
---Message Direction: Client --> Server
---@class lsp.Request.typeHierarchy-supertypes : lsp.Request
---@field method "typeHierarchy/supertypes"
---@field params lsp.Request.typeHierarchy-supertypes.params

---A request to resolve the supertypes for a given `TypeHierarchyItem`.
---@since 3.17.0
---
---Message Direction: Client --> Server
---@alias lsp.Request.typeHierarchy-supertypes.params lsp.TypeHierarchySupertypesParams

---A request to resolve the supertypes for a given `TypeHierarchyItem`.
---@since 3.17.0
---
---Message Direction: Client --> Server
---@class lsp.Response.typeHierarchy-supertypes : lsp.Response
---@field result? lsp.Response.typeHierarchy-supertypes.result
---@field error? lsp.Response.typeHierarchy-supertypes.error

---A request to resolve the subtypes for a given `TypeHierarchyItem`.
---@since 3.17.0
---
---Message Direction: Client --> Server
---@class lsp.Request.typeHierarchy-subtypes : lsp.Request
---@field method "typeHierarchy/subtypes"
---@field params lsp.Request.typeHierarchy-subtypes.params

---A request to resolve the subtypes for a given `TypeHierarchyItem`.
---@since 3.17.0
---
---Message Direction: Client --> Server
---@alias lsp.Request.typeHierarchy-subtypes.params lsp.TypeHierarchySubtypesParams

---A request to resolve the subtypes for a given `TypeHierarchyItem`.
---@since 3.17.0
---
---Message Direction: Client --> Server
---@class lsp.Response.typeHierarchy-subtypes : lsp.Response
---@field result? lsp.Response.typeHierarchy-subtypes.result
---@field error? lsp.Response.typeHierarchy-subtypes.error

---A request to provide inline values in a document. The request's parameter is of
---type {@link InlineValueParams}, the response is of type
---{@link InlineValue InlineValue[]} or a Thenable that resolves to such.
---@since 3.17.0
---
---Message Direction: Client --> Server
---
---Registration Options:
---@see lsp.InlineValueRegistrationOptions
---@class lsp.Request.textDocument-inlineValue : lsp.Request
---@field method "textDocument/inlineValue"
---@field params lsp.Request.textDocument-inlineValue.params

---A request to provide inline values in a document. The request's parameter is of
---type {@link InlineValueParams}, the response is of type
---{@link InlineValue InlineValue[]} or a Thenable that resolves to such.
---@since 3.17.0
---
---Message Direction: Client --> Server
---
---Registration Options:
---@see lsp.InlineValueRegistrationOptions
---@alias lsp.Request.textDocument-inlineValue.params lsp.InlineValueParams

---A request to provide inline values in a document. The request's parameter is of
---type {@link InlineValueParams}, the response is of type
---{@link InlineValue InlineValue[]} or a Thenable that resolves to such.
---@since 3.17.0
---
---Message Direction: Client --> Server
---
---Registration Options:
---@see lsp.InlineValueRegistrationOptions
---@class lsp.Response.textDocument-inlineValue : lsp.Response
---@field result? lsp.Response.textDocument-inlineValue.result
---@field error? lsp.Response.textDocument-inlineValue.error

---@since 3.17.0
---
---Message Direction: Client <-- Server
---@class lsp.Request.workspace-inlineValue-refresh : lsp.Request
---@field method "workspace/inlineValue/refresh"
---@field params lsp.Request.workspace-inlineValue-refresh.params

---@since 3.17.0
---
---Message Direction: Client <-- Server
---@alias lsp.Request.workspace-inlineValue-refresh.params cjson.null?

---@since 3.17.0
---
---Message Direction: Client <-- Server
---@class lsp.Response.workspace-inlineValue-refresh : lsp.Response
---@field result? lsp.Response.workspace-inlineValue-refresh.result
---@field error? lsp.Response.workspace-inlineValue-refresh.error

---A request to provide inlay hints in a document. The request's parameter is of
---type {@link InlayHintsParams}, the response is of type
---{@link InlayHint InlayHint[]} or a Thenable that resolves to such.
---@since 3.17.0
---
---Message Direction: Client --> Server
---
---Registration Options:
---@see lsp.InlayHintRegistrationOptions
---@class lsp.Request.textDocument-inlayHint : lsp.Request
---@field method "textDocument/inlayHint"
---@field params lsp.Request.textDocument-inlayHint.params

---A request to provide inlay hints in a document. The request's parameter is of
---type {@link InlayHintsParams}, the response is of type
---{@link InlayHint InlayHint[]} or a Thenable that resolves to such.
---@since 3.17.0
---
---Message Direction: Client --> Server
---
---Registration Options:
---@see lsp.InlayHintRegistrationOptions
---@alias lsp.Request.textDocument-inlayHint.params lsp.InlayHintParams

---A request to provide inlay hints in a document. The request's parameter is of
---type {@link InlayHintsParams}, the response is of type
---{@link InlayHint InlayHint[]} or a Thenable that resolves to such.
---@since 3.17.0
---
---Message Direction: Client --> Server
---
---Registration Options:
---@see lsp.InlayHintRegistrationOptions
---@class lsp.Response.textDocument-inlayHint : lsp.Response
---@field result? lsp.Response.textDocument-inlayHint.result
---@field error? lsp.Response.textDocument-inlayHint.error

---A request to resolve additional properties for an inlay hint.
---The request's parameter is of type {@link InlayHint}, the response is
---of type {@link InlayHint} or a Thenable that resolves to such.
---@since 3.17.0
---
---Message Direction: Client --> Server
---@class lsp.Request.inlayHint-resolve : lsp.Request
---@field method "inlayHint/resolve"
---@field params lsp.Request.inlayHint-resolve.params

---A request to resolve additional properties for an inlay hint.
---The request's parameter is of type {@link InlayHint}, the response is
---of type {@link InlayHint} or a Thenable that resolves to such.
---@since 3.17.0
---
---Message Direction: Client --> Server
---@alias lsp.Request.inlayHint-resolve.params lsp.InlayHint

---A request to resolve additional properties for an inlay hint.
---The request's parameter is of type {@link InlayHint}, the response is
---of type {@link InlayHint} or a Thenable that resolves to such.
---@since 3.17.0
---
---Message Direction: Client --> Server
---@class lsp.Response.inlayHint-resolve : lsp.Response
---@field result? lsp.Response.inlayHint-resolve.result
---@field error? lsp.Response.inlayHint-resolve.error

---@since 3.17.0
---
---Message Direction: Client <-- Server
---@class lsp.Request.workspace-inlayHint-refresh : lsp.Request
---@field method "workspace/inlayHint/refresh"
---@field params lsp.Request.workspace-inlayHint-refresh.params

---@since 3.17.0
---
---Message Direction: Client <-- Server
---@alias lsp.Request.workspace-inlayHint-refresh.params cjson.null?

---@since 3.17.0
---
---Message Direction: Client <-- Server
---@class lsp.Response.workspace-inlayHint-refresh : lsp.Response
---@field result? lsp.Response.workspace-inlayHint-refresh.result
---@field error? lsp.Response.workspace-inlayHint-refresh.error

---The document diagnostic request definition.
---@since 3.17.0
---
---Message Direction: Client --> Server
---
---Registration Options:
---@see lsp.DiagnosticRegistrationOptions
---@class lsp.Request.textDocument-diagnostic : lsp.Request
---@field method "textDocument/diagnostic"
---@field params lsp.Request.textDocument-diagnostic.params

---The document diagnostic request definition.
---@since 3.17.0
---
---Message Direction: Client --> Server
---
---Registration Options:
---@see lsp.DiagnosticRegistrationOptions
---@alias lsp.Request.textDocument-diagnostic.params lsp.DocumentDiagnosticParams

---The document diagnostic request definition.
---@since 3.17.0
---
---Message Direction: Client --> Server
---
---Registration Options:
---@see lsp.DiagnosticRegistrationOptions
---@class lsp.Response.textDocument-diagnostic : lsp.Response
---@field result? lsp.Response.textDocument-diagnostic.result
---@field error? lsp.Response.textDocument-diagnostic.error

---The workspace diagnostic request definition.
---@since 3.17.0
---
---Message Direction: Client --> Server
---@class lsp.Request.workspace-diagnostic : lsp.Request
---@field method "workspace/diagnostic"
---@field params lsp.Request.workspace-diagnostic.params

---The workspace diagnostic request definition.
---@since 3.17.0
---
---Message Direction: Client --> Server
---@alias lsp.Request.workspace-diagnostic.params lsp.WorkspaceDiagnosticParams

---The workspace diagnostic request definition.
---@since 3.17.0
---
---Message Direction: Client --> Server
---@class lsp.Response.workspace-diagnostic : lsp.Response
---@field result? lsp.Response.workspace-diagnostic.result
---@field error? lsp.Response.workspace-diagnostic.error

---The diagnostic refresh request definition.
---@since 3.17.0
---
---Message Direction: Client <-- Server
---@class lsp.Request.workspace-diagnostic-refresh : lsp.Request
---@field method "workspace/diagnostic/refresh"
---@field params lsp.Request.workspace-diagnostic-refresh.params

---The diagnostic refresh request definition.
---@since 3.17.0
---
---Message Direction: Client <-- Server
---@alias lsp.Request.workspace-diagnostic-refresh.params cjson.null?

---The diagnostic refresh request definition.
---@since 3.17.0
---
---Message Direction: Client <-- Server
---@class lsp.Response.workspace-diagnostic-refresh : lsp.Response
---@field result? lsp.Response.workspace-diagnostic-refresh.result
---@field error? lsp.Response.workspace-diagnostic-refresh.error

---A request to provide inline completions in a document. The request's parameter is of
---type {@link InlineCompletionParams}, the response is of type
---{@link InlineCompletion InlineCompletion[]} or a Thenable that resolves to such.
---@since 3.18.0
---@proposed
---
---Message Direction: Client --> Server
---
---Registration Options:
---@see lsp.InlineCompletionRegistrationOptions
---@class lsp.Request.textDocument-inlineCompletion : lsp.Request
---@field method "textDocument/inlineCompletion"
---@field params lsp.Request.textDocument-inlineCompletion.params

---A request to provide inline completions in a document. The request's parameter is of
---type {@link InlineCompletionParams}, the response is of type
---{@link InlineCompletion InlineCompletion[]} or a Thenable that resolves to such.
---@since 3.18.0
---@proposed
---
---Message Direction: Client --> Server
---
---Registration Options:
---@see lsp.InlineCompletionRegistrationOptions
---@alias lsp.Request.textDocument-inlineCompletion.params lsp.InlineCompletionParams

---A request to provide inline completions in a document. The request's parameter is of
---type {@link InlineCompletionParams}, the response is of type
---{@link InlineCompletion InlineCompletion[]} or a Thenable that resolves to such.
---@since 3.18.0
---@proposed
---
---Message Direction: Client --> Server
---
---Registration Options:
---@see lsp.InlineCompletionRegistrationOptions
---@class lsp.Response.textDocument-inlineCompletion : lsp.Response
---@field result? lsp.Response.textDocument-inlineCompletion.result
---@field error? lsp.Response.textDocument-inlineCompletion.error

---The `client/registerCapability` request is sent from the server to the client to register a new capability
---handler on the client side.
---
---Message Direction: Client <-- Server
---@class lsp.Request.client-registerCapability : lsp.Request
---@field method "client/registerCapability"
---@field params lsp.Request.client-registerCapability.params

---The `client/registerCapability` request is sent from the server to the client to register a new capability
---handler on the client side.
---
---Message Direction: Client <-- Server
---@alias lsp.Request.client-registerCapability.params lsp.RegistrationParams

---The `client/registerCapability` request is sent from the server to the client to register a new capability
---handler on the client side.
---
---Message Direction: Client <-- Server
---@class lsp.Response.client-registerCapability : lsp.Response
---@field result? lsp.Response.client-registerCapability.result
---@field error? lsp.Response.client-registerCapability.error

---The `client/unregisterCapability` request is sent from the server to the client to unregister a previously registered capability
---handler on the client side.
---
---Message Direction: Client <-- Server
---@class lsp.Request.client-unregisterCapability : lsp.Request
---@field method "client/unregisterCapability"
---@field params lsp.Request.client-unregisterCapability.params

---The `client/unregisterCapability` request is sent from the server to the client to unregister a previously registered capability
---handler on the client side.
---
---Message Direction: Client <-- Server
---@alias lsp.Request.client-unregisterCapability.params lsp.UnregistrationParams

---The `client/unregisterCapability` request is sent from the server to the client to unregister a previously registered capability
---handler on the client side.
---
---Message Direction: Client <-- Server
---@class lsp.Response.client-unregisterCapability : lsp.Response
---@field result? lsp.Response.client-unregisterCapability.result
---@field error? lsp.Response.client-unregisterCapability.error

---The initialize request is sent from the client to the server.
---It is sent once as the request after starting up the server.
---The requests parameter is of type {@link InitializeParams}
---the response if of type {@link InitializeResult} of a Thenable that
---resolves to such.
---
---Message Direction: Client --> Server
---@class lsp.Request.initialize : lsp.Request
---@field method "initialize"
---@field params lsp.Request.initialize.params

---The initialize request is sent from the client to the server.
---It is sent once as the request after starting up the server.
---The requests parameter is of type {@link InitializeParams}
---the response if of type {@link InitializeResult} of a Thenable that
---resolves to such.
---
---Message Direction: Client --> Server
---@alias lsp.Request.initialize.params lsp.InitializeParams

---The initialize request is sent from the client to the server.
---It is sent once as the request after starting up the server.
---The requests parameter is of type {@link InitializeParams}
---the response if of type {@link InitializeResult} of a Thenable that
---resolves to such.
---
---Message Direction: Client --> Server
---@class lsp.Response.initialize : lsp.Response
---@field result? lsp.Response.initialize.result
---@field error? lsp.Response.initialize.error

---A shutdown request is sent from the client to the server.
---It is sent once when the client decides to shutdown the
---server. The only notification that is sent after a shutdown request
---is the exit event.
---
---Message Direction: Client --> Server
---@class lsp.Request.shutdown : lsp.Request
---@field method "shutdown"
---@field params lsp.Request.shutdown.params

---A shutdown request is sent from the client to the server.
---It is sent once when the client decides to shutdown the
---server. The only notification that is sent after a shutdown request
---is the exit event.
---
---Message Direction: Client --> Server
---@alias lsp.Request.shutdown.params cjson.null?

---A shutdown request is sent from the client to the server.
---It is sent once when the client decides to shutdown the
---server. The only notification that is sent after a shutdown request
---is the exit event.
---
---Message Direction: Client --> Server
---@class lsp.Response.shutdown : lsp.Response
---@field result? lsp.Response.shutdown.result
---@field error? lsp.Response.shutdown.error

---The show message request is sent from the server to the client to show a message
---and a set of options actions to the user.
---
---Message Direction: Client <-- Server
---@class lsp.Request.window-showMessageRequest : lsp.Request
---@field method "window/showMessageRequest"
---@field params lsp.Request.window-showMessageRequest.params

---The show message request is sent from the server to the client to show a message
---and a set of options actions to the user.
---
---Message Direction: Client <-- Server
---@alias lsp.Request.window-showMessageRequest.params lsp.ShowMessageRequestParams

---The show message request is sent from the server to the client to show a message
---and a set of options actions to the user.
---
---Message Direction: Client <-- Server
---@class lsp.Response.window-showMessageRequest : lsp.Response
---@field result? lsp.Response.window-showMessageRequest.result
---@field error? lsp.Response.window-showMessageRequest.error

---A document will save request is sent from the client to the server before
---the document is actually saved. The request can return an array of TextEdits
---which will be applied to the text document before it is saved. Please note that
---clients might drop results if computing the text edits took too long or if a
---server constantly fails on this request. This is done to keep the save fast and
---reliable.
---
---Message Direction: Client --> Server
---
---Registration Options:
---@see lsp.TextDocumentRegistrationOptions
---@class lsp.Request.textDocument-willSaveWaitUntil : lsp.Request
---@field method "textDocument/willSaveWaitUntil"
---@field params lsp.Request.textDocument-willSaveWaitUntil.params

---A document will save request is sent from the client to the server before
---the document is actually saved. The request can return an array of TextEdits
---which will be applied to the text document before it is saved. Please note that
---clients might drop results if computing the text edits took too long or if a
---server constantly fails on this request. This is done to keep the save fast and
---reliable.
---
---Message Direction: Client --> Server
---
---Registration Options:
---@see lsp.TextDocumentRegistrationOptions
---@alias lsp.Request.textDocument-willSaveWaitUntil.params lsp.WillSaveTextDocumentParams

---A document will save request is sent from the client to the server before
---the document is actually saved. The request can return an array of TextEdits
---which will be applied to the text document before it is saved. Please note that
---clients might drop results if computing the text edits took too long or if a
---server constantly fails on this request. This is done to keep the save fast and
---reliable.
---
---Message Direction: Client --> Server
---
---Registration Options:
---@see lsp.TextDocumentRegistrationOptions
---@class lsp.Response.textDocument-willSaveWaitUntil : lsp.Response
---@field result? lsp.Response.textDocument-willSaveWaitUntil.result
---@field error? lsp.Response.textDocument-willSaveWaitUntil.error

---Request to request completion at a given text document position. The request's
---parameter is of type {@link TextDocumentPosition} the response
---is of type {@link CompletionItem CompletionItem[]} or {@link CompletionList}
---or a Thenable that resolves to such.
---The request can delay the computation of the {@link CompletionItem.detail `detail`}
---and {@link CompletionItem.documentation `documentation`} properties to the `completionItem/resolve`
---request. However, properties that are needed for the initial sorting and filtering, like `sortText`,
---`filterText`, `insertText`, and `textEdit`, must not be changed during resolve.
---
---Message Direction: Client --> Server
---
---Registration Options:
---@see lsp.CompletionRegistrationOptions
---@class lsp.Request.textDocument-completion : lsp.Request
---@field method "textDocument/completion"
---@field params lsp.Request.textDocument-completion.params

---Request to request completion at a given text document position. The request's
---parameter is of type {@link TextDocumentPosition} the response
---is of type {@link CompletionItem CompletionItem[]} or {@link CompletionList}
---or a Thenable that resolves to such.
---The request can delay the computation of the {@link CompletionItem.detail `detail`}
---and {@link CompletionItem.documentation `documentation`} properties to the `completionItem/resolve`
---request. However, properties that are needed for the initial sorting and filtering, like `sortText`,
---`filterText`, `insertText`, and `textEdit`, must not be changed during resolve.
---
---Message Direction: Client --> Server
---
---Registration Options:
---@see lsp.CompletionRegistrationOptions
---@alias lsp.Request.textDocument-completion.params lsp.CompletionParams

---Request to request completion at a given text document position. The request's
---parameter is of type {@link TextDocumentPosition} the response
---is of type {@link CompletionItem CompletionItem[]} or {@link CompletionList}
---or a Thenable that resolves to such.
---The request can delay the computation of the {@link CompletionItem.detail `detail`}
---and {@link CompletionItem.documentation `documentation`} properties to the `completionItem/resolve`
---request. However, properties that are needed for the initial sorting and filtering, like `sortText`,
---`filterText`, `insertText`, and `textEdit`, must not be changed during resolve.
---
---Message Direction: Client --> Server
---
---Registration Options:
---@see lsp.CompletionRegistrationOptions
---@class lsp.Response.textDocument-completion : lsp.Response
---@field result? lsp.Response.textDocument-completion.result
---@field error? lsp.Response.textDocument-completion.error

---Request to resolve additional information for a given completion item.The request's
---parameter is of type {@link CompletionItem} the response
---is of type {@link CompletionItem} or a Thenable that resolves to such.
---
---Message Direction: Client --> Server
---@class lsp.Request.completionItem-resolve : lsp.Request
---@field method "completionItem/resolve"
---@field params lsp.Request.completionItem-resolve.params

---Request to resolve additional information for a given completion item.The request's
---parameter is of type {@link CompletionItem} the response
---is of type {@link CompletionItem} or a Thenable that resolves to such.
---
---Message Direction: Client --> Server
---@alias lsp.Request.completionItem-resolve.params lsp.CompletionItem

---Request to resolve additional information for a given completion item.The request's
---parameter is of type {@link CompletionItem} the response
---is of type {@link CompletionItem} or a Thenable that resolves to such.
---
---Message Direction: Client --> Server
---@class lsp.Response.completionItem-resolve : lsp.Response
---@field result? lsp.Response.completionItem-resolve.result
---@field error? lsp.Response.completionItem-resolve.error

---Request to request hover information at a given text document position. The request's
---parameter is of type {@link TextDocumentPosition} the response is of
---type {@link Hover} or a Thenable that resolves to such.
---
---Message Direction: Client --> Server
---
---Registration Options:
---@see lsp.HoverRegistrationOptions
---@class lsp.Request.textDocument-hover : lsp.Request
---@field method "textDocument/hover"
---@field params lsp.Request.textDocument-hover.params

---Request to request hover information at a given text document position. The request's
---parameter is of type {@link TextDocumentPosition} the response is of
---type {@link Hover} or a Thenable that resolves to such.
---
---Message Direction: Client --> Server
---
---Registration Options:
---@see lsp.HoverRegistrationOptions
---@alias lsp.Request.textDocument-hover.params lsp.HoverParams

---Request to request hover information at a given text document position. The request's
---parameter is of type {@link TextDocumentPosition} the response is of
---type {@link Hover} or a Thenable that resolves to such.
---
---Message Direction: Client --> Server
---
---Registration Options:
---@see lsp.HoverRegistrationOptions
---@class lsp.Response.textDocument-hover : lsp.Response
---@field result? lsp.Response.textDocument-hover.result
---@field error? lsp.Response.textDocument-hover.error

---Message Direction: Client --> Server
---
---Registration Options:
---@see lsp.SignatureHelpRegistrationOptions
---@class lsp.Request.textDocument-signatureHelp : lsp.Request
---@field method "textDocument/signatureHelp"
---@field params lsp.Request.textDocument-signatureHelp.params

---Message Direction: Client --> Server
---
---Registration Options:
---@see lsp.SignatureHelpRegistrationOptions
---@alias lsp.Request.textDocument-signatureHelp.params lsp.SignatureHelpParams

---Message Direction: Client --> Server
---
---Registration Options:
---@see lsp.SignatureHelpRegistrationOptions
---@class lsp.Response.textDocument-signatureHelp : lsp.Response
---@field result? lsp.Response.textDocument-signatureHelp.result
---@field error? lsp.Response.textDocument-signatureHelp.error

---A request to resolve the definition location of a symbol at a given text
---document position. The request's parameter is of type {@link TextDocumentPosition}
---the response is of either type {@link Definition} or a typed array of
---{@link DefinitionLink} or a Thenable that resolves to such.
---
---Message Direction: Client --> Server
---
---Registration Options:
---@see lsp.DefinitionRegistrationOptions
---@class lsp.Request.textDocument-definition : lsp.Request
---@field method "textDocument/definition"
---@field params lsp.Request.textDocument-definition.params

---A request to resolve the definition location of a symbol at a given text
---document position. The request's parameter is of type {@link TextDocumentPosition}
---the response is of either type {@link Definition} or a typed array of
---{@link DefinitionLink} or a Thenable that resolves to such.
---
---Message Direction: Client --> Server
---
---Registration Options:
---@see lsp.DefinitionRegistrationOptions
---@alias lsp.Request.textDocument-definition.params lsp.DefinitionParams

---A request to resolve the definition location of a symbol at a given text
---document position. The request's parameter is of type {@link TextDocumentPosition}
---the response is of either type {@link Definition} or a typed array of
---{@link DefinitionLink} or a Thenable that resolves to such.
---
---Message Direction: Client --> Server
---
---Registration Options:
---@see lsp.DefinitionRegistrationOptions
---@class lsp.Response.textDocument-definition : lsp.Response
---@field result? lsp.Response.textDocument-definition.result
---@field error? lsp.Response.textDocument-definition.error

---A request to resolve project-wide references for the symbol denoted
---by the given text document position. The request's parameter is of
---type {@link ReferenceParams} the response is of type
---{@link Location Location[]} or a Thenable that resolves to such.
---
---Message Direction: Client --> Server
---
---Registration Options:
---@see lsp.ReferenceRegistrationOptions
---@class lsp.Request.textDocument-references : lsp.Request
---@field method "textDocument/references"
---@field params lsp.Request.textDocument-references.params

---A request to resolve project-wide references for the symbol denoted
---by the given text document position. The request's parameter is of
---type {@link ReferenceParams} the response is of type
---{@link Location Location[]} or a Thenable that resolves to such.
---
---Message Direction: Client --> Server
---
---Registration Options:
---@see lsp.ReferenceRegistrationOptions
---@alias lsp.Request.textDocument-references.params lsp.ReferenceParams

---A request to resolve project-wide references for the symbol denoted
---by the given text document position. The request's parameter is of
---type {@link ReferenceParams} the response is of type
---{@link Location Location[]} or a Thenable that resolves to such.
---
---Message Direction: Client --> Server
---
---Registration Options:
---@see lsp.ReferenceRegistrationOptions
---@class lsp.Response.textDocument-references : lsp.Response
---@field result? lsp.Response.textDocument-references.result
---@field error? lsp.Response.textDocument-references.error

---Request to resolve a {@link DocumentHighlight} for a given
---text document position. The request's parameter is of type {@link TextDocumentPosition}
---the request response is an array of type {@link DocumentHighlight}
---or a Thenable that resolves to such.
---
---Message Direction: Client --> Server
---
---Registration Options:
---@see lsp.DocumentHighlightRegistrationOptions
---@class lsp.Request.textDocument-documentHighlight : lsp.Request
---@field method "textDocument/documentHighlight"
---@field params lsp.Request.textDocument-documentHighlight.params

---Request to resolve a {@link DocumentHighlight} for a given
---text document position. The request's parameter is of type {@link TextDocumentPosition}
---the request response is an array of type {@link DocumentHighlight}
---or a Thenable that resolves to such.
---
---Message Direction: Client --> Server
---
---Registration Options:
---@see lsp.DocumentHighlightRegistrationOptions
---@alias lsp.Request.textDocument-documentHighlight.params lsp.DocumentHighlightParams

---Request to resolve a {@link DocumentHighlight} for a given
---text document position. The request's parameter is of type {@link TextDocumentPosition}
---the request response is an array of type {@link DocumentHighlight}
---or a Thenable that resolves to such.
---
---Message Direction: Client --> Server
---
---Registration Options:
---@see lsp.DocumentHighlightRegistrationOptions
---@class lsp.Response.textDocument-documentHighlight : lsp.Response
---@field result? lsp.Response.textDocument-documentHighlight.result
---@field error? lsp.Response.textDocument-documentHighlight.error

---A request to list all symbols found in a given text document. The request's
---parameter is of type {@link TextDocumentIdentifier} the
---response is of type {@link SymbolInformation SymbolInformation[]} or a Thenable
---that resolves to such.
---
---Message Direction: Client --> Server
---
---Registration Options:
---@see lsp.DocumentSymbolRegistrationOptions
---@class lsp.Request.textDocument-documentSymbol : lsp.Request
---@field method "textDocument/documentSymbol"
---@field params lsp.Request.textDocument-documentSymbol.params

---A request to list all symbols found in a given text document. The request's
---parameter is of type {@link TextDocumentIdentifier} the
---response is of type {@link SymbolInformation SymbolInformation[]} or a Thenable
---that resolves to such.
---
---Message Direction: Client --> Server
---
---Registration Options:
---@see lsp.DocumentSymbolRegistrationOptions
---@alias lsp.Request.textDocument-documentSymbol.params lsp.DocumentSymbolParams

---A request to list all symbols found in a given text document. The request's
---parameter is of type {@link TextDocumentIdentifier} the
---response is of type {@link SymbolInformation SymbolInformation[]} or a Thenable
---that resolves to such.
---
---Message Direction: Client --> Server
---
---Registration Options:
---@see lsp.DocumentSymbolRegistrationOptions
---@class lsp.Response.textDocument-documentSymbol : lsp.Response
---@field result? lsp.Response.textDocument-documentSymbol.result
---@field error? lsp.Response.textDocument-documentSymbol.error

---A request to provide commands for the given text document and range.
---
---Message Direction: Client --> Server
---
---Registration Options:
---@see lsp.CodeActionRegistrationOptions
---@class lsp.Request.textDocument-codeAction : lsp.Request
---@field method "textDocument/codeAction"
---@field params lsp.Request.textDocument-codeAction.params

---A request to provide commands for the given text document and range.
---
---Message Direction: Client --> Server
---
---Registration Options:
---@see lsp.CodeActionRegistrationOptions
---@alias lsp.Request.textDocument-codeAction.params lsp.CodeActionParams

---A request to provide commands for the given text document and range.
---
---Message Direction: Client --> Server
---
---Registration Options:
---@see lsp.CodeActionRegistrationOptions
---@class lsp.Response.textDocument-codeAction : lsp.Response
---@field result? lsp.Response.textDocument-codeAction.result
---@field error? lsp.Response.textDocument-codeAction.error

---Request to resolve additional information for a given code action.The request's
---parameter is of type {@link CodeAction} the response
---is of type {@link CodeAction} or a Thenable that resolves to such.
---
---Message Direction: Client --> Server
---@class lsp.Request.codeAction-resolve : lsp.Request
---@field method "codeAction/resolve"
---@field params lsp.Request.codeAction-resolve.params

---Request to resolve additional information for a given code action.The request's
---parameter is of type {@link CodeAction} the response
---is of type {@link CodeAction} or a Thenable that resolves to such.
---
---Message Direction: Client --> Server
---@alias lsp.Request.codeAction-resolve.params lsp.CodeAction

---Request to resolve additional information for a given code action.The request's
---parameter is of type {@link CodeAction} the response
---is of type {@link CodeAction} or a Thenable that resolves to such.
---
---Message Direction: Client --> Server
---@class lsp.Response.codeAction-resolve : lsp.Response
---@field result? lsp.Response.codeAction-resolve.result
---@field error? lsp.Response.codeAction-resolve.error

---A request to list project-wide symbols matching the query string given
---by the {@link WorkspaceSymbolParams}. The response is
---of type {@link SymbolInformation SymbolInformation[]} or a Thenable that
---resolves to such.
---@since 3.17.0 - support for WorkspaceSymbol in the returned data. Clients
--- need to advertise support for WorkspaceSymbols via the client capability
--- `workspace.symbol.resolveSupport`.
---
---Message Direction: Client --> Server
---
---Registration Options:
---@see lsp.WorkspaceSymbolRegistrationOptions
---@class lsp.Request.workspace-symbol : lsp.Request
---@field method "workspace/symbol"
---@field params lsp.Request.workspace-symbol.params

---A request to list project-wide symbols matching the query string given
---by the {@link WorkspaceSymbolParams}. The response is
---of type {@link SymbolInformation SymbolInformation[]} or a Thenable that
---resolves to such.
---@since 3.17.0 - support for WorkspaceSymbol in the returned data. Clients
--- need to advertise support for WorkspaceSymbols via the client capability
--- `workspace.symbol.resolveSupport`.
---
---Message Direction: Client --> Server
---
---Registration Options:
---@see lsp.WorkspaceSymbolRegistrationOptions
---@alias lsp.Request.workspace-symbol.params lsp.WorkspaceSymbolParams

---A request to list project-wide symbols matching the query string given
---by the {@link WorkspaceSymbolParams}. The response is
---of type {@link SymbolInformation SymbolInformation[]} or a Thenable that
---resolves to such.
---@since 3.17.0 - support for WorkspaceSymbol in the returned data. Clients
--- need to advertise support for WorkspaceSymbols via the client capability
--- `workspace.symbol.resolveSupport`.
---
---Message Direction: Client --> Server
---
---Registration Options:
---@see lsp.WorkspaceSymbolRegistrationOptions
---@class lsp.Response.workspace-symbol : lsp.Response
---@field result? lsp.Response.workspace-symbol.result
---@field error? lsp.Response.workspace-symbol.error

---A request to resolve the range inside the workspace
---symbol's location.
---@since 3.17.0
---
---Message Direction: Client --> Server
---@class lsp.Request.workspaceSymbol-resolve : lsp.Request
---@field method "workspaceSymbol/resolve"
---@field params lsp.Request.workspaceSymbol-resolve.params

---A request to resolve the range inside the workspace
---symbol's location.
---@since 3.17.0
---
---Message Direction: Client --> Server
---@alias lsp.Request.workspaceSymbol-resolve.params lsp.WorkspaceSymbol

---A request to resolve the range inside the workspace
---symbol's location.
---@since 3.17.0
---
---Message Direction: Client --> Server
---@class lsp.Response.workspaceSymbol-resolve : lsp.Response
---@field result? lsp.Response.workspaceSymbol-resolve.result
---@field error? lsp.Response.workspaceSymbol-resolve.error

---A request to provide code lens for the given text document.
---
---Message Direction: Client --> Server
---
---Registration Options:
---@see lsp.CodeLensRegistrationOptions
---@class lsp.Request.textDocument-codeLens : lsp.Request
---@field method "textDocument/codeLens"
---@field params lsp.Request.textDocument-codeLens.params

---A request to provide code lens for the given text document.
---
---Message Direction: Client --> Server
---
---Registration Options:
---@see lsp.CodeLensRegistrationOptions
---@alias lsp.Request.textDocument-codeLens.params lsp.CodeLensParams

---A request to provide code lens for the given text document.
---
---Message Direction: Client --> Server
---
---Registration Options:
---@see lsp.CodeLensRegistrationOptions
---@class lsp.Response.textDocument-codeLens : lsp.Response
---@field result? lsp.Response.textDocument-codeLens.result
---@field error? lsp.Response.textDocument-codeLens.error

---A request to resolve a command for a given code lens.
---
---Message Direction: Client --> Server
---@class lsp.Request.codeLens-resolve : lsp.Request
---@field method "codeLens/resolve"
---@field params lsp.Request.codeLens-resolve.params

---A request to resolve a command for a given code lens.
---
---Message Direction: Client --> Server
---@alias lsp.Request.codeLens-resolve.params lsp.CodeLens

---A request to resolve a command for a given code lens.
---
---Message Direction: Client --> Server
---@class lsp.Response.codeLens-resolve : lsp.Response
---@field result? lsp.Response.codeLens-resolve.result
---@field error? lsp.Response.codeLens-resolve.error

---A request to refresh all code actions
---@since 3.16.0
---
---Message Direction: Client <-- Server
---@class lsp.Request.workspace-codeLens-refresh : lsp.Request
---@field method "workspace/codeLens/refresh"
---@field params lsp.Request.workspace-codeLens-refresh.params

---A request to refresh all code actions
---@since 3.16.0
---
---Message Direction: Client <-- Server
---@alias lsp.Request.workspace-codeLens-refresh.params cjson.null?

---A request to refresh all code actions
---@since 3.16.0
---
---Message Direction: Client <-- Server
---@class lsp.Response.workspace-codeLens-refresh : lsp.Response
---@field result? lsp.Response.workspace-codeLens-refresh.result
---@field error? lsp.Response.workspace-codeLens-refresh.error

---A request to provide document links
---
---Message Direction: Client --> Server
---
---Registration Options:
---@see lsp.DocumentLinkRegistrationOptions
---@class lsp.Request.textDocument-documentLink : lsp.Request
---@field method "textDocument/documentLink"
---@field params lsp.Request.textDocument-documentLink.params

---A request to provide document links
---
---Message Direction: Client --> Server
---
---Registration Options:
---@see lsp.DocumentLinkRegistrationOptions
---@alias lsp.Request.textDocument-documentLink.params lsp.DocumentLinkParams

---A request to provide document links
---
---Message Direction: Client --> Server
---
---Registration Options:
---@see lsp.DocumentLinkRegistrationOptions
---@class lsp.Response.textDocument-documentLink : lsp.Response
---@field result? lsp.Response.textDocument-documentLink.result
---@field error? lsp.Response.textDocument-documentLink.error

---Request to resolve additional information for a given document link. The request's
---parameter is of type {@link DocumentLink} the response
---is of type {@link DocumentLink} or a Thenable that resolves to such.
---
---Message Direction: Client --> Server
---@class lsp.Request.documentLink-resolve : lsp.Request
---@field method "documentLink/resolve"
---@field params lsp.Request.documentLink-resolve.params

---Request to resolve additional information for a given document link. The request's
---parameter is of type {@link DocumentLink} the response
---is of type {@link DocumentLink} or a Thenable that resolves to such.
---
---Message Direction: Client --> Server
---@alias lsp.Request.documentLink-resolve.params lsp.DocumentLink

---Request to resolve additional information for a given document link. The request's
---parameter is of type {@link DocumentLink} the response
---is of type {@link DocumentLink} or a Thenable that resolves to such.
---
---Message Direction: Client --> Server
---@class lsp.Response.documentLink-resolve : lsp.Response
---@field result? lsp.Response.documentLink-resolve.result
---@field error? lsp.Response.documentLink-resolve.error

---A request to format a whole document.
---
---Message Direction: Client --> Server
---
---Registration Options:
---@see lsp.DocumentFormattingRegistrationOptions
---@class lsp.Request.textDocument-formatting : lsp.Request
---@field method "textDocument/formatting"
---@field params lsp.Request.textDocument-formatting.params

---A request to format a whole document.
---
---Message Direction: Client --> Server
---
---Registration Options:
---@see lsp.DocumentFormattingRegistrationOptions
---@alias lsp.Request.textDocument-formatting.params lsp.DocumentFormattingParams

---A request to format a whole document.
---
---Message Direction: Client --> Server
---
---Registration Options:
---@see lsp.DocumentFormattingRegistrationOptions
---@class lsp.Response.textDocument-formatting : lsp.Response
---@field result? lsp.Response.textDocument-formatting.result
---@field error? lsp.Response.textDocument-formatting.error

---A request to format a range in a document.
---
---Message Direction: Client --> Server
---
---Registration Options:
---@see lsp.DocumentRangeFormattingRegistrationOptions
---@class lsp.Request.textDocument-rangeFormatting : lsp.Request
---@field method "textDocument/rangeFormatting"
---@field params lsp.Request.textDocument-rangeFormatting.params

---A request to format a range in a document.
---
---Message Direction: Client --> Server
---
---Registration Options:
---@see lsp.DocumentRangeFormattingRegistrationOptions
---@alias lsp.Request.textDocument-rangeFormatting.params lsp.DocumentRangeFormattingParams

---A request to format a range in a document.
---
---Message Direction: Client --> Server
---
---Registration Options:
---@see lsp.DocumentRangeFormattingRegistrationOptions
---@class lsp.Response.textDocument-rangeFormatting : lsp.Response
---@field result? lsp.Response.textDocument-rangeFormatting.result
---@field error? lsp.Response.textDocument-rangeFormatting.error

---A request to format ranges in a document.
---@since 3.18.0
---@proposed
---
---Message Direction: Client --> Server
---
---Registration Options:
---@see lsp.DocumentRangeFormattingRegistrationOptions
---@class lsp.Request.textDocument-rangesFormatting : lsp.Request
---@field method "textDocument/rangesFormatting"
---@field params lsp.Request.textDocument-rangesFormatting.params

---A request to format ranges in a document.
---@since 3.18.0
---@proposed
---
---Message Direction: Client --> Server
---
---Registration Options:
---@see lsp.DocumentRangeFormattingRegistrationOptions
---@alias lsp.Request.textDocument-rangesFormatting.params lsp.DocumentRangesFormattingParams

---A request to format ranges in a document.
---@since 3.18.0
---@proposed
---
---Message Direction: Client --> Server
---
---Registration Options:
---@see lsp.DocumentRangeFormattingRegistrationOptions
---@class lsp.Response.textDocument-rangesFormatting : lsp.Response
---@field result? lsp.Response.textDocument-rangesFormatting.result
---@field error? lsp.Response.textDocument-rangesFormatting.error

---A request to format a document on type.
---
---Message Direction: Client --> Server
---
---Registration Options:
---@see lsp.DocumentOnTypeFormattingRegistrationOptions
---@class lsp.Request.textDocument-onTypeFormatting : lsp.Request
---@field method "textDocument/onTypeFormatting"
---@field params lsp.Request.textDocument-onTypeFormatting.params

---A request to format a document on type.
---
---Message Direction: Client --> Server
---
---Registration Options:
---@see lsp.DocumentOnTypeFormattingRegistrationOptions
---@alias lsp.Request.textDocument-onTypeFormatting.params lsp.DocumentOnTypeFormattingParams

---A request to format a document on type.
---
---Message Direction: Client --> Server
---
---Registration Options:
---@see lsp.DocumentOnTypeFormattingRegistrationOptions
---@class lsp.Response.textDocument-onTypeFormatting : lsp.Response
---@field result? lsp.Response.textDocument-onTypeFormatting.result
---@field error? lsp.Response.textDocument-onTypeFormatting.error

---A request to rename a symbol.
---
---Message Direction: Client --> Server
---
---Registration Options:
---@see lsp.RenameRegistrationOptions
---@class lsp.Request.textDocument-rename : lsp.Request
---@field method "textDocument/rename"
---@field params lsp.Request.textDocument-rename.params

---A request to rename a symbol.
---
---Message Direction: Client --> Server
---
---Registration Options:
---@see lsp.RenameRegistrationOptions
---@alias lsp.Request.textDocument-rename.params lsp.RenameParams

---A request to rename a symbol.
---
---Message Direction: Client --> Server
---
---Registration Options:
---@see lsp.RenameRegistrationOptions
---@class lsp.Response.textDocument-rename : lsp.Response
---@field result? lsp.Response.textDocument-rename.result
---@field error? lsp.Response.textDocument-rename.error

---A request to test and perform the setup necessary for a rename.
---@since 3.16 - support for default behavior
---
---Message Direction: Client --> Server
---@class lsp.Request.textDocument-prepareRename : lsp.Request
---@field method "textDocument/prepareRename"
---@field params lsp.Request.textDocument-prepareRename.params

---A request to test and perform the setup necessary for a rename.
---@since 3.16 - support for default behavior
---
---Message Direction: Client --> Server
---@alias lsp.Request.textDocument-prepareRename.params lsp.PrepareRenameParams

---A request to test and perform the setup necessary for a rename.
---@since 3.16 - support for default behavior
---
---Message Direction: Client --> Server
---@class lsp.Response.textDocument-prepareRename : lsp.Response
---@field result? lsp.Response.textDocument-prepareRename.result
---@field error? lsp.Response.textDocument-prepareRename.error

---A request send from the client to the server to execute a command. The request might return
---a workspace edit which the client will apply to the workspace.
---
---Message Direction: Client --> Server
---
---Registration Options:
---@see lsp.ExecuteCommandRegistrationOptions
---@class lsp.Request.workspace-executeCommand : lsp.Request
---@field method "workspace/executeCommand"
---@field params lsp.Request.workspace-executeCommand.params

---A request send from the client to the server to execute a command. The request might return
---a workspace edit which the client will apply to the workspace.
---
---Message Direction: Client --> Server
---
---Registration Options:
---@see lsp.ExecuteCommandRegistrationOptions
---@alias lsp.Request.workspace-executeCommand.params lsp.ExecuteCommandParams

---A request send from the client to the server to execute a command. The request might return
---a workspace edit which the client will apply to the workspace.
---
---Message Direction: Client --> Server
---
---Registration Options:
---@see lsp.ExecuteCommandRegistrationOptions
---@class lsp.Response.workspace-executeCommand : lsp.Response
---@field result? lsp.Response.workspace-executeCommand.result
---@field error? lsp.Response.workspace-executeCommand.error

---A request sent from the server to the client to modified certain resources.
---
---Message Direction: Client <-- Server
---@class lsp.Request.workspace-applyEdit : lsp.Request
---@field method "workspace/applyEdit"
---@field params lsp.Request.workspace-applyEdit.params

---A request sent from the server to the client to modified certain resources.
---
---Message Direction: Client <-- Server
---@alias lsp.Request.workspace-applyEdit.params lsp.ApplyWorkspaceEditParams

---A request sent from the server to the client to modified certain resources.
---
---Message Direction: Client <-- Server
---@class lsp.Response.workspace-applyEdit : lsp.Response
---@field result? lsp.Response.workspace-applyEdit.result
---@field error? lsp.Response.workspace-applyEdit.error

---@class lsp.InitializeResult.serverInfo
---The name of the server as defined by the server.
---@field name string
---The server's version as defined by the server.
---@field version? string

---@class lsp.CompletionList.itemDefaults.editRange.2
---@field insert lsp.Range
---@field replace lsp.Range

---@class lsp.CompletionList.itemDefaults
---A default commit character set.
---@since 3.17.0
---@field commitCharacters? (string)[]
---A default edit range.
---@since 3.17.0
---@field editRange? lsp.Range | lsp.CompletionList.itemDefaults.editRange.2
---A default insert text format.
---@since 3.17.0
---@field insertTextFormat? lsp.InsertTextFormat
---A default insert text mode.
---@since 3.17.0
---@field insertTextMode? lsp.InsertTextMode
---A default data value.
---@since 3.17.0
---@field data? lsp.LSPAny

---@class lsp.CodeAction.disabled
---Human readable description of why the code action is currently disabled.
---This is displayed in the code actions UI.
---@field reason string

---@class lsp.WorkspaceSymbol.location.2
---@field uri lsp.DocumentUri

---@class lsp.SemanticTokensOptions.range.2

---@class lsp.SemanticTokensOptions.full.2
---The server supports deltas for full documents.
---@field delta? boolean

---@class lsp.NotebookDocumentChangeEvent.cells.structure
---The change to the cell array.
---@field array lsp.NotebookCellArrayChange
---Additional opened cell text documents.
---@field didOpen? (lsp.TextDocumentItem)[]
---Additional closed cell text documents.
---@field didClose? (lsp.TextDocumentIdentifier)[]

---@class lsp.NotebookDocumentChangeEvent.cells.textContent
---@field document lsp.VersionedTextDocumentIdentifier
---@field changes (lsp.TextDocumentContentChangeEvent)[]

---@class lsp.NotebookDocumentChangeEvent.cells
---Changes to the cell structure to add or
---remove cells.
---@field structure? lsp.NotebookDocumentChangeEvent.cells.structure
---Changes to notebook cells properties like its
---kind, execution summary or metadata.
---@field data? (lsp.NotebookCell)[]
---Changes to the text content of notebook cells.
---@field textContent? (lsp.NotebookDocumentChangeEvent.cells.textContent)[]

---@class lsp._InitializeParams.clientInfo
---The name of the client as defined by the client.
---@field name string
---The client's version as defined by the client.
---@field version? string

---@class lsp.ServerCapabilities.workspace
---The server supports workspace folder.
---@since 3.6.0
---@field workspaceFolders? lsp.WorkspaceFoldersServerCapabilities
---The server is interested in notifications/requests for operations on files.
---@since 3.16.0
---@field fileOperations? lsp.FileOperationOptions

---@class lsp.CompletionOptions.completionItem
---The server has support for completion item label
---details (see also `CompletionItemLabelDetails`) when
---receiving a completion item in a resolve call.
---@since 3.17.0
---@field labelDetailsSupport? boolean

---@class lsp.NotebookDocumentSyncOptions.notebookSelector.1.cells
---@field language string

---@class lsp.NotebookDocumentSyncOptions.notebookSelector.1
---The notebook to be synced If a string
---value is provided it matches against the
---notebook type. '*' matches every notebook.
---@field notebook string | lsp.NotebookDocumentFilter
---The cells of the matching notebook to be synced.
---@field cells? (lsp.NotebookDocumentSyncOptions.notebookSelector.1.cells)[]

---@class lsp.NotebookDocumentSyncOptions.notebookSelector.2.cells
---@field language string

---@class lsp.NotebookDocumentSyncOptions.notebookSelector.2
---The notebook to be synced If a string
---value is provided it matches against the
---notebook type. '*' matches every notebook.
---@field notebook? string | lsp.NotebookDocumentFilter
---The cells of the matching notebook to be synced.
---@field cells (lsp.NotebookDocumentSyncOptions.notebookSelector.2.cells)[]

---@class lsp.GeneralClientCapabilities.staleRequestSupport
---The client will actively cancel the request.
---@field cancel boolean
---The list of requests for which the client
---will retry the request if it receives a
---response with error code `ContentModified`
---@field retryOnContentModified (string)[]

---@class lsp.WorkspaceEditClientCapabilities.changeAnnotationSupport
---Whether the client groups edits with equal labels into tree nodes,
---for instance all edits labelled with "Changes in Strings" would
---be a tree node.
---@field groupsOnLabel? boolean

---@class lsp.WorkspaceSymbolClientCapabilities.symbolKind
---The symbol kind values the client supports. When this
---property exists the client also guarantees that it will
---handle values outside its set gracefully and falls back
---to a default value when unknown.
---If this property is not present the client only supports
---the symbol kinds from `File` to `Array` as defined in
---the initial version of the protocol.
---@field valueSet? (lsp.SymbolKind)[]

---@class lsp.WorkspaceSymbolClientCapabilities.tagSupport
---The tags supported by the client.
---@field valueSet (lsp.SymbolTag)[]

---@class lsp.WorkspaceSymbolClientCapabilities.resolveSupport
---The properties that a client can resolve lazily. Usually
---`location.range`
---@field properties (string)[]

---@class lsp.CompletionClientCapabilities.completionItem.tagSupport
---The tags supported by the client.
---@field valueSet (lsp.CompletionItemTag)[]

---@class lsp.CompletionClientCapabilities.completionItem.resolveSupport
---The properties that a client can resolve lazily.
---@field properties (string)[]

---@class lsp.CompletionClientCapabilities.completionItem.insertTextModeSupport
---@field valueSet (lsp.InsertTextMode)[]

---@class lsp.CompletionClientCapabilities.completionItem
---Client supports snippets as insert text.
---A snippet can define tab stops and placeholders with `$1`, `$2`
---and `${3:foo}`. `$0` defines the final tab stop, it defaults to
---the end of the snippet. Placeholders with equal identifiers are linked,
---that is typing in one will update others too.
---@field snippetSupport? boolean
---Client supports commit characters on a completion item.
---@field commitCharactersSupport? boolean
---Client supports the following content formats for the documentation
---property. The order describes the preferred format of the client.
---@field documentationFormat? (lsp.MarkupKind)[]
---Client supports the deprecated property on a completion item.
---@field deprecatedSupport? boolean
---Client supports the preselect property on a completion item.
---@field preselectSupport? boolean
---Client supports the tag property on a completion item. Clients supporting
---tags have to handle unknown tags gracefully. Clients especially need to
---preserve unknown tags when sending a completion item back to the server in
---a resolve call.
---@since 3.15.0
---@field tagSupport? lsp.CompletionClientCapabilities.completionItem.tagSupport
---Client support insert replace edit to control different behavior if a
---completion item is inserted in the text or should replace text.
---@since 3.16.0
---@field insertReplaceSupport? boolean
---Indicates which properties a client can resolve lazily on a completion
---item. Before version 3.16.0 only the predefined properties `documentation`
---and `details` could be resolved lazily.
---@since 3.16.0
---@field resolveSupport? lsp.CompletionClientCapabilities.completionItem.resolveSupport
---The client supports the `insertTextMode` property on
---a completion item to override the whitespace handling mode
---as defined by the client (see `insertTextMode`).
---@since 3.16.0
---@field insertTextModeSupport? lsp.CompletionClientCapabilities.completionItem.insertTextModeSupport
---The client has support for completion item label
---details (see also `CompletionItemLabelDetails`).
---@since 3.17.0
---@field labelDetailsSupport? boolean

---@class lsp.CompletionClientCapabilities.completionItemKind
---The completion item kind values the client supports. When this
---property exists the client also guarantees that it will
---handle values outside its set gracefully and falls back
---to a default value when unknown.
---If this property is not present the client only supports
---the completion items kinds from `Text` to `Reference` as defined in
---the initial version of the protocol.
---@field valueSet? (lsp.CompletionItemKind)[]

---@class lsp.CompletionClientCapabilities.completionList
---The client supports the following itemDefaults on
---a completion list.
---The value lists the supported property names of the
---`CompletionList.itemDefaults` object. If omitted
---no properties are supported.
---@since 3.17.0
---@field itemDefaults? (string)[]

---@class lsp.SignatureHelpClientCapabilities.signatureInformation.parameterInformation
---The client supports processing label offsets instead of a
---simple label string.
---@since 3.14.0
---@field labelOffsetSupport? boolean

---@class lsp.SignatureHelpClientCapabilities.signatureInformation
---Client supports the following content formats for the documentation
---property. The order describes the preferred format of the client.
---@field documentationFormat? (lsp.MarkupKind)[]
---Client capabilities specific to parameter information.
---@field parameterInformation? lsp.SignatureHelpClientCapabilities.signatureInformation.parameterInformation
---The client supports the `activeParameter` property on `SignatureInformation`
---literal.
---@since 3.16.0
---@field activeParameterSupport? boolean

---@class lsp.DocumentSymbolClientCapabilities.symbolKind
---The symbol kind values the client supports. When this
---property exists the client also guarantees that it will
---handle values outside its set gracefully and falls back
---to a default value when unknown.
---If this property is not present the client only supports
---the symbol kinds from `File` to `Array` as defined in
---the initial version of the protocol.
---@field valueSet? (lsp.SymbolKind)[]

---@class lsp.DocumentSymbolClientCapabilities.tagSupport
---The tags supported by the client.
---@field valueSet (lsp.SymbolTag)[]

---@class lsp.CodeActionClientCapabilities.codeActionLiteralSupport.codeActionKind
---The code action kind values the client supports. When this
---property exists the client also guarantees that it will
---handle values outside its set gracefully and falls back
---to a default value when unknown.
---@field valueSet (lsp.CodeActionKind)[]

---@class lsp.CodeActionClientCapabilities.codeActionLiteralSupport
---The code action kind is support with the following value
---set.
---@field codeActionKind lsp.CodeActionClientCapabilities.codeActionLiteralSupport.codeActionKind

---@class lsp.CodeActionClientCapabilities.resolveSupport
---The properties that a client can resolve lazily.
---@field properties (string)[]

---@class lsp.FoldingRangeClientCapabilities.foldingRangeKind
---The folding range kind values the client supports. When this
---property exists the client also guarantees that it will
---handle values outside its set gracefully and falls back
---to a default value when unknown.
---@field valueSet? (lsp.FoldingRangeKind)[]

---@class lsp.FoldingRangeClientCapabilities.foldingRange
---If set, the client signals that it supports setting collapsedText on
---folding ranges to display custom labels instead of the default text.
---@since 3.17.0
---@field collapsedText? boolean

---@class lsp.PublishDiagnosticsClientCapabilities.tagSupport
---The tags supported by the client.
---@field valueSet (lsp.DiagnosticTag)[]

---@class lsp.SemanticTokensClientCapabilities.requests.range.2

---@class lsp.SemanticTokensClientCapabilities.requests.full.2
---The client will send the `textDocument/semanticTokens/full/delta` request if
---the server provides a corresponding handler.
---@field delta? boolean

---@class lsp.SemanticTokensClientCapabilities.requests
---The client will send the `textDocument/semanticTokens/range` request if
---the server provides a corresponding handler.
---@field range? boolean | lsp.SemanticTokensClientCapabilities.requests.range.2
---The client will send the `textDocument/semanticTokens/full` request if
---the server provides a corresponding handler.
---@field full? boolean | lsp.SemanticTokensClientCapabilities.requests.full.2

---@class lsp.InlayHintClientCapabilities.resolveSupport
---The properties that a client can resolve lazily.
---@field properties (string)[]

---@class lsp.ShowMessageRequestClientCapabilities.messageActionItem
---Whether the client supports additional attributes which
---are preserved and send back to the server in the
---request's response.
---@field additionalPropertiesSupport? boolean

---@class lsp.PrepareRenameResult.alias.2
---@field range lsp.Range
---@field placeholder string

---@class lsp.PrepareRenameResult.alias.3
---@field defaultBehavior boolean

---@class lsp.TextDocumentContentChangeEvent.alias.1
---The range of the document that changed.
---@field range lsp.Range
---The optional length of the range that got replaced.
---@deprecated use range instead.
---@field rangeLength? integer
---The new text for the provided range.
---@field text string

---@class lsp.TextDocumentContentChangeEvent.alias.2
---The new text of the whole document.
---@field text string

---@class lsp.MarkedString.alias.2
---@field language string
---@field value string

---@class lsp.TextDocumentFilter.alias.1
---A language id, like `typescript`.
---@field language string
---A Uri {@link Uri.scheme scheme}, like `file` or `untitled`.
---@field scheme? string
---A glob pattern, like **​/*.{ts,js}. See TextDocumentFilter for examples.
---@field pattern? string

---@class lsp.TextDocumentFilter.alias.2
---A language id, like `typescript`.
---@field language? string
---A Uri {@link Uri.scheme scheme}, like `file` or `untitled`.
---@field scheme string
---A glob pattern, like **​/*.{ts,js}. See TextDocumentFilter for examples.
---@field pattern? string

---@class lsp.TextDocumentFilter.alias.3
---A language id, like `typescript`.
---@field language? string
---A Uri {@link Uri.scheme scheme}, like `file` or `untitled`.
---@field scheme? string
---A glob pattern, like **​/*.{ts,js}. See TextDocumentFilter for examples.
---@field pattern string

---@class lsp.NotebookDocumentFilter.alias.1
---The type of the enclosing notebook.
---@field notebookType string
---A Uri {@link Uri.scheme scheme}, like `file` or `untitled`.
---@field scheme? string
---A glob pattern.
---@field pattern? string

---@class lsp.NotebookDocumentFilter.alias.2
---The type of the enclosing notebook.
---@field notebookType? string
---A Uri {@link Uri.scheme scheme}, like `file` or `untitled`.
---@field scheme string
---A glob pattern.
---@field pattern? string

---@class lsp.NotebookDocumentFilter.alias.3
---The type of the enclosing notebook.
---@field notebookType? string
---A Uri {@link Uri.scheme scheme}, like `file` or `untitled`.
---@field scheme? string
---A glob pattern.
---@field pattern string

---@alias lsp.Response.textDocument-implementation.result lsp.Definition | (lsp.DefinitionLink)[] | cjson.null

---@alias lsp.Response.textDocument-implementation.error lsp.ResponseError

---@alias lsp.Response.textDocument-typeDefinition.result lsp.Definition | (lsp.DefinitionLink)[] | cjson.null

---@alias lsp.Response.textDocument-typeDefinition.error lsp.ResponseError

---@alias lsp.Response.workspace-workspaceFolders.result (lsp.WorkspaceFolder)[] | cjson.null

---@alias lsp.Response.workspace-workspaceFolders.error lsp.ResponseError

---@alias lsp.Response.workspace-configuration.result (lsp.LSPAny)[]

---@alias lsp.Response.workspace-configuration.error lsp.ResponseError

---@alias lsp.Response.textDocument-documentColor.result (lsp.ColorInformation)[]

---@alias lsp.Response.textDocument-documentColor.error lsp.ResponseError

---@class lsp.Request.textDocument-colorPresentation.registrationOptions : lsp.WorkDoneProgressOptions, lsp.TextDocumentRegistrationOptions

---@alias lsp.Response.textDocument-colorPresentation.result (lsp.ColorPresentation)[]

---@alias lsp.Response.textDocument-colorPresentation.error lsp.ResponseError

---@alias lsp.Response.textDocument-foldingRange.result (lsp.FoldingRange)[] | cjson.null

---@alias lsp.Response.textDocument-foldingRange.error lsp.ResponseError

---@alias lsp.Response.workspace-foldingRange-refresh.result cjson.null

---@alias lsp.Response.workspace-foldingRange-refresh.error lsp.ResponseError

---@alias lsp.Response.textDocument-declaration.result lsp.Declaration | (lsp.DeclarationLink)[] | cjson.null

---@alias lsp.Response.textDocument-declaration.error lsp.ResponseError

---@alias lsp.Response.textDocument-selectionRange.result (lsp.SelectionRange)[] | cjson.null

---@alias lsp.Response.textDocument-selectionRange.error lsp.ResponseError

---@alias lsp.Response.window-workDoneProgress-create.result cjson.null

---@alias lsp.Response.window-workDoneProgress-create.error lsp.ResponseError

---@alias lsp.Response.textDocument-prepareCallHierarchy.result (lsp.CallHierarchyItem)[] | cjson.null

---@alias lsp.Response.textDocument-prepareCallHierarchy.error lsp.ResponseError

---@alias lsp.Response.callHierarchy-incomingCalls.result (lsp.CallHierarchyIncomingCall)[] | cjson.null

---@alias lsp.Response.callHierarchy-incomingCalls.error lsp.ResponseError

---@alias lsp.Response.callHierarchy-outgoingCalls.result (lsp.CallHierarchyOutgoingCall)[] | cjson.null

---@alias lsp.Response.callHierarchy-outgoingCalls.error lsp.ResponseError

---@alias lsp.Response.textDocument-semanticTokens-full.result lsp.SemanticTokens | cjson.null

---@alias lsp.Response.textDocument-semanticTokens-full.error lsp.ResponseError

---@alias lsp.Response.textDocument-semanticTokens-full-delta.result lsp.SemanticTokens | lsp.SemanticTokensDelta | cjson.null

---@alias lsp.Response.textDocument-semanticTokens-full-delta.error lsp.ResponseError

---@alias lsp.Response.textDocument-semanticTokens-range.result lsp.SemanticTokens | cjson.null

---@alias lsp.Response.textDocument-semanticTokens-range.error lsp.ResponseError

---@alias lsp.Response.workspace-semanticTokens-refresh.result cjson.null

---@alias lsp.Response.workspace-semanticTokens-refresh.error lsp.ResponseError

---@alias lsp.Response.window-showDocument.result lsp.ShowDocumentResult

---@alias lsp.Response.window-showDocument.error lsp.ResponseError

---@alias lsp.Response.textDocument-linkedEditingRange.result lsp.LinkedEditingRanges | cjson.null

---@alias lsp.Response.textDocument-linkedEditingRange.error lsp.ResponseError

---@alias lsp.Response.workspace-willCreateFiles.result lsp.WorkspaceEdit | cjson.null

---@alias lsp.Response.workspace-willCreateFiles.error lsp.ResponseError

---@alias lsp.Response.workspace-willRenameFiles.result lsp.WorkspaceEdit | cjson.null

---@alias lsp.Response.workspace-willRenameFiles.error lsp.ResponseError

---@alias lsp.Response.workspace-willDeleteFiles.result lsp.WorkspaceEdit | cjson.null

---@alias lsp.Response.workspace-willDeleteFiles.error lsp.ResponseError

---@alias lsp.Response.textDocument-moniker.result (lsp.Moniker)[] | cjson.null

---@alias lsp.Response.textDocument-moniker.error lsp.ResponseError

---@alias lsp.Response.textDocument-prepareTypeHierarchy.result (lsp.TypeHierarchyItem)[] | cjson.null

---@alias lsp.Response.textDocument-prepareTypeHierarchy.error lsp.ResponseError

---@alias lsp.Response.typeHierarchy-supertypes.result (lsp.TypeHierarchyItem)[] | cjson.null

---@alias lsp.Response.typeHierarchy-supertypes.error lsp.ResponseError

---@alias lsp.Response.typeHierarchy-subtypes.result (lsp.TypeHierarchyItem)[] | cjson.null

---@alias lsp.Response.typeHierarchy-subtypes.error lsp.ResponseError

---@alias lsp.Response.textDocument-inlineValue.result (lsp.InlineValue)[] | cjson.null

---@alias lsp.Response.textDocument-inlineValue.error lsp.ResponseError

---@alias lsp.Response.workspace-inlineValue-refresh.result cjson.null

---@alias lsp.Response.workspace-inlineValue-refresh.error lsp.ResponseError

---@alias lsp.Response.textDocument-inlayHint.result (lsp.InlayHint)[] | cjson.null

---@alias lsp.Response.textDocument-inlayHint.error lsp.ResponseError

---@alias lsp.Response.inlayHint-resolve.result lsp.InlayHint

---@alias lsp.Response.inlayHint-resolve.error lsp.ResponseError

---@alias lsp.Response.workspace-inlayHint-refresh.result cjson.null

---@alias lsp.Response.workspace-inlayHint-refresh.error lsp.ResponseError

---@alias lsp.Response.textDocument-diagnostic.result lsp.DocumentDiagnosticReport

---@alias lsp.Response.textDocument-diagnostic.error lsp.DiagnosticServerCancellationData

---@alias lsp.Response.workspace-diagnostic.result lsp.WorkspaceDiagnosticReport

---@alias lsp.Response.workspace-diagnostic.error lsp.DiagnosticServerCancellationData

---@alias lsp.Response.workspace-diagnostic-refresh.result cjson.null

---@alias lsp.Response.workspace-diagnostic-refresh.error lsp.ResponseError

---@alias lsp.Response.textDocument-inlineCompletion.result lsp.InlineCompletionList | (lsp.InlineCompletionItem)[] | cjson.null

---@alias lsp.Response.textDocument-inlineCompletion.error lsp.ResponseError

---@alias lsp.Response.client-registerCapability.result cjson.null

---@alias lsp.Response.client-registerCapability.error lsp.ResponseError

---@alias lsp.Response.client-unregisterCapability.result cjson.null

---@alias lsp.Response.client-unregisterCapability.error lsp.ResponseError

---@alias lsp.Response.initialize.result lsp.InitializeResult

---@alias lsp.Response.initialize.error lsp.InitializeError

---@alias lsp.Response.shutdown.result cjson.null

---@alias lsp.Response.shutdown.error lsp.ResponseError

---@alias lsp.Response.window-showMessageRequest.result lsp.MessageActionItem | cjson.null

---@alias lsp.Response.window-showMessageRequest.error lsp.ResponseError

---@alias lsp.Response.textDocument-willSaveWaitUntil.result (lsp.TextEdit)[] | cjson.null

---@alias lsp.Response.textDocument-willSaveWaitUntil.error lsp.ResponseError

---@alias lsp.Response.textDocument-completion.result (lsp.CompletionItem)[] | lsp.CompletionList | cjson.null

---@alias lsp.Response.textDocument-completion.error lsp.ResponseError

---@alias lsp.Response.completionItem-resolve.result lsp.CompletionItem

---@alias lsp.Response.completionItem-resolve.error lsp.ResponseError

---@alias lsp.Response.textDocument-hover.result lsp.Hover | cjson.null

---@alias lsp.Response.textDocument-hover.error lsp.ResponseError

---@alias lsp.Response.textDocument-signatureHelp.result lsp.SignatureHelp | cjson.null

---@alias lsp.Response.textDocument-signatureHelp.error lsp.ResponseError

---@alias lsp.Response.textDocument-definition.result lsp.Definition | (lsp.DefinitionLink)[] | cjson.null

---@alias lsp.Response.textDocument-definition.error lsp.ResponseError

---@alias lsp.Response.textDocument-references.result (lsp.Location)[] | cjson.null

---@alias lsp.Response.textDocument-references.error lsp.ResponseError

---@alias lsp.Response.textDocument-documentHighlight.result (lsp.DocumentHighlight)[] | cjson.null

---@alias lsp.Response.textDocument-documentHighlight.error lsp.ResponseError

---@alias lsp.Response.textDocument-documentSymbol.result (lsp.SymbolInformation)[] | (lsp.DocumentSymbol)[] | cjson.null

---@alias lsp.Response.textDocument-documentSymbol.error lsp.ResponseError

---@alias lsp.Response.textDocument-codeAction.result (lsp.Command | lsp.CodeAction)[] | cjson.null

---@alias lsp.Response.textDocument-codeAction.error lsp.ResponseError

---@alias lsp.Response.codeAction-resolve.result lsp.CodeAction

---@alias lsp.Response.codeAction-resolve.error lsp.ResponseError

---@alias lsp.Response.workspace-symbol.result (lsp.SymbolInformation)[] | (lsp.WorkspaceSymbol)[] | cjson.null

---@alias lsp.Response.workspace-symbol.error lsp.ResponseError

---@alias lsp.Response.workspaceSymbol-resolve.result lsp.WorkspaceSymbol

---@alias lsp.Response.workspaceSymbol-resolve.error lsp.ResponseError

---@alias lsp.Response.textDocument-codeLens.result (lsp.CodeLens)[] | cjson.null

---@alias lsp.Response.textDocument-codeLens.error lsp.ResponseError

---@alias lsp.Response.codeLens-resolve.result lsp.CodeLens

---@alias lsp.Response.codeLens-resolve.error lsp.ResponseError

---@alias lsp.Response.workspace-codeLens-refresh.result cjson.null

---@alias lsp.Response.workspace-codeLens-refresh.error lsp.ResponseError

---@alias lsp.Response.textDocument-documentLink.result (lsp.DocumentLink)[] | cjson.null

---@alias lsp.Response.textDocument-documentLink.error lsp.ResponseError

---@alias lsp.Response.documentLink-resolve.result lsp.DocumentLink

---@alias lsp.Response.documentLink-resolve.error lsp.ResponseError

---@alias lsp.Response.textDocument-formatting.result (lsp.TextEdit)[] | cjson.null

---@alias lsp.Response.textDocument-formatting.error lsp.ResponseError

---@alias lsp.Response.textDocument-rangeFormatting.result (lsp.TextEdit)[] | cjson.null

---@alias lsp.Response.textDocument-rangeFormatting.error lsp.ResponseError

---@alias lsp.Response.textDocument-rangesFormatting.result (lsp.TextEdit)[] | cjson.null

---@alias lsp.Response.textDocument-rangesFormatting.error lsp.ResponseError

---@alias lsp.Response.textDocument-onTypeFormatting.result (lsp.TextEdit)[] | cjson.null

---@alias lsp.Response.textDocument-onTypeFormatting.error lsp.ResponseError

---@alias lsp.Response.textDocument-rename.result lsp.WorkspaceEdit | cjson.null

---@alias lsp.Response.textDocument-rename.error lsp.ResponseError

---@alias lsp.Response.textDocument-prepareRename.result lsp.PrepareRenameResult | cjson.null

---@alias lsp.Response.textDocument-prepareRename.error lsp.ResponseError

---@alias lsp.Response.workspace-executeCommand.result lsp.LSPAny | cjson.null

---@alias lsp.Response.workspace-executeCommand.error lsp.ResponseError

---@alias lsp.Response.workspace-applyEdit.result lsp.ApplyWorkspaceEditResult

---@alias lsp.Response.workspace-applyEdit.error lsp.ResponseError