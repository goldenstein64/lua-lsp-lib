local utf8 = require("compat53.utf8")

local utf8_encoder = {}

---@param text string
---@param i integer
---@param byte_pos integer
---@return integer unit_pos
function utf8_encoder.unit_of(text, i, byte_pos)
	return byte_pos - i
end

---@param text string
---@param i integer
---@param unit_pos integer
---@return integer byte_pos
function utf8_encoder.byte_of(text, i, unit_pos)
	local byte_pos = i + unit_pos
	local text_len = string.len(text)
	if byte_pos > text_len then
		return text_len + 1
	else
		return byte_pos
	end
end

return utf8_encoder
