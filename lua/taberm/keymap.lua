local tbm = require('taberm.core')

vim.api.nvim_create_user_command('X', tbm.t, { nargs = '?', desc = 'new term tab' })
vim.api.nvim_create_user_command('Xv', tbm.v, { nargs = '?', desc = 'new term vertical' })
vim.api.nvim_create_user_command('XV', tbm.V, { nargs = '?', desc = 'new term vertical ext' })
vim.api.nvim_create_user_command('Xc', tbm.c, { nargs = '?', desc = 'new term' })
vim.api.nvim_create_user_command('XC', tbm.C, { nargs = '?', desc = 'new term ext' })

vim.api.nvim_create_user_command('Xdebug', tbm.debug, { nargs = '?', desc = 'term debug' })

local M = {}


function M.config(kcfg)
    vim.keymap.set('n', kcfg.tab, '', { callback = tbm.t, noremap = true, silent = true, desc = 'new term tab' })
    vim.keymap.set('n', kcfg.vertical, '',
        { callback = tbm.v, noremap = true, silent = true, desc = 'new term vertical' })
    vim.keymap.set('n', kcfg.vertical_ext, '',
        { callback = tbm.V, noremap = true, silent = true, desc = 'new term vertical ext' })
    vim.keymap.set('n', kcfg.horizontal, '', { callback = tbm.c, noremap = true, silent = true, desc = 'new term' })
    vim.keymap.set('n', kcfg.horizontal_ext, '',
        { callback = tbm.C, noremap = true, silent = true, desc = 'new term ext' })

    vim.keymap.set({ 'n', 't' }, kcfg.toggle, '',
        { callback = tbm.toggle_taberm, noremap = true, silent = true, desc = 'toggle taberm' })

    if kcfg.normal ~= nil then
        vim.keymap.set('t', kcfg.normal, [[<C-\><C-N>]],
            { noremap = true, silent = true, desc = 'back to normal mode' })
    end
    -- vim.cmd [[tnoremap <expr> <C-r> '<C-\><C-N>"'.nr2char(getchar()).'pi']]
    vim.keymap.set('t', kcfg.paste, '', {
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
    })
end

return M
