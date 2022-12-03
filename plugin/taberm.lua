local tbm = require('taberm')

vim.api.nvim_set_keymap('n', '<leader>xx', '', { callback = tbm.t, noremap = true, silent = true, desc = 'new term tab' })
vim.api.nvim_set_keymap('n', '<leader>xv', '', { callback = tbm.v, noremap = true, silent = true, desc = 'new term vertical' })
vim.api.nvim_set_keymap('n', '<leader>xV', '', { callback = tbm.V, noremap = true, silent = true, desc = 'new term vertical ext' })
vim.api.nvim_set_keymap('n', '<leader>xc', '', { callback = tbm.c, noremap = true, silent = true, desc = 'new term' })
vim.api.nvim_set_keymap('n', '<leader>xC', '', { callback = tbm.C, noremap = true, silent = true, desc = 'new term ext' })

vim.api.nvim_set_keymap('n', '<c-t>', '', { callback = tbm.toggle_taberm, noremap = true, silent = true, desc = 'toggle taberm' })
vim.api.nvim_set_keymap('t', '<c-t>', '', { callback = tbm.toggle_taberm, noremap = true, silent = true, desc = 'toggle taberm' })

vim.api.nvim_create_user_command('X',  tbm.t, { nargs = '?' , desc = 'new term tab'})
vim.api.nvim_create_user_command('Xv', tbm.v, { nargs = '?' , desc = 'new term vertical'})
vim.api.nvim_create_user_command('XV', tbm.V, { nargs = '?' , desc = 'new term vertical ext'})
vim.api.nvim_create_user_command('Xc', tbm.c, { nargs = '?' , desc = 'new term'})
vim.api.nvim_create_user_command('XC', tbm.C, { nargs = '?' , desc = 'new term ext'})

vim.api.nvim_create_user_command('Xdebug', tbm.debug, { nargs = '?' , desc = 'term debug'})
