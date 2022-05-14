local map = require('utils').map
local cmd, g = vim.cmd, vim.g

g.mapleader = ' '
g.maplocalleader = '\\'

-- Delete and paste
map('v', '<localleader>P', '"_dP')
map('n', '<localleader>P', '"_ddP')
map('i', '<C-c>', '<ESC>')
-- Disable arrows
map('n', '<Up>', '<Nop>')
map('n', '<Down>', '<Nop>')
map('n', '<Left>', '<Nop>')
map('n', '<Right>', '<Nop>')
map('i', '<Up>', '<Nop>')
map('i', '<Down>', '<Nop>')
map('i', '<Left>', '<Nop>')
map('i', '<Right>', '<Nop>')
map('v', '<Up>', '<Nop>')
map('v', '<Down>', '<Nop>')
map('v', '<Left>', '<Nop>')
map('v', '<Right>', '<Nop>')
map('n', 'Q', '<Nop>')
map('v', 'Q', '<Nop>')
map('o', 'Q', '<Nop>')
map('i', '<C-d>', '<C-o>x')
map('i', 'jk', '<ESC>')
map('n', '<leader><space>', ':nohlsearch<CR>')
map('n', '$', 'g$')
map('n', '^', 'g^')
map('n', 'j', 'gj')
map('n', 'k', 'gk')
-- Make Y behave like D,C...
map('n', 'Y', 'y$')
-- keep cursor centered
map('n', 'n', 'nzzzv')
map('n', 'N', 'Nzzzv')
map('n', 'J', 'mzJ`z')
-- Undo break points
map('i', ',', ',<C-g>u')
map('i', '.', '.<C-g>u')
map('i', '!', '!<C-g>u')
map('i', '?', '?<C-g>u')
-- Jumplist mutations (more than 5 lines)
map('n', 'k', [[(v:count > 5 ? "m'" . v:count : "") . 'k']], { noremap = true, silent = true, expr = true })
map('n', 'j', [[(v:count > 5 ? "m'" . v:count : "") . 'j']], { noremap = true, silent = true, expr = true })
map('n', '<leader>x', ':make<CR>')
map('n', '<leader>s', ':mksession<CR>')
-- map('i', '<C-v>', '<ESC>"+pa')
-- map('v', '<C-v>', 'c<ESC>"+pa')
map('v', '<C-c>', '"+y')
map('i', '<M-h>', '<C-\\><C-N><C-w>h')
map('i', '<M-j>', '<C-\\><C-N><C-w>j')
map('i', '<M-k>', '<C-\\><C-N><C-w>k')
map('i', '<M-l>', '<C-\\><C-N><C-w>l')
map('n', '<M-h>', '<C-w>h')
map('n', '<M-j>', '<C-w>j')
map('n', '<M-k>', '<C-w>k')
map('n', '<M-l>', '<C-w>l')
map('n', '<leader>-', ':split<CR>')
map('n', '<leader>\\', ':vsplit<CR>')
map('n', '<M-a>', '<C-a>')
map('n', '<M-x>', '<C-x>')
-- Moving text
map('v', '<C-j>', ':move \'>+1<CR>gv=gv')
map('v', '<C-k>', ':move \'<-2<CR>gv=gv')
map('n', '<C-j>', ':move .+1<CR>==')
map('n', '<C-k>', ':move .-2<CR>==')
map('i', '<C-j>', '<ESC>:move .+1<CR>==')
map('i', '<C-k>', '<ESC>:move .-2<CR>==')
-- Open terminal
map('n', '<leader>\'', ':terminal<CR>', {noremap=false})
-- Save with leader
map('n', '<leader>w', ':w<CR>')
-- Escape terminal
map('t', '<ESC>', '<C-\\><C-N>')
map('t', '<localleader>q', '<ESC>')
map('t', '<M-h>', '<C-\\><C-N><C-w>h')
map('t', '<M-j>', '<C-\\><C-N><C-w>j')
map('t', '<M-k>', '<C-\\><C-N><C-w>k')
map('t', '<M-l>', '<C-\\><C-N><C-w>l')
map('n', '<leader>ac', ':tabnew<CR>')
map('n', '<leader>a^', ':tabfirst<CR>')
map('n', '<leader>an', ':tabnext<CR>')
map('n', '<leader>ap', ':tabprev<CR>')
map('n', '<leader>a$', ':tablast<CR>')
map('n', '<leader>ae', ':tabedit<CR>')
map('n', '<leader>ab', ':tabnext<SPACE>')
map('n', '<leader>am', ':tabm<SPACE>')
map('n', '<leader>ax', ':tabclose<CR>')
map('c', 'w!!', 'w !sudo tee % >/dev/null')
map('n', '<leader>md', ':!mkdir -p %:p:h<CR>', {silent=false})
map('n', '<leader>cd', [[:lcd %:h<CR>:echo "Changed directory to: "expand('%:p:h')<CR>]])
map('n', '<leader>ew', [[:e <C-r>=expand("%:p:h")."/"<CR>]])
map('n', '<localleader>ss', ':GrabServerName<CR>', {silent=false})
map('c', '%%', "getcmdtype() == ':' ? expand('%:h').'/' : '%%'", { noremap = false, silent = false, expr = true })
