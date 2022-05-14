local map = require('utils').map

map('n', '<localleader>e', ':Tabularize /=<CR>')
map('v', '<localleader>e' ,':Tabularize /=<CR>')
map('n', '<localleader><space>', ':Tabularize /<space>\zs<CR>')
map('v', '<localleader><space>', ':Tabularize /<space>\zs<CR>')
map('n', '<localleader>|', ':Tabularize /|<CR>')
map('v', '<localleader>|', ':Tabularize /|<CR>')
map('n', '<localleader>:', ':Tabularize /:\zs<CR>')
map('v', '<localleader>:', ':Tabularize /:\zs<CR>')
map('n', '<localleader>,', ':Tabularize /,\zs<CR>')
map('v', '<localleader>,', ':Tabularize /,\zs<CR>')
