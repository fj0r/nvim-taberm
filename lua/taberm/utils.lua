local M = {}

function M.log(msg)
    if true then
        local notify = require'notify'.notify
        notify(vim.inspect(msg))
    else
        print(vim.inspect(msg))
    end
end

function M.list_tabpage()
    local m = {}
    for _, i in pairs(vim.api.nvim_list_tabpages()) do
        m[vim.api.nvim_tabpage_get_number(i)] = i
    end
    return m
end

function M.get_tabpage(n)
    for _, i in pairs(vim.api.nvim_list_tabpages()) do
        if vim.api.nvim_tabpage_get_number(i) == n then
            return i
        end
    end
end

return M
