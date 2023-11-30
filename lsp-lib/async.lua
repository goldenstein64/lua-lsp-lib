---A utility function for running a function `f` asynchronously with arguments
---`...`
---@param f function
---@param ... any
---@return thread
return function(f, ...)
	local thread = coroutine.create(f)
	coroutine.resume(thread, ...)
	return thread
end
