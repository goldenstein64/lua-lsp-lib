local utf8 = require("compat53.utf8")

local utf8_next = utf8.codes("")

---@param codepoint integer
---@return integer unit -- in UTF-16 code units
local function utf16_size_of(codepoint)
	if codepoint < 0x10000 then
		return 1
	else
		return 2
	end
end

---@param text string
---@param i integer -- line start in bytes
---@param byte_pos integer -- starting from the first byte of text
---@return integer unit_pos
local function unit_of(text, i, byte_pos)
	local codepoint
	i, codepoint = utf8_next(text, i - 1)
	local unit = 0
	while i and i < byte_pos do
		unit = unit + utf16_size_of(codepoint)
		i, codepoint = utf8_next(text, i)
	end
	return unit
end

---@param text string
---@param i integer -- line start in bytes
---@param unit_pos integer
---@return integer byte_pos
local function byte_of(text, i, unit_pos)
	i = i - 1 -- start at line break
	local unit = 0
	while unit <= unit_pos do
		local codepoint
		i, codepoint = utf8_next(text, i)
		if i == nil then
			return string.len(text) + 1
		end
		unit = unit + utf16_size_of(codepoint)
	end
	return i
end

---@type lsp-lib.transform_position.Encoder
return { byte_of = byte_of, unit_of = unit_of }
