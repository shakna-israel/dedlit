local dedlit = require "dedlit"
assert(dedlit)

assert(dedlit.version)
assert(type(dedlit.version) == "table")
assert(#dedlit.version == 3)
