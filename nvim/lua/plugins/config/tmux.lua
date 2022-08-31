local M = {}

function M.setup()
    local map = vim.keymap.set
    require('tmux').setup({
        copy_sync = {
            -- enables copy sync and overwrites all register actions to
            -- sync registers *, +, unnamed, and 0 till 9 from tmux in advance
            enable = false,

            -- TMUX >= 3.2: yanks (and deletes) will get redirected to system
            -- clipboard by tmux
            redirect_to_clipboard = true,
        },
    })

    map({ 'i', 'n' }, '<M-h>', require('tmux').move_left)
    map({ 'i', 'n' }, '<M-j>', require('tmux').move_bottom)
    map({ 'i', 'n' }, '<M-k>', require('tmux').move_top)
    map({ 'i', 'n' }, '<M-l>', require('tmux').move_right)
end

return M
