local g, map = vim.g, require('utils').map

g["test#strategy"] = "dispatch"
map('n', '<localleader>tn', ':TestNearest<CR>')
map('n', '<localleader>tf', ':TestFile<CR>')
map('n', '<localleader>ts', ':TestSuite<CR>')
map('n', '<localleader>tl', ':TestLast<CR>')
map('n', '<localleader>tv', ':TestVisit<CR>')
