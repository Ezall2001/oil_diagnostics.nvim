local u = require('oil_diagnostics.utils.callback')

local debounce = function(f, interval)
	local timer = vim.loop.new_timer()

	assert(timer ~= nil, "couldn't get timer'")

	local wrapper = function(...)
		local args = { ... }
		local cb = u.mkcb(f, unpack(args))

		timer:start(interval, 0, vim.schedule_wrap(cb))
	end

	return wrapper
end

return debounce
