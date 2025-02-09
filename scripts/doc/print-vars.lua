local cjson = require("cjson")

local file = assert(io.open("./doc/out/doc.json"))

local json = cjson.decode(file:read("a"))

---@param row string[] | "---"
---@param max_column_widths number[]
---@return string
local function to_row_string(row, max_column_widths)
	---@type string[]
	local str = {}
	if row == "---" then
		---@cast row "---"
		for _, width in ipairs(max_column_widths) do
			table.insert(str, string.rep("-", width))
		end
	else
		---@cast row string[]
		for i, elem in ipairs(row) do
			local width = max_column_widths[i]
			if elem == "---" then
				table.insert(str, string.rep("-", width))
			else
				local filler = string.rep(" ", width - #elem)
				table.insert(str, elem .. filler)
			end
		end
	end

	return string.format("| %s |", table.concat(str, " | "))
end

---@param data string[][]
---@param headers? string[]
local function to_table_string(data, headers)
	local max_column_widths = { 0, 0, 0 }
	if headers then
		for i, elem in ipairs(headers) do
			max_column_widths[i] = math.max(max_column_widths[i], #elem)
		end
	end

	for _, row in ipairs(data) do
		for i, elem in ipairs(row) do
			max_column_widths[i] = math.max(max_column_widths[i], #elem)
		end
	end

	---@type string[]
	local str = {}

	if headers then
		table.insert(str, to_row_string(headers, max_column_widths))
		table.insert(str, to_row_string("---", max_column_widths))
	end

	for _, row in ipairs(data) do
		table.insert(str, to_row_string(row, max_column_widths))
	end

	return table.concat(str, "\n")
end

---@type string[][]
local table_view = {}

for _, elem in ipairs(json) do
	local name = elem.name ---@type string
	if name:match("^lsp%-lib") then
		table.insert(
			table_view,
			{ tostring(name), tostring(elem.type), tostring(elem.view) }
		)
	end
end

print(to_table_string(table_view, { "name", "type", "view" }))
