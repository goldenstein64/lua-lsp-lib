---A utility function for calling a function `f` asynchronously with arguments
---`...`. A `thread` object representing the call is returned.
---@alias lsp*.Async fun(f: function, ...: any): (thread: thread, ok: boolean, ...: any)

---@type lsp*.Async
return function(f, ...)
	local thread = coroutine.create(f)
	return thread, coroutine.resume(thread, ...)
end
