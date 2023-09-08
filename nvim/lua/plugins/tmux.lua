local M = {
    'aserowy/tmux.nvim',
    keys = {
        '<M-h>',
        '<M-j>',
        '<M-k>',
        '<M-l>',
    },
    dependencies = { 'icyd/zellij.nvim' },
}

function M.config()
    local map = vim.keymap.set
    local tmux = require('tmux')
    local zellij = require("zellij")
    tmux.setup({
        copy_sync = {
            -- enables copy sync and overwrites all register actions to
            -- sync registers *, +, unnamed, and 0 till 9 from tmux in advance
            enable = false,

            -- TMUX >= 3.2: yanks (and deletes) will get redirected to system
            -- clipboard by tmux
            redirect_to_clipboard = true,
        },
    })
    zellij.setup({
        replaceVimWindowNavigationKeybinds = false,
        vimTmuxNavigatorKeybinds = false,
        moveFocusOrTab = false,
    })

    local function move(dir)
        if os.getenv('ZELLIJ') then
            if dir == "left" then
                return function() zellij.zjNavigate('h') end
            elseif dir == "bottom" then
                return function() zellij.zjNavigate('j') end
            elseif dir == "top" then
                return function() zellij.zjNavigate('k') end
            elseif dir == "right" then
                return function() zellij.zjNavigate('l') end
            end
        else
            if dir == "left" then
                return tmux.move_left
            elseif dir == "bottom" then
                return tmux.move_bottom
            elseif dir == "top" then
                return tmux.move_top
            elseif dir == "right" then
                return tmux.move_right
            end
        end
    end

    map({ 'i', 'n' }, '<M-h>', move('left'))
    map({ 'i', 'n' }, '<M-j>', move('bottom'))
    map({ 'i', 'n' }, '<M-k>', move('top'))
    map({ 'i', 'n' }, '<M-l>', move('right'))
end

return M
