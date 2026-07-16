local c = require('oil_diagnostics.consts')
local oil = require('oil')
local oil_utils = require('oil.util')
local s = require('oil_diagnostics.store')
local u = require('oil_diagnostics.utils.callback')

local build_severity_virt_text = function(diagnostics_summary, severity)
	local severity_count = diagnostics_summary[severity]
	if severity_count == 0 then
		return
	end

	local config = s.get().config
	local severity_label = c.SEVERITY_MAP[severity]
	local color = config.diagnostic_colors[severity_label]
	local symbol = config.diagnostic_symbols[severity_label]
	local text = symbol .. '  '
	if config.count then
		text = severity_count .. symbol .. '  '
	end

	return { text, color }
end

local handle_line = function(dir, buf, line)
	local config = s.get().config
	local entry = oil.get_entry_on_line(buf, line)

	if entry == nil or entry.name == '..' then
		return
	end

	if entry.type == 'directory' and not config.parent_dirs then
		return
	end

	local path = vim.fs.joinpath(dir, entry.name)
	local diagnostics_summary = s.diagnostics.get_summary(path)

	local virt_text = {}
	for severity = 1, 4 do
		local severity_virt_text = build_severity_virt_text(diagnostics_summary, severity)
		if severity_virt_text ~= nil then
			table.insert(virt_text, severity_virt_text)
		end
	end

	if #virt_text == 0 then
		return
	end

	vim.api.nvim_buf_set_extmark(buf, c.NAMESPACE, line - 1, 0, {
		virt_text = virt_text,
		virt_text_pos = 'eol',
		hl_mode = 'combine',
	})
end

local on_oil_load = function(buf)
	vim.api.nvim_buf_clear_namespace(buf, c.NAMESPACE, 0, -1)
	local line_count = vim.api.nvim_buf_line_count(buf)
	local oil_dir = oil.get_current_dir(buf)

	for line = 1, line_count do
		handle_line(oil_dir, buf, line)
	end
end

return function(buf)
	oil_utils.run_after_load(buf, u.mkcb(on_oil_load, buf))
end
