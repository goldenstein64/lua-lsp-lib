---A utility function for calling a function `f` asynchronously with arguments
---`...`. A `thread` object representing the call is returned.
---@param f function
---@param ... any
---@return thread thread, boolean ok, any ...
return function(f, ...)
	local thread = coroutine.create(f)
	return thread, coroutine.resume(thread, ...)
end
