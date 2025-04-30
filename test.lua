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

assert(dedlit.popsyntax)
assert(dedlit.pushsyntax)
assert(dedlit.issyntax)
assert(dedlit.syntax)

assert(dedlit.syntax() == "```(.-)```")
assert(dedlit.issyntax() == false)
assert(dedlit.issyntax(dedlit.syntax()) == true)

assert(dedlit.pushsyntax("##(.-)##"))
assert(dedlit.issyntax() == false)
assert(dedlit.issyntax("```(.-)```") == false)
assert(dedlit.issyntax("##(.-)##") == true)
assert(dedlit.popsyntax())
assert(dedlit.issyntax("##(.-)##") == false)
assert(dedlit.issyntax("```(.-)```") == true)

do
	local test_limit = 1000
	for i=1, test_limit do
		local v = string.format("#%d(.-)%d#", i, i)
		assert(dedlit.pushsyntax(v))
		assert(dedlit.issyntax(v))
	end

	for i=test_limit, 1, -1 do
		local v = string.format("#%d(.-)%d#", i, i)
		assert(dedlit.issyntax(v))
		assert(dedlit.popsyntax())
	end
end

assert(dedlit.parse)
assert(dedlit.eval)
assert(dedlit.litfile)

