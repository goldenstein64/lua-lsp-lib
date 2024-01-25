local utf8 = require("compat53.utf8")

local utf8_next = utf8.codes("")

local function unit_of(text, i, byte_pos)
	i = utf8_next(text, i - 1)
	local unit = 0
	while i and i < byte_pos do
		unit = unit + 1
		i = utf8_next(text, i)
	end
	return unit
end

local function byte_of(text, i, unit_pos)
	i = i - 1
	local unit = 0
	while unit <= unit_pos do
		i = utf8_next(text, i)
		if i == nil then
			return string.len(text) + 1
		end
		unit = unit + 1
	end
	return i
end

---@type lsp*.transform_position.encoder
return { byte_of = byte_of, unit_of = unit_of }
