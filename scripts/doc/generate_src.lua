local language_server_path = ...
if package.config:sub(1, 1) == "\\" then -- on Windows
	language_server_path = language_server_path
		or "%USERPROFILE%\\.vscode\\extensions\\sumneko.lua-3.13.6-win32-x64\\server\\bin\\lua-language-server.exe"
end

assert(
	language_server_path,
	"pass the language server path as the first argument"
)

os.execute(
	string.format(
		"%s --doc lsp-lib --doc_out_path ./doc/out",
		language_server_path
	)
)
