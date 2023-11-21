local inspect = require("inspect")
local json = require("dkjson")

local logMessage = require("routes.window.logMessage")

local debug = {}

do
	local READ_REQUEST_FORMAT = "==> %s: %s"
	local READ_NOTIFICATION_FORMAT = "--> %s"
	function debug.read(data)
		local message
		if data.id then
			message = READ_REQUEST_FORMAT:format(data.id, data.method)
		else
			message = READ_NOTIFICATION_FORMAT:format(data.method)
		end
		logMessage.write(message, "info")
	end
end

do
	local WRITE_RESPONSE_RESULT_FORMAT = "<== %s: %s"
	local WRITE_RESPONSE_ERROR_FORMAT = "<==!!= %s: %s"
	local WRITE_NOTIFICATION_FORMAT = "<-- %s"
	function debug.write(data)
		local message

		local displayId = data.id == json.null and "null" or data.id

		if data.result then
			message = WRITE_RESPONSE_RESULT_FORMAT:format(displayId, inspect(data.result))
		elseif data.error then
			message = WRITE_RESPONSE_ERROR_FORMAT:format(displayId, data.error.message)
		elseif data.method ~= "window/logMessage" then
			message = WRITE_NOTIFICATION_FORMAT:format(data.method)
		else
			return
		end

		logMessage.write(message, "info")
	end
end

return debug
