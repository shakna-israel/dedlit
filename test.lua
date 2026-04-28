local dedlit = require "dedlit"
assert(dedlit)

assert(dedlit.version)
assert(type(dedlit.version) == "table")
assert(#dedlit.version == 3)

assert(dedlit.get_line)
assert(dedlit.get_line("nolines") == 1)
assert(dedlit.get_line("nolines", 1) == 1)
assert(dedlit.get_line("nolines", 2) == 1)

assert(dedlit.get_line("oneline\ntwoline") == 2)
assert(dedlit.get_line("oneline\ntwoline", 6) == 1)
assert(dedlit.get_line("oneline\ntwoline", 8) == 2)

assert(dedlit.popsyntax)
assert(dedlit.pushsyntax)
assert(dedlit.issyntax)
assert(dedlit.syntax)

assert(dedlit.parse)
assert(dedlit.eval)
assert(dedlit.litfile)

-- syntax stack: default state
do
	local default = dedlit.syntax()
	assert(type(default) == "string")

	-- push returns the pushed pattern
	local pushed = dedlit.pushsyntax("##(.-)##")
	assert(pushed == "##(.-)##")
	assert(dedlit.syntax() == "##(.-)##")
	assert(dedlit.issyntax("##(.-)##"))
	assert(not dedlit.issyntax(default))

	-- pop returns what was removed and restores previous
	local popped = dedlit.popsyntax()
	assert(popped == "##(.-)##")
	assert(dedlit.syntax() == default)
	assert(dedlit.issyntax(default))
end

-- syntax stack: popping past empty re-inserts default
do
	local default = dedlit.syntax()
	dedlit.popsyntax()  -- removes default, but default is re-inserted
	assert(dedlit.syntax() == default)
end

-- syntax stack: multiple pushes are LIFO
do
	local default = dedlit.syntax()
	dedlit.pushsyntax("##(.-)##")
	dedlit.pushsyntax("%%(.-)%%")
	assert(dedlit.syntax() == "%%(.-)%%")
	dedlit.popsyntax()
	assert(dedlit.syntax() == "##(.-)##")
	dedlit.popsyntax()
	assert(dedlit.syntax() == default)
end

-- eval: side effects persist across calls (eval_env is stateful)
do
	dedlit.eval({"_test_x = 42"}, 1)
	dedlit.eval({"assert(_test_x == 42)"}, 1)
end

-- eval: mutations do not escape to _G
do
	dedlit.eval({"_test_sentinel = true"}, 1)
	assert(_test_sentinel == nil, "eval must not pollute _G")
end

-- eval: multiple expressions in one call all execute
do
	dedlit.eval({"_test_a = 1", "_test_b = 2"}, 1)
	dedlit.eval({"assert(_test_a == 1) assert(_test_b == 2)"}, 1)
end

-- eval: eval'd code can call pushsyntax and it affects lib.syntax()
do
	local default = dedlit.syntax()
	dedlit.eval({"pushsyntax('@@(.-)@@')"}, 1)
	assert(dedlit.syntax() == "@@(.-)@@")
	dedlit.popsyntax()
	assert(dedlit.syntax() == default)
end

-- eval: eval'd code can call popsyntax
do
	local default = dedlit.syntax()
	dedlit.pushsyntax("!!(.-)!!")
	assert(dedlit.syntax() == "!!(.-)!!")
	dedlit.eval({"popsyntax()"}, 1)
	assert(dedlit.syntax() == default)
end

-- eval: issyntax and syntax are accessible from eval'd code
do
	local default = dedlit.syntax()
	dedlit.eval({"assert(issyntax(syntax()))"}, 1)
	dedlit.pushsyntax("??(.-)??")
	dedlit.eval({"assert(issyntax('??(.-)??'))"}, 1)
	dedlit.eval({"assert(not issyntax('anything else'))"}, 1)
	dedlit.popsyntax()
end

-- parse: extracts and runs code blocks with default syntax
do
	dedlit.eval({"_test_parse_ran = false"}, 1)
	dedlit.parse("before\n```\n_test_parse_ran = true\n```\nafter")
	dedlit.eval({"assert(_test_parse_ran == true)"}, 1)
end

-- parse: multiple blocks all execute in order, with shared env
do
	dedlit.eval({"_test_order = {}"}, 1)
	dedlit.parse(
		"```\ntable.insert(_test_order, 1)\n```\n" ..
		"```\ntable.insert(_test_order, 2)\n```\n" ..
		"```\ntable.insert(_test_order, 3)\n```"
	)
	dedlit.eval({"assert(_test_order[1]==1 and _test_order[2]==2 and _test_order[3]==3)"}, 1)
end

-- parse: respects a pushed syntax and ignores default delimiters inside it
do
	local default = dedlit.syntax()
	dedlit.pushsyntax("##(.-)##")
	dedlit.eval({"_test_alt = false"}, 1)
	dedlit.parse("## _test_alt = true ##")
	dedlit.eval({"assert(_test_alt == true)"}, 1)
	-- default delimiters should be inert under the alt syntax
	dedlit.eval({"_test_default_inert = false"}, 1)
	dedlit.parse("``` _test_default_inert = true ```")
	dedlit.eval({"assert(_test_default_inert == false)"}, 1)
	dedlit.popsyntax()
	assert(dedlit.syntax() == default)
end

-- parse: eval'd pushsyntax mid-document shifts subsequent block extraction
do
	local default = dedlit.syntax()
	dedlit.eval({"_test_mid_push = false"}, 1)
	dedlit.parse(
		"```\npushsyntax('@@(.-)@@')\n```\n" ..
		"@@ _test_mid_push = true @@"
	)
	dedlit.eval({"assert(_test_mid_push == true)"}, 1)
	-- stack should have the pushed pattern still on it after parse
	assert(dedlit.syntax() == "@@(.-)@@")
	dedlit.popsyntax()
	assert(dedlit.syntax() == default)
end
