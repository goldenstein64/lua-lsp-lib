luassert = require 'luassert'
say = require 'say'

has_status = (status) -> (args) =>
	{ thread, failure_message } = args
	@failure_message = failure_message if failure_message ~= nil

	assert type(thread) == 'thread', "argument #1 is not a thread"
	status == coroutine.status thread

for _, status in ipairs{ 'running', 'normal', 'suspended', 'dead' } do
	say\set "assertions.thread_#{status}.positive", "expected thread to be #{status}"
	say\set "assertions.thread_#{status}.negative", "expected thread not to be #{status}"

	luassert\register(
		'assertion'
		"thread_#{status}"
		has_status status
		"assertions.thread_#{status}.positive"
		"assertions.thread_#{status}.negative"
	)
