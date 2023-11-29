return function(f, ...)
	local thread = coroutine.create(f)
	coroutine.resume(thread, ...)
	return thread
end
