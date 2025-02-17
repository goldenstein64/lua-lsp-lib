---@param cmd string
---@return string
local function exec(cmd)
	local prog = assert(io.popen("where lua-language-server.exe"))
	local output = prog:read("a")
	prog:close()
	if output == nil then
		return ""
	elseif type(output) ~= "string" then
		output = tostring(output)
	end
	---@cast output string
	return string.match(output, "^%s*(.-)%s*$")
end

---@return string?
local function detect_language_server_path()
	-- try to detect the language server path
	if package.config:sub(1, 1) == "\\" then -- on Windows
		-- just try to find it on the path
		local path = exec("where lua-language-server"):match("^[^\n]*")
		if path ~= "" then
			return path
		else -- too lazy to figure out what else to do
			return nil
		end
	else -- on Linux-ish
		-- just try to find it on the path
		local path = exec("which lua-language-server"):match("^[^\n]*")
		if path ~= "" then
			return path
		else -- too lazy to figure out what else to do
			return nil
		end
	end
end

local language_server_path = ... or detect_language_server_path()

assert(
	language_server_path,
	"unable to find the language server path; pass it as the first argument"
)

os.execute(
	string.format(
		"%s --doc lsp-lib --doc_out_path ./scripts/doc/out",
		language_server_path
	)
)
