local default_config = {
    keymap = {
        tab            = '<leader>xx',
        vertical       = '<leader>xv',
        vertical_ext   = '<leader>xV',
        horizontal     = '<leader>xc',
        horizontal_ext = '<leader>xC',
        toggle         = '<M-x>',
        paste          = '<M-y>',
        escape         = '<M-;>',
    },
    direct_keys = {
        '<Enter>',
        '<M-w>', '<C-w>',
        '<C-c>', '<M-c>', '<C-d>', '<M-d>',
        '<C-a>', '<C-e>', '<M-a>', '<M-e>',
        '<C-f>', '<C-b>', '<M-f>', '<M-b>',
        '<C-n>', '<C-p>', '<M-n>', '<M-p>',
    },
    toggle_layout = 'vertical',
    shell_integration = true
}

return default_config
