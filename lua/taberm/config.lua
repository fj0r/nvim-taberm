local default_config = {
    keymap = {
        tab            = '<leader>x',
        --vertical       = '<leader>xv',
        --vertical_ext   = '<leader>xV',
        --horizontal     = '<leader>xc',
        --horizontal_ext = '<leader>xC',
        toggle         = '<M-x>',
        toggle_h       = '<M-c>',
        paste          = '<M-y>',
        escape         = '<M-;>',
    },
    direct_keys = {
        '<Enter>',
        '<M-w>', '<C-w>',
        '<C-c>', '<C-d>', '<M-d>',
        '<C-a>', '<C-e>', '<M-a>', '<M-e>',
        '<C-f>', '<C-b>', '<M-f>', '<M-b>',
        '<C-n>', '<C-p>', '<M-n>', '<M-p>',
    },
    shell_integration = true
}

return default_config
