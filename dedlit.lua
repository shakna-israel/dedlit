do
	local load = loadstring or load
	local concat = concat or table.concat
	local lib = {}

	lib.version = {2, 0, 0}

	lib.parse = function(str)
		local r = {}
		-- TODO: Allow changing the lexer during processing...?
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
		for idx, val in ipairs(arg) do
			if val == "--help" then
				print(string.format(
					"dedlit v%d.%d.%d, a dead simple literate Lua.\n",
					lib.version[1], lib.version[2], lib.version[3]
					)
				)
				print("Usage: dedlit [--help|filenames...]\n")
				-- TODO: Expanded help
				return true
			end
		end

		local ret = true
		for idx, val in ipairs(arg) do
			ret = lib.litfile(arg[1])
		end
		return not not ret
	else
		return lib
	end
end
