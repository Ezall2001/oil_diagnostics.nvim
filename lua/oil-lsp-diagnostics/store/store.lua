local c = require("oil-lsp-diagnostics.consts")

local M = {
    is_init = false,
    config = c.DEFAULT_CONFIG,
    oil_bufs = {},
    diagnostic_tree = {
        next = {},
    },
}

return M
