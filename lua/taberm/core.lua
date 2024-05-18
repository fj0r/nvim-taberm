local u = require 'taberm.utils'

local M = {}

local TAB_TERM = {}
local TOGGLE_INDEX = {}
local BUF_INDEX = {}


function M.get(conf, action, cmd, newtab)
    return function(ctx)
        local tab = vim.api.nvim_get_current_tabpage()
        local tot = TAB_TERM[tab]
        local cnt = vim.v.count1
        local shell = os.getenv('SHELL') or '/bin/bash'
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
            vim.fn.termopen(shell, { name = name })
            --vim.api.nvim_command('silent tcd! .')
            if newtab then
                tab = vim.api.nvim_get_current_tabpage()
                tot = TAB_TERM[tab]
            end
            if not tot then
                TAB_TERM[tab] = {}
            end
            local current_buf = vim.api.nvim_get_current_buf()
            TAB_TERM[tab][cnt] = current_buf
            BUF_INDEX[current_buf] = {tab, cnt}

            for _, k in ipairs(conf.direct_keys) do
                vim.keymap.set("n", k,
                    function()
                        vim.api.nvim_command('startinsert')
                        local code = vim.api.nvim_replace_termcodes(k, true, false, true)
                        vim.api.nvim_feedkeys(code, 'n', true)
                    end,
                    {
                        desc = "term: " .. k,
                        buffer = current_buf,
                        noremap = true,
                        silent = true,
                        nowait = true
                    }
                )
            end
        end
        local chan = vim.api.nvim_buf_get_var(TAB_TERM[tab][cnt], 'terminal_job_id')
        if ctx then
            vim.api.nvim_chan_send(chan, ctx.args .. '\n')
        else
            vim.api.nvim_chan_send(chan, '')
        end
    end
end

function M.prepare(ctx)
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    vim.opt_local.spell = false
    vim.opt_local.ruler = false
    vim.opt_local.showcmd = false
    vim.opt_local.mouse = ''
    --vim.opt_local.hlsearch = false
    vim.opt_local.cursorline = false
    vim.opt_local.lazyredraw = false
    vim.opt_local.sidescrolloff = 0

    local l = u.lines()
    if l.curr >= l.last then
        vim.api.nvim_command('startinsert')
    end
end

function M.active(buf)
    local i = BUF_INDEX[buf]
    TOGGLE_INDEX[i[1]] = i[2]
end

function M.release(buf)
    for tx, t in pairs(TAB_TERM) do
        for bx, b in pairs(t) do
            if b == buf then
                TAB_TERM[tx][bx] = nil
            end
        end
    end
end

function M.close_tab(tab)
    local available = {}

    for _, i in pairs(vim.api.nvim_list_tabpages()) do
        available[i] = true
    end

    local unavailable = {}
    for t, _ in pairs(TAB_TERM) do
        if not available[t] then
            table.insert(unavailable, t)
        end
    end

    for _, u in pairs(unavailable) do
        for _, b in pairs(TAB_TERM[u]) do
            vim.api.nvim_buf_delete(b, { force = true })
        end
        TAB_TERM[u] = nil
    end
end

function M.toggle_taberm(horizontal)
    local ctab = vim.api.nvim_get_current_tabpage()
    local ctabwins = vim.api.nvim_tabpage_list_wins(ctab)
    -- cterm : { id -> buf }
    local cterm = TAB_TERM[ctab] or {}
    local buf2win = {}
    for _, i in pairs(ctabwins) do
        buf2win[vim.api.nvim_win_get_buf(i)] = i
    end
    local win_buf = {}
    for _, b in pairs(cterm) do
        if buf2win[b] then
            win_buf[buf2win[b]] = b
        end
    end

    -- cnt : id
    local cnt
    if vim.v.count == 0 then
        if TOGGLE_INDEX[ctab] then
            cnt = TOGGLE_INDEX[ctab]
        else
            cnt = 1
        end
    else
        cnt = vim.v.count
        TOGGLE_INDEX[ctab] = cnt
    end

    -- toggle, dup : [ id ], bool
    local toggle, dup = u.digit(cnt)
    -- hide, win_buf : { win -> buf }
    -- show : [ buf ]
    local show = {}
    local hide = {}

    if dup then
        if u.has_key(win_buf) then
            hide = win_buf
        else
            show = cterm
        end
    else
        for id, _ in pairs(toggle) do
            local tb = cterm[id]
            if tb then
                local w = buf2win[tb]
                if win_buf[w] then
                    hide[w] = tb
                else
                    table.insert(show, tb)
                end
            else
                if horizontal then
                    M.c()
                else
                    M.v()
                end
            end
        end
    end

    --u.log{win_buf = win_buf, show = show, hide = hide, toggle = toggle, cterm = cterm, buf2win = buf2win, ctabwins = ctabwins}

    for w, _ in pairs(hide) do
        if #ctabwins <= 1 then
            break
        end
        vim.api.nvim_win_close(w, { force = true })
    end

    for _, b in pairs(show) do
        if horizontal then
            vim.api.nvim_command('rightbelow new')
        else
            vim.api.nvim_command('rightbelow vnew')
        end
        vim.api.nvim_win_set_buf(vim.api.nvim_get_current_win(), b)
    end
end

function M.debug()
    u.log { TAB_TERM = TAB_TERM, TOGGLE_IDX = TOGGLE_INDEX, BUF_INDEX = BUF_INDEX }
end

function M.setup(tbl)
    local conf = vim.tbl_deep_extend('force', require('taberm.config'), tbl or {})
    M.config = conf

    M.t = M.get(conf, 'tabnew', '', true)
    M.v = M.get(conf, 'rightbelow vnew', '')
    M.c = M.get(conf, 'rightbelow new', '')
    M.V = M.get(conf, 'botright vnew', '')
    M.C = M.get(conf, 'botright new', '')
    M.n = M.get(conf, nil, '')

    require 'taberm.keymap'.config(conf.keymap)

    if conf.shell_integration then
        require 'taberm.shell'.setup()
    end
end

return M
