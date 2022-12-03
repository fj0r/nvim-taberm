local log = function (msg)
    if true then
        local notify = require'notify'.notify
        notify(vim.inspect(msg))
    else
        print(vim.inspect(msg))
    end
end

local get_tabpage = function (n)
    for _, i in pairs(vim.api.nvim_list_tabpages()) do
        if vim.api.nvim_tabpage_get_number(i) == n then
            return i
        end
    end
end
