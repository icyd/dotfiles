local map = vim.keymap.set

-- Number increase & decrease
map('n', '<M-a>', '<C-a>', { desc = 'Increase number' })
map('n', '<M-x>', '<C-x>', { desc = 'Decrease number' })

-- Move between splits
map('i', '<M-h>', [[<C-\><C-N><C-w>h]], { desc = 'Move left' })
map('i', '<M-j>', [[<C-\><C-N><C-w>j]], { desc = 'Move down' })
map('i', '<M-k>', [[<C-\><C-N><C-w>k]], { desc = 'Move up' })
map('i', '<M-l>', [[<C-\><C-N><C-w>l]], { desc = 'Move right' })
map('n', '<M-h>', '<C-w>h', { desc = 'Move left' })
map('n', '<M-j>', '<C-w>j', { desc = 'Move down' })
map('n', '<M-k>', '<C-w>k', { desc = 'Move up' })
map('n', '<M-l>', '<C-w>l', { desc = 'Move right' })
