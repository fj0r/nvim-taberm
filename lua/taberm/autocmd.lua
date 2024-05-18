local core = require('taberm.core')

vim.api.nvim_create_autocmd("TermOpen", {
    pattern = 'term://*',
    callback = function (ctx)
        core.prepare(ctx)
    end ,
})

vim.api.nvim_create_autocmd("BufEnter", {
    pattern = 'term://*',
    callback = function (ctx)
        core.prepare(ctx)
        core.active(ctx.buf)
    end ,
})

vim.api.nvim_create_autocmd("TermClose", {
    pattern = 'term://*',
    callback = function (ctx)
        core.release(ctx.buf)
        vim.api.nvim_input('<cr>')
    end
})

vim.api.nvim_create_autocmd("TabClosed", {
    callback = function (ctx)
        core.close_tab(ctx.file)
    end
})
