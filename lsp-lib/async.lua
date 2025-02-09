---a utility function for calling a function `f` asynchronously with arguments
---`...`. A `thread` object representing the call is returned.
---@alias lsp-lib.Async fun(f: function, ...: any): (thread: thread, ok: boolean, ...: any)

---@type lsp-lib.Async
return function(f, ...)
	local thread = coroutine.create(f)
	return thread, coroutine.resume(thread, ...)
end
