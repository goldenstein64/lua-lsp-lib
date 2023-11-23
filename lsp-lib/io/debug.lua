local json = require("dkjson")

local logMessage = require("routes.window.logMessage")

local debug = {}

do
	local READ_REQUEST_FORMAT = "==> %s: %s"
	local READ_NOTIFICATION_FORMAT = "--> %s"
	function debug.read(data)
		local message
		if data.id then
			local displayId = data.id == json.null and "null" or data.id
			message = READ_REQUEST_FORMAT:format(displayId, data.method)
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

	local displayResultOptions = {
		indent = true,
		exception = function(reason, value, _, defaultMessage)
			if reason == "custom encoder failed" then
				return tostring(value)
			elseif reason == "unsupported type" then
				return tostring(value)
			else
				return nil, defaultMessage
			end
		end
	}

	function debug.write(data)
		local message

		local displayId = data.id == json.null and "null" or data.id

		if data.result then
			local displayResult = json.encode(data.result, displayResultOptions)
			message = WRITE_RESPONSE_RESULT_FORMAT:format(displayId, displayResult)
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
