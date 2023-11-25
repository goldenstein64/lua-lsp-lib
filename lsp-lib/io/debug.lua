local ok, inspect = pcall(require, "inspect")
assert(ok, "inspect module is required for debug functionality")

local json = require("cjson")

local notify = require("lsp-lib.notify")

local debug = {}

do
	local READ_REQUEST_FORMAT = "==> %s: %s"
	local READ_NOTIFICATION_FORMAT = "--> %s"
	function debug.read(data)
		local message
		if data.id then
			local display_id = data.id == json.null and "null" or data.id
			message = READ_REQUEST_FORMAT:format(display_id, data.method)
		else
			message = READ_NOTIFICATION_FORMAT:format(data.method)
		end
		notify.log.info(message)
	end
end

do
	local WRITE_RESPONSE_RESULT_FORMAT = "<== %s: %s"
	local WRITE_RESPONSE_ERROR_FORMAT = "<==!!= %s: %s"
	local WRITE_NOTIFICATION_FORMAT = "<-- %s"

	function debug.write(data)
		local message

		local display_id = data.id == json.null and "null" or data.id

		if data.result then
			message = WRITE_RESPONSE_RESULT_FORMAT:format(display_id, inspect(data.result))
		elseif data.error then
			message = WRITE_RESPONSE_ERROR_FORMAT:format(display_id, data.error.message)
		elseif data.method ~= "window/logMessage" then
			message = WRITE_NOTIFICATION_FORMAT:format(data.method)
		else
			return
		end

		notify.log.info(message)
	end
end

return debug
