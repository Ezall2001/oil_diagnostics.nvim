local M = {}

-- selene: allow(incorrect_standard_library_use)
M.SEPERATOR = package.config:sub(1, 1)
M.NAMESPACE = vim.api.nvim_create_namespace("oil-lsp-diagnostics")

M.SEVERITY_MAP = {
    [vim.diagnostic.severity.ERROR] = "error",
    [vim.diagnostic.severity.WARN] = "warn",
    [vim.diagnostic.severity.INFO] = "info",
    [vim.diagnostic.severity.HINT] = "hint",
}

M.DEFAULT_CONFIG = {
    count = true,
    parent_dirs = true,
    diagnostic_colors = {
        error = "DiagnosticError",
        warn = "DiagnosticWarn",
        info = "DiagnosticInfo",
        hint = "DiagnosticHint",
    },
    diagnostic_symbols = {
        error = "",
        warn = "",
        info = "",
        hint = "󰌶",
    },
}

return M
