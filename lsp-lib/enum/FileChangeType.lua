---The file event type
---@enum lsp.FileChangeType
local FileChangeType = {
	---The file got created.
	Created = 1,

	---The file got changed.
	Changed = 2,

	---The file got deleted.
	Deleted = 3,
}

return FileChangeType
