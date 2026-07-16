local store = require("oil-lsp-diagnostics.store.store")
local M = {}

M.register = function(buf)
    store.oil_bufs[buf] = true
end

M.unregister = function(buf)
    store.oil_bufs[buf] = nil
end

return M
