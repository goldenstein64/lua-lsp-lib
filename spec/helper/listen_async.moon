assert = require 'luassert'
lsp = require 'lsp-lib'

listen_wrapper = (...) -> lsp.listen ...

->
	thread = coroutine.create listen_wrapper
	ok, reason = coroutine.resume thread, false
	assert.is_true ok, reason
	thread
