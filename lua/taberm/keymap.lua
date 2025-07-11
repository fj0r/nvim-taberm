local tbm = require('taberm.core')

vim.api.nvim_create_user_command('X', tbm.t, { nargs = '?', desc = 'new term tab' })
vim.api.nvim_create_user_command('Xv', tbm.v, { nargs = '?', desc = 'new term vertical' })
vim.api.nvim_create_user_command('XV', tbm.V, { nargs = '?', desc = 'new term vertical ext' })
vim.api.nvim_create_user_command('Xc', tbm.c, { nargs = '?', desc = 'new term' })
vim.api.nvim_create_user_command('XC', tbm.C, { nargs = '?', desc = 'new term ext' })

vim.api.nvim_create_user_command('Xdebug', tbm.debug, { nargs = '?', desc = 'term debug' })

local M = {}

local escape = function()
    local k = [[<C-\><C-N>]]
    local nested = vim.b['taberm_blocked']
    if not nested then
        local code = vim.api.nvim_replace_termcodes(k, true, false, true)
        vim.api.nvim_feedkeys(code, 'n', true)
    end
end

local function km(tab)
    for _, o in ipairs(tab) do
        if o[2] ~= nil then
            vim.keymap.set(o[1], o[2], o[3], o[4])
        end
    end
end


function M.config(kcfg)
    km {
        {
            { 'n', 't' },
            kcfg.tab,
            '',
            { callback = tbm.t, noremap = true, silent = true, desc = 'new term tab' }
        },
        {
            'n',
            kcfg.vertical,
            '',
            { callback = tbm.v, noremap = true, silent = true, desc = 'new term vertical' }
        },
        {
            'n',
            kcfg.vertical_ext,
            '',
            { callback = tbm.V, noremap = true, silent = true, desc = 'new term vertical ext' }
        },
        {
            'n',
            kcfg.horizontal,
            '',
            { callback = tbm.c, noremap = true, silent = true, desc = 'new term' }
        },
        {
            'n',
            kcfg.horizontal_ext,
            '',
            { callback = tbm.C, noremap = true, silent = true, desc = 'new term ext' }
        },
        {
            { 'n', 't' },
            kcfg.toggle,
            '',
            { callback = tbm.toggle_taberm, noremap = true, silent = true, desc = 'toggle taberm' }
        },
        {
            { 'n', 't' },
            kcfg.toggle_h,
            '',
            {
                callback = function() tbm.toggle_taberm(true) end,
                noremap = true,
                silent = true,
                desc =
                'toggle taberm horizontal'
            }
        },
        {
            't',
            kcfg.escape,
            escape,
            { noremap = true, silent = true, desc = 'escape' }
        },
        -- vim.cmd [[tnoremap <expr> <C-r> '<C-\><C-N>"'.nr2char(getchar()).'pi']]
        {
            't',
            kcfg.paste,
            '',
            {
                expr = true,
                callback = function()
                    --require("registers").show_window({ mode = "insert" })
                    --vim.api.nvim_command('Registers')
                    local t = vim.fn.getreg(vim.fn.nr2char(vim.fn.getchar()))
                    if t == nil then return end
                    local buf = vim.api.nvim_get_current_buf()
                    local chan = vim.api.nvim_buf_get_var(buf, 'terminal_job_id')
                    vim.api.nvim_chan_send(chan, t)
                end
            }
        }
    }
end

return M
