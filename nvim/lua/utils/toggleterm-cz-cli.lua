local M = {}

local ok, terminal = pcall(require, 'toggleterm.terminal')
if ok then
    local git_cz = 'git cz'
    local git_commit = terminal.Terminal:new({
        cmd = git_cz,
        dir = 'git_dir',
        hidden = true,
        direction = 'float',
        float_opts = {
            border = 'double',
        },
    })
    function M.git_commit_toggle()
        git_commit:toggle()
    end
end


return M
