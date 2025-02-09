local muun = require("pkg.muun")
local etlua = require("etlua")

local Parser = etlua.Parser

local MarkdownParser = muun("MarkdownParser", Parser)

MarkdownParser.open_tag = '{{'
MarkdownParser.close_tag = '}}'

return MarkdownParser