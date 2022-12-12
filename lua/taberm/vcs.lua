local M = {}

M.find = function (path)
    if vim.fn.isdirectory(path.. "/.git") == 1 then
        return path
    end

    local root_dir
    for dir in vim.fs.parents(path) do
        if vim.fn.isdirectory(dir .. "/.git") == 1 then
            root_dir = dir
            break
        end
    end
    return root_dir
end

M.root = function (path, base_home)
    -- :
    -- false or nil /$HOME/a/b/c
    -- true ~/a/b/c
    if not path then return end

    local p = M.find(path)
    if not p then return end

    if not base_home then
        return p
    else
        local home = vim.fn.getenv('HOME')
        return vim.fn.substitute(p, home, '~', '')
    end
end

return M
