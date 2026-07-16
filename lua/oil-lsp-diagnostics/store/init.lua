local c = require("oil-lsp-diagnostics.consts")
local store = require("oil-lsp-diagnostics.store.store")

local M = {}

M.get = function()
    return store
end

M.set_config = function(config)
    store.config = vim.tbl_deep_extend("force", c.DEFAULT_CONFIG, config or {})
end

M.oil_bufs = require("oil-lsp-diagnostics.store.oil_bufs")
M.diagnostics = {
    build_tree = require("oil-lsp-diagnostics.store.diagnostics.build_tree"),
    get_summary = require("oil-lsp-diagnostics.store.diagnostics.get_summary"),
}

return M
