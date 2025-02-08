local cjson = require("cjson")

local file = assert(io.open("./doc/out/doc.json"))

local json = cjson.decode(file:read("a"))

---@type string[][]
local table_view = {
	{ "name", "type", "view" },
	{ "---", "---", "---" },
}

for _, elem in ipairs(json) do
	local name = elem.name ---@type string
	table.insert(
		table_view,
		{ tostring(name), tostring(elem.type), tostring(elem.view) }
	)
end

local max_column_widths = { 0, 0, 0 }
for _, row in ipairs(table_view) do
	for i, elem in ipairs(row) do
		max_column_widths[i] = math.max(max_column_widths[i], #elem)
	end
end

---@type string[]
local table_str = {}
for _, row in ipairs(table_view) do
	---@type string[]
	local str = {}
	for i, elem in ipairs(row) do
		if elem == "---" then
			table.insert(str, string.rep("-", max_column_widths[i]))
		else
			local filler = string.rep(" ", max_column_widths[i] - #elem)
			table.insert(str, elem .. filler)
		end
	end

	table.insert(table_str, "| " .. table.concat(str, " | ") .. " |")
end

print(table.concat(table_str, "\n"))
