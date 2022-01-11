local map = require('utils').map

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

map('i', '<M-h>', "<CMD>lua require('tmux').move_left()<CR>")
map('i', '<M-j>', "<CMD>lua require('tmux').move_bottom()<CR>")
map('i', '<M-k>', "<CMD>lua require('tmux').move_top()<CR>")
map('i', '<M-l>', "<CMD>lua require('tmux').move_right()<CR>")
map('n', '<M-h>', "<CMD>lua require('tmux').move_left()<CR>")
map('n', '<M-j>', "<CMD>lua require('tmux').move_bottom()<CR>")
map('n', '<M-k>', "<CMD>lua require('tmux').move_top()<CR>")
map('n', '<M-l>', "<CMD>lua require('tmux').move_right()<CR>")
