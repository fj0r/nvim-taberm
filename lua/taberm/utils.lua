local M = {}

function M.log(msg)
    if true then
        local notify = require 'notify'.notify
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

function M.digit(n)
    local map = {}
    local dup = false
    for bit = math.floor(math.log10(n)), 0, -1 do
        local d = math.floor(math.fmod(n / math.pow(10, bit), 10))
        if map[d] then dup = true end
        map[d] = true
    end
    return map, dup
end

function M.has_key(list)
    for _ in pairs(list) do
        return true
    end
    return false
end

function M.lines()
    local window = vim.fn.line('w$') - vim.fn.line('w0')
    local curr = vim.fn.line('.')
    local bottom = vim.fn.line('$')
    local last
    if bottom > window + 1 then
        last = vim.fn.line('$')
    else
        last = 0
    end
    return {
        curr = curr, last = last, btm = bottom, win = window
    }
end

return M
