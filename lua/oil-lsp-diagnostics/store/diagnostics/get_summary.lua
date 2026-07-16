local c = require("oil-lsp-diagnostics.consts")
local store = require("oil-lsp-diagnostics.store.store")

local DEFAULT_SUMMARY = { 0, 0, 0, 0 }

return function(path)
    local sections = vim.split(path, c.SEPERATOR)
    sections[1] = "/"

    local curr_node = store.diagnostic_tree
    for _, section in ipairs(sections) do
        curr_node = curr_node.next[section]

        if curr_node == nil then
            return DEFAULT_SUMMARY
        end
    end

    return curr_node.val.severity
end
