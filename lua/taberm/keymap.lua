vim.api.nvim_set_keymap('t', '<Esc>', [[<C-\><C-N>]], { noremap = true, silent = true })
-- Pasting in terminal mode
-- vim.cmd [[tnoremap <expr> <C-r> '<C-\><C-N>"'.nr2char(getchar()).'pi']]
vim.api.nvim_set_keymap('t', '<C-y>', '', {
    expr = true,
    callback = function ()
        --require("registers").show_window({ mode = "insert" })
        --vim.api.nvim_command('Registers')
        local t = vim.fn.getreg(vim.fn.nr2char(vim.fn.getchar()))
        local buf = vim.api.nvim_get_current_buf()
        local chan = vim.api.nvim_buf_get_var(buf, 'terminal_job_id')
        vim.api.nvim_chan_send(chan, t)
    end
})
