---Moniker uniqueness level to define scope of the moniker.
---@since 3.16.0
---@enum lsp.UniquenessLevel
local UniquenessLevel = {
	---The moniker is only unique inside a document
	document = "document",

	---The moniker is unique inside a project for which a dump got created
	project = "project",

	---The moniker is unique inside the group to which a project belongs
	group = "group",

	---The moniker is unique inside the moniker scheme.
	scheme = "scheme",

	---The moniker is globally unique
	global = "global",
}

return UniquenessLevel