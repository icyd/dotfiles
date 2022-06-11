local map = require('utils').map

map('n', '<localleader>w', "<CMD>lua require'hop'.hint_words()<CR>")
map('n', '<localleader>l', "<CMD>lua require'hop'.hint_lines()<CR>")
map('n', '<localleader>x', "<CMD>lua require'hop'.hint_char1()<CR>")
map('n', '<localleader>X', "<CMD>lua require'hop'.hint_char2()<CR>")
map('n', '<localleader>n', "<CMD>lua require'hop'.hint_patterns()<CR>")
