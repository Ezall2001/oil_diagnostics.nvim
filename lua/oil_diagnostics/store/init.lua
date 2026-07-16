local c = require('oil_diagnostics.consts')
local store = require('oil_diagnostics.store.store')

local M = {}

M.get = function()
	return store
end

M.set_config = function(config)
	store.config = vim.tbl_deep_extend('force', c.DEFAULT_CONFIG, config or {})
end

M.oil_bufs = require('oil_diagnostics.store.oil_bufs')
M.diagnostics = {
	build_tree = require('oil_diagnostics.store.diagnostics.build_tree'),
	get_summary = require('oil_diagnostics.store.diagnostics.get_summary'),
}

return M
