---@param text string
---@param i integer
---@param byte_pos integer
---@return integer unit_pos
local function unit_of(text, i, byte_pos)
	return byte_pos - i
end

---@param text string
---@param i integer
---@param unit_pos integer
---@return integer byte_pos
local function byte_of(text, i, unit_pos)
	local byte_pos = i + unit_pos
	local text_len = string.len(text)
	if byte_pos > text_len then
		return text_len + 1
	else
		return byte_pos
	end
end

---@type lsp-lib.transform_position.Encoder
return { byte_of = byte_of, unit_of = unit_of }
