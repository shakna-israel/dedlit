local dedlit = require "dedlit"
assert(dedlit)

assert(dedlit.version)
assert(type(dedlit.version) == "table")
assert(#dedlit.version == 3)

assert(dedlit.get_line)
assert(dedlit.get_line("nolines") == 1)
assert(dedlit.get_line("nolines", 1) == 1)
assert(dedlit.get_line("nolines", 2) == 1)

assert(dedlit.popsyntax)
assert(dedlit.pushsyntax)
assert(dedlit.issyntax)
assert(dedlit.syntax)

assert(dedlit.parse)
assert(dedlit.eval)
assert(dedlit.litfile)
