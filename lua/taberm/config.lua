local default_config = {
    keymap = {
        tab            = '<leader>xx',
        vertical       = '<leader>xv',
        vertical_ext   = '<leader>xV',
        horizontal     = '<leader>xc',
        horizontal_ext = '<leader>xC',
        toggle         = '<c-t>',
    }
}

local kmp = require'taberm.keymap'
local M = {}


function M.config(tbl)
    local conf = vim.tbl_deep_extend('force', default_config, tbl)
    kmp.config(conf.keymap)
end

return M
