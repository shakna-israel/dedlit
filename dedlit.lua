local load = loadstring or load

local parse = function(str)
  local r = {}
  for w in str:gmatch("```(.-)```") do
    r[#r + 1] = w
  end
  return r
end

local eval = function(exp_tbl)
  for _, v in ipairs(exp_tbl) do
    local f = assert(load(v))
    f()
  end
end

local litfile = function(filename)
  local lines = {}
  for line in io.lines(filename) do
    lines[#lines + 1] = line
  end
  return eval(parse(table.concat(lines)))
end

if arg[1] ~= nil and arg[1] ~= "--help" then
  litfile(arg[1])
else
  print("dedlit v1.0.0, a dead simple literate Lua.\n")
  print("Usage: dedlit [file|--help]\n")
  print("dedlit expects that the given file contains any Lua snippets between three backticks either side.")
  print("e.g. ```print(\"Hello, World!\")```")
end
