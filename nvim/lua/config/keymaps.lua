local g, map = vim.g, vim.keymap.set
-- Map leader localleader
g.mapleader = ' '
g.maplocalleader = [[\]]
-- Delete and paste
map('v', '<localleader>P', '"_dP', { desc = 'Delete & paste' })
map('n', '<localleader>P', '"_ddP', { desc = 'Delete & paste' })
map('i', '<C-c>', '<ESC>', { desc = 'Escape' })

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

-- map('i', '<C-d>', '<C-o>x', { desc = 'Delete key' })
map('i', 'jk', '<ESC>')
map('n', '<leader><Space>', '<cmd>nohlsearch<CR>')
map('n', '$', 'g$', { desc = 'Linewrap go to init' })
map('n', '^', 'g^', { desc = 'Linewrap go to end' })
map('n', 'j', 'gj', { desc = 'Linewrap down' })
map('n', 'k', 'gk', { desc = 'Linewrap up' })

-- Make Y behave like D,C...
map('n', 'Y', 'y$', { desc = 'Yank whole line' })

-- keep cursor centered
map('n', 'n', 'nzzzv', { desc = 'Center when next match' })
map('n', 'N', 'Nzzzv', { desc = 'Center when prev match' })
map('n', 'J', 'mzJ`z', { desc = 'Center when wrapping lines' })

-- Undo break points
-- map('i', ',', ',<C-g>u')
-- map('i', '.', '.<C-g>u')
-- map('i', '!', '!<C-g>u')
-- map('i', '?', '?<C-g>u')

-- Jumplist mutations (more than 5 lines)
map('n', 'k', [[(v:count > 5 ? "m'" . v:count : "") . 'k']], { expr = true })
map('n', 'j', [[(v:count > 5 ? "m'" . v:count : "") . 'j']], { expr = true })
map('n', '<leader>X', '<cmd>make<CR>', { desc = 'Make' })
map('n', '<leader>s', '<cmd>mksession<CR>', { desc = 'Save session' })

--map('v', '<C-c>', '"+y', { desc = 'Yank on visual mode' })

-- New split
map('n', '<leader>-', '<cmd>split<CR>', { desc = 'Split horizontal' })
map('n', [[<leader>\]], '<cmd>vsplit<CR>', { desc = 'Split vertical' })

-- Moving text
map('v', '<C-j>', [[:move '>+1<CR>gv=gv]], { desc = 'Move selected down' })
map('v', '<C-k>', [[:move '<-2<CR>gv=gv]], { desc = 'Move selected up' })
map('n', '<C-j>', '<cmd>move .+1<CR>==', { desc = 'Move line down' })
map('n', '<C-k>', '<cmd>move .-2<CR>==', { desc = 'Move line up' })
map('i', '<C-j>', '<ESC><cmd>move .+1<CR>==', { desc = 'Move line down' })
map('i', '<C-k>', '<ESC><cmd>move .-2<CR>==', { desc = 'Move line up' })

-- Open terminal
map('n', [[<leader>']], '<cmd>terminal<CR>', { desc = 'Open terminal' })

-- Save with leader
-- map('n', '<leader>w', '<cmd>w<CR>', { desc = 'Save buffer' })

-- Escape terminal
map('t', '<localleader>q', '<ESC>', { desc = 'Espace on terminal with leader' })
map('t', '<ESC>', [[<C-\><C-N>]], { desc = 'Escape on terminal with ESC key' })
map('t', '<M-h>', [[<C-\><C-N><C-w>h]], { desc = 'Move left' })
map('t', '<M-j>', [[<C-\><C-N><C-w>j]], { desc = 'Move down' })
map('t', '<M-k>', [[<C-\><C-N><C-w>k]], { desc = 'Move up' })
map('t', '<M-l>', [[<C-\><C-N><C-w>l]], { desc = 'Move right' })

-- Tabs
map('n', '<leader>ac', '<cmd>tabnew<CR>', { desc = 'Create new tab' })
map('n', '<leader>a^', '<cmd>tabfirst<CR>', { desc = 'Go to first tab' })
map('n', '<leader>an', '<cmd>tabnext<CR>', { desc = 'Go to next tab' })
map('n', '<leader>ap', '<cmd>tabprev<CR>', { desc = 'Go to prev tab' })
map('n', '<leader>a$', '<cmd>tablast<CR>', { desc = 'Go to last tab' })
map('n', '<leader>ae', '<cmd>tabedit<CR>', { desc = 'Edit in new tab' })
map('n', '<leader>ab', '<cmd>tabnext<Space>', { desc = 'Tab next with arg' })
map('n', '<leader>am', '<cmd>tabm<Space>', { desc = 'Tab move with arg' })
map('n', '<leader>ax', '<cmd>tabclose<CR>', { desc = 'Close tab' })

map('c', 'w!!', 'w !sudo tee % >/dev/null', { desc = 'Save buffer with sudo' })

map('n', '<leader>md', '<cmd>!mkdir -p %:p:h<CR>', { desc = 'Create new dir', silent = false })

map('n', '<leader>cd',
    [[<cmd>lcd %:h<CR>:echo "Changed directory to: "expand('%:p:h')<CR>]],
    { desc = 'Change directory to current file' })

map('n', '<leader>ew', [[:e <C-r>=expand("%:p:h")."/"<CR>]],
    { desc = 'Open relative to current file' })

map('n', '<localleader>cc', require('utils').reload,
    { desc = 'Reload current module' })

map('n', '<localleader>ss', '<cmd>GrabServer<CR>',
    { desc = 'Grab server', silent = false })

map('c', '%%', "getcmdtype() == ':' ? expand('%:h').'/' : '%%'",
    { desc = 'Expand to current path', silent = false, expr = true })
