local default_config = {
    keymap = {
        tab            = '<leader>x',
        --vertical       = '<leader>xv',
        --vertical_ext   = '<leader>xV',
        --horizontal     = '<leader>xc',
        --horizontal_ext = '<leader>xC',
        toggle         = '<M-[>',
        toggle_h       = '<M-]>',
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
    shell_integration = {
        follow_cd = {1},
    }
}

return default_config
