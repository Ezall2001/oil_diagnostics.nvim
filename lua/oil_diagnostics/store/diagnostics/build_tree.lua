local c = require('oil_diagnostics.consts')
local store = require('oil_diagnostics.store.store')

local init_buf_agg = function(buf)
	return {
		buf = buf,
		path = vim.api.nvim_buf_get_name(buf),
		severity = { 0, 0, 0, 0 },
	}
end

local is_eligeble_buf = function(buf)
	if not vim.api.nvim_buf_is_valid(buf) then
		return false
	end

	if vim.bo[buf].buftype ~= '' then
		return false
	end

	local path = vim.api.nvim_buf_get_name(buf)
	return path ~= '' and vim.fn.filereadable(path) == 1
end

local aggregate_buff = function(agg, item)
	if not is_eligeble_buf(item.bufnr) then
		return
	end

	if agg[item.bufnr] == nil then
		agg[item.bufnr] = init_buf_agg(item.bufnr)
	end

	agg[item.bufnr].severity[item.severity] = agg[item.bufnr].severity[item.severity] + 1
end

local init_node = function(root, section, item)
	local path = vim.fs.joinpath(root.path or '', section)
	local buf = nil

	if path == item.path then
		buf = item.buf
	end

	return {
		val = {
			buf = buf,
			path = path,
			severity = { 0, 0, 0, 0 },
		},
		next = {},
	}
end

local propagate_item
propagate_item = function(root, path, item)
	if vim.tbl_isempty(path) then
		return
	end

	local section = path[1]
	local rest = vim.list_slice(path, 2)

	if section == '' then
		section = '/'
	end

	if root.next[section] == nil then
		root.next[section] = init_node(root, section, item)
	end

	local node = root.next[section]

	for i = 1, 4 do
		node.val.severity[i] = node.val.severity[i] + item.severity[i]
	end

	propagate_item(node, rest, item)
end

return function()
	local diagnostics = vim.diagnostic.get()
	local aggregated = {}

	for _, item in ipairs(diagnostics) do
		aggregate_buff(aggregated, item)
	end

	store.diagnostic_tree = { next = {} }
	for _, item in pairs(aggregated) do
		local path = vim.split(item.path, c.SEPERATOR)
		propagate_item(store.diagnostic_tree, path, item)
	end
end
