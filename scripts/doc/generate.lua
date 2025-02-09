local cjson = require("cjson")

local MarkdownParser = require("scripts.doc.MarkdownParser")

local text = io.read("a")

local docFile = assert(io.open("./doc/out/doc.json"))
local json = cjson.decode(docFile:read("a"))
local globals = {}
for _, elem in ipairs(json) do
  if elem.name:match("^lsp-lib") then
    -- populate globals
  end
end

local parser = MarkdownParser()

-- globals table should be more expressive than this!
io.write(parser:run(parser:load(text), globals))