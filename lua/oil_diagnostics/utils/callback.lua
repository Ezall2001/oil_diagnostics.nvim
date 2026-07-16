local concat_args = function(args1, nargs1, args2, nargs2)
	local args = {}

	for i = 1, nargs1 do
		args[i] = args1[i]
	end

	for i = 1, nargs2 do
		args[i + nargs1] = args2[i]
	end

	return args
end

local M = {}

M.mkcb = function(f, ...)
	local n_curried_args = select('#', ...)
	local curried_args = { ... }

	return function(...)
		local n_cb_args = select('#', ...)
		local cb_args = { ... }

		local all_args = concat_args(curried_args, n_curried_args, cb_args, n_cb_args)

		local n_all_args = n_curried_args + n_cb_args

		return f(unpack(all_args, 1, n_all_args))
	end
end

return M
