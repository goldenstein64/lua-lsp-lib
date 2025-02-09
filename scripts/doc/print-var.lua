local cjson = require("cjson")
local inspect = require("inspect")
local path = require("path")

print(path.resolve("./doc/out/doc.json"))

local file = assert(io.open("./doc/out/doc.json"))

local json = cjson.decode(file:read("a"))

local var = ... or "lsp-lib"
for _, elem in ipairs(json) do
    if elem.name == var then
        -- print(inspect(elem.defines[1], { depth = 1 }))
        print(string.format("# `%s`", elem.name:gsub("lsp%*", "lsp")))
        print()
        print(elem.defines[1].desc)
        print()
        for _, field in ipairs(elem.fields) do
            print(string.format("## `%s.%s`", elem.name:gsub("lsp%*", "lsp"), field.name))
            print()
            print(field.desc)
            print()
        end
        break
    end
end