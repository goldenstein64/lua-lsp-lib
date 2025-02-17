local generate = require("scripts.doc.generate")
local lfs = require("lfs")

---@type fun(path: string): string
local function to_src_path(path)
	return "scripts/doc/src/" .. path
end

---@type fun(path: string): string
local function to_out_path(path)
	local out_path = path:gsub("%.etlua$", "")
	return "doc/" .. out_path
end

for path in lfs.dir("scripts/doc/src") do
	if path ~= "." and path ~= ".." then
		local src_path = to_src_path(path)
		local content = generate(src_path)

		local out_path = to_out_path(path)
		local out_file = assert(io.open(out_path, "w"))
		out_file:write(content)
		out_file:close()
		print(string.format("%s -> %s", src_path, out_path))
	end
end
