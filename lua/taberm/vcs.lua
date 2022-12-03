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

M.root = function (path, relative)
    -- relative:
    -- 0 or nil /$HOME/a/b/c
    -- 1 ~/a/b/c
    -- 2 a/b/c
    if not path then return end

    local p = M.find(path)
    if not p then return end

    if not relative or relative == 0 then
        return p
    end

    local home = vim.fn.getenv('HOME')
    if relative == 1 then
        return vim.fn.substitute(p, home, '~', '')
    end

    return string.sub(p, #home+ 2, -1)
end

return M
