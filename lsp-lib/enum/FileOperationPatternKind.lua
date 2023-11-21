---A pattern kind describing if a glob pattern matches a file a folder or
---both.
---@since 3.16.0
---@enum lsp.FileOperationPatternKind
local FileOperationPatternKind = {
	---The pattern matches a file only.
	file = "file",

	---The pattern matches a folder only.
	folder = "folder",
}

return FileOperationPatternKind