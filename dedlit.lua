do
	local load = loadstring or load
	local concat = concat or table.concat
	local lib = {}

	lib.parse = function(str)
		local r = {}
		for w in str:gmatch("```(.-)```") do
			r[#r + 1] = w
		end
		return r
	end

	lib.eval = function(exp_tbl)
		for _, v in ipairs(exp_tbl) do
			local f = assert(load(v))
			f()
		end
	end

	lib.litfile = function(filename)
		local lines = {}
		for line in io.lines(filename) do
			lines[#lines + 1] = line .. "\n"
		end
		return lib.eval(lib.parse(concat(lines)))
	end

	if arg then
		if arg[1] ~= nil and arg[1] ~= "--help" then
			return lib.litfile(arg[1])
		else
			print("dedlit v1.0.0, a dead simple literate Lua.\n")
			print("Usage: dedlit [file|--help]\n")
			print("dedlit expects that the given file contains any Lua snippets between three backticks either side.")
			print("e.g. ```print(\"Hello, World!\")```")
		end
	else
		return lib
	end

end
