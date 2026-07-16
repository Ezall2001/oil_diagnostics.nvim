local debounce = require("oil-lsp-diagnostics.utils.debounce")
local paint = require("oil-lsp-diagnostics.paint")
local s = require("oil-lsp-diagnostics.store")

local on_win_enter = function(args)
    if s.get().oil_bufs[args.buf] == true then
        return
    end

    s.oil_bufs.register(args.buf)
    paint(args.buf)
end

local on_win_leave = function(args)
    s.oil_bufs.unregister(args.buf)
end

local on_diagnostics_changed = function()
    s.diagnostics.build_tree()
    for buf, _ in pairs(s.get().oil_bufs) do
        paint(buf)
    end
end

local debounced_on_diagnostics_changed = debounce(on_diagnostics_changed, 300)

local init = function()
    local store = s.get()

    if store.is_init then
        return
    end
    store.is_init = true

    vim.api.nvim_create_autocmd("DiagnosticChanged", {
        callback = debounced_on_diagnostics_changed,
    })

    vim.api.nvim_create_autocmd("BufWinEnter", {
        pattern = "oil://*",
        callback = on_win_enter,
    })

    vim.api.nvim_create_autocmd("BufWinLeave", {
        pattern = "oil://*",
        callback = on_win_leave,
    })
end

local M = {}

M.setup = function(config)
    init()
    s.set_config(config)
end

return M
