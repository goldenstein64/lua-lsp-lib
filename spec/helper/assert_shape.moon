-- copied from https://github.com/leafo/tableshape/blob/88755361cfeab725f193b98fbee3930cb5fb959c/tableshape/luassert.moon
-- this installs luassert assertion and formatter for tableshape types

say = require "say"
assert = require "luassert"
import is_type from require 'tableshape'

say\set "assertion.shape.positive",
	"Expected tableshape type to match.\nPassed in:\n%s\nExpected:\n%s"

say\set "assertion.shape.negative",
	"Expected tableshape type not to match.\nPassed in:\n%s\nDid not expect:\n%s"

assert\register(
	"assertion",
	"shape"

	(state, arguments) ->
		{ input, expected } = arguments
		assert is_type(expected), "Expected tableshape type for second argument to assert.shape"
		if expected input
			true
		else
			false

	"assertion.shape.positive"
	"assertion.shape.negative"
)

assert\add_formatter (v) ->
	if is_type v
		return tostring v
