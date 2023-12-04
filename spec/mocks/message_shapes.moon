import types from require 'tableshape'

shape_if_table = (params) ->
	if 'table' == type params
		types.shape params
	else
		params


notif_shape = (method, params) ->
	types.shape { jsonrpc: '2.0', :method, params: shape_if_table params }

request_shape = (id, method, params) ->
	types.shape { jsonrpc: '2.0', :id, :method, params: shape_if_table params }

response_shape = (id, result, error) ->
	types.shape {
		jsonrpc: '2.0'
		:id
		result: shape_if_table result
		error: shape_if_table error
	}

{ :notif_shape, :request_shape, :response_shape }
