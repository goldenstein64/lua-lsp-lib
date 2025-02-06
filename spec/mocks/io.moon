import insert, concat from table

json = require('cjson').new!
json.decode_array_with_array_mt true

io_lsp = require 'lsp-lib.io'

http_encode = (content) -> "Content-Length: #{#content}\n\n#{content}"

request_of = (id, method, params) -> { jsonrpc: '2.0', :id, :method, :params }
notif_of = (method, params) -> { jsonrpc: '2.0', :method, :params }
response_of = (id, result, err) -> { jsonrpc: '2.0', :id, :result, error: err }

class MockProvider
	line_ending: '\n'

	new: (requests) =>
		@input = ''
		@output = {}
		@i = 1
		@mock_encode requests if requests

	---reads from input provided at construction
	read: (bytes) =>
		-- print '<==', bytes
		result = @input\sub @i, @i + bytes - 1
		assert #result == bytes, 'end of stream reached!'
		@i += bytes
		result

	---writes to @output
	write: (data) =>
		-- print '==>', data
		insert @output, data

	mock_encode: (requests) =>
		str_requests = [http_encode json.encode request for request in *requests]
		@input ..= concat str_requests

	mock_output: =>
		responses = {}
		content = concat @output
		index = 1
		while index <= #content
			local len
			while true
				line, index = content\match '([^\n]*)\n()', index
				break if line == ''
				key, value = line\match '^([%w-]+): (.+)$'
				assert key, 'line not matched'
				len = assert tonumber value if key\lower! == 'content-length'

			assert len, 'length not found for response'
			response_content = content\sub index, index + len - 1
			-- print response_content\gsub('\n', '\\n')\gsub('\r', '\\r')
			insert responses, response_content
			index += len

		[json.decode response for response in *responses]

set_provider = (...) ->
	provider = MockProvider ...
	io_lsp.provider = provider
	provider

initialize_request = (id) ->
	request_of id, 'initialize', {
		processId: null
		rootUri: null
		capabilities: {}
	}

shutdown_request = (id) -> request_of id, 'shutdown', null

exit_notif = notif_of 'exit', null

{
	:MockProvider, :set_provider
	:request_of, :notif_of, :response_of
	:initialize_request, :shutdown_request, :exit_notif
}
