local log = require'taberm.utils'.log

local M = {}

local tab_term = {}


function M.get (action, cmd, newtab)
    return function (ctx)
        local tab = vim.api.nvim_get_current_tabpage()
        local tot = tab_term[tab]
        local cnt = vim.v.count
        local shell = vim.fn.getenv('SHELL')
        if tot and tot[cnt] and not newtab then
            local t = tot[cnt]
            local ws = vim.api.nvim_tabpage_list_wins(tab)
            for _, w in ipairs(ws) do
                local b = vim.api.nvim_win_get_buf(w)
                if b == t then
                    vim.api.nvim_set_current_win(w)
                    return
                end
            end

            if action then vim.api.nvim_command(action) end
            local win = vim.api.nvim_get_current_win()
            vim.api.nvim_win_set_buf(win, tot[cnt])
        else
            if action then vim.api.nvim_command(action) end
            local name = '[' .. cnt .. ']' .. shell .. "://" .. "<b:terminal_job_pid>"
            vim.fn.termopen(shell, {name = name})
            --vim.api.nvim_command('silent tcd! .')
            if newtab then
                tab = vim.api.nvim_get_current_tabpage()
                tot = tab_term[tab]
            end
            if not tot then
                tab_term[tab] = {}
            end
            tab_term[tab][cnt] = vim.api.nvim_get_current_buf()
        end
        local chan = vim.api.nvim_buf_get_var(tab_term[tab][cnt], 'terminal_job_id')
        if ctx then
            vim.api.nvim_chan_send(chan, ctx.args..'\n')
        else
            vim.api.nvim_chan_send(chan, '')
        end
    end
end

function M.prepare (ctx)
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    vim.opt_local.spell = false
    vim.opt_local.ruler = false
    vim.opt_local.showcmd = false
    vim.opt_local.mouse = ''
    --vim.opt_local.hlsearch = false
    vim.opt_local.cursorline = false
    vim.opt_local.lazyredraw = true
    local curr_line = vim.fn.line('.')
    local last_line = vim.fn.line('$')
    local window_line = vim.fn.line('w$') - vim.fn.line('w0')
    -- :FIXME: curr_line == <term_last_line>
    if curr_line == last_line or curr_line < window_line then
        vim.api.nvim_command('startinsert')
    end
end

function M.release(buf)
    for tx, t in pairs(tab_term) do
        for bx, b in pairs(t) do
            if b == buf then
                tab_term[tx][bx] = nil
            end
        end
    end
end

function M.close_tab(tab)
    --local t = get_tabpage(tonumber(tab))
    --if t == nil then return end
    --for _, b in pairs(tab_term[t]) do
    --    vim.api.nvim_buf_delete(b, {})
    --end

    local available = {}

    for _, i in pairs(vim.api.nvim_list_tabpages()) do
        available[i] = true
    end

    local unavailable = {}
    for t, _ in pairs(tab_term) do
        if not available[t] then
            table.insert(unavailable, t)
        end
    end

    for _, u in pairs(unavailable) do
        for _, b in pairs(tab_term[u]) do
            vim.api.nvim_buf_delete(b, {force = true})
        end
        tab_term[u] = nil
    end
end

function M.toggle_taberm()
    local ctab = vim.api.nvim_get_current_tabpage()
    local ctabwins = vim.api.nvim_tabpage_list_wins(ctab)
    local buf2win = {}
    for _, i in pairs(ctabwins) do
        buf2win[vim.api.nvim_win_get_buf(i)] = i
    end
    local termwins = {}
    for _, b in pairs(tab_term[ctab] or {}) do
        if buf2win[b] then
            table.insert(termwins, buf2win[b])
        end
    end
    if #termwins > 0 then
        if #termwins == #ctabwins then
            return
        end
        for _, w in pairs(termwins) do
            vim.api.nvim_win_close(w, {force=true})
        end
    else
        if tab_term[ctab] then
            local first = true
            for _, b in pairs(tab_term[ctab]) do
                if first then
                    first = false
                    vim.api.nvim_command(M.layout_command[1])
                else
                    vim.api.nvim_command(M.layout_command[2])
                end
                vim.api.nvim_win_set_buf(vim.api.nvim_get_current_win(), b)
            end
        else
            if M.config.toggle_layout == 'horizontal' then
                M.c()
            else
                M.v()
            end
        end
    end
end

function M.debug()
    log(tab_term)
end


M.t  = M.get('tabnew', '', true)
M.v  = M.get('rightbelow vnew', '')
M.V  = M.get('botright vnew', '')
M.c  = M.get('rightbelow new', '')
M.C  = M.get('botright new', '')
M.n  = M.get(nil, '')

local layout_command = {
    vertical = {'botright vnew', 'rightbelow new'},
    horizontal = {'botright new', 'rightbelow vnew'}
}
function M.setup(tbl)
    local conf = vim.tbl_deep_extend('force', require('taberm.config'), tbl or {})
    M.config = conf

    M.layout_command = layout_command[conf.toggle_layout]

    require'taberm.keymap'.config(conf.keymap)

    if conf.shell_integration then
        require'taberm.shell'.setup()
    end
end

return M
