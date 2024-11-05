do
	local load = loadstring or load
	local concat = concat or table.concat
	local lib = {}

	lib.version = {2, 0, 0}

	do
		local default_pattern = "```(.-)```"
		local patterns = {default_pattern}

		lib.popsyntax = function()
			local popped = nil
			if #patterns > 0 then
				popped = table.remove(patterns, #patterns)
			end

			if #patterns < 1 then
				patterns[#patterns + 1] = default_pattern
			end

			return popped
		end

		lib.pushsyntax = function(pattern)
			patterns[#patterns + 1] = pattern or default_pattern
			return patterns[#patterns]
		end

		lib.syntax = function()
			return patterns[#patterns]
		end

		lib.issyntax = function(x)
			return x == patterns[#patterns]
		end
	end

	lib.get_line = function(str, start)
		local line_count = 1

		for i=1, (start or #str)+1 do
			local c = str:sub(i, i)
			if c == '\n' then
				line_count = line_count + 1
			end
		end

		return line_count
	end

	lib.parse = function(str, filename, position)
		local r = {}
		local position = position or 1

		local syn = lib.syntax()
		if type(syn) == 'function' then
			syn = syn(filename, position)
		end

		local matches = {string.find(str, syn, position)}
		local begin = table.remove(matches, 1) or nil
		local ender = table.remove(matches, 1) or nil

		if #matches > 0 then
			lib.eval({matches[1]}, lib.get_line(str, begin), filename)
			return lib.parse(str, filename, ender + 1)
		end
	end

	do
		local copy_state
		copy_state = function(x, seen)
			local seen = seen or {}

			if seen[x] then
				return seen[x]
			end

			if type(x) == 'table' then
				local copy = {}
				seen[x] = copy
				for k, v in pairs(x) do
					copy[copy_state(k, seen)] = copy_state(v, seen)
				end
				setmetatable(copy, copy_state(x, seen))
				return copy
			end

			return x
		end
		local eval_env = copy_state(_G)
		eval_env.popsyntax = lib.popsyntax
		eval_env.pushsyntax = lib.pushsyntax
		eval_env.syntax = lib.syntax
		eval_env.issyntax = lib.issyntax

		lib.eval = function(exp_tbl, line, filename)
			for _, v in ipairs(exp_tbl) do
				local f = assert(load(v, string.format("%q offset line %d", filename or "<unknown>", line), "t", eval_env))
				f()
			end
		end
	end

	lib.litfile = function(filename)
		local lines = {}
		for line in io.lines(filename) do
			lines[#lines + 1] = line .. "\n"
		end
		return lib.parse(concat(lines), filename)
	end

	if not debug or not debug.getinfo(3) then
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
