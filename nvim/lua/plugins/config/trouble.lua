local map = vim.keymap.set
local trouble = require("trouble")
trouble.setup()

map('n', "[X", function() trouble.previous({skip_groups=true, jump=true}) end,
    { desc = "trouble:goto_prev" })
map('n', "]X", function() trouble.next({skip_groups=true, jump=true}) end,
    { desc = "trouble:goto_next" })
map('n', '<leader>xx', '<cmd>TroubleToggle<cr>', { desc = "trouble:toggle" })
map('n', '<leader>xW', '<cmd>TroubleToggle workspace_diagnostics<cr>',
    { desc = "trouble:workspace_diag" })
map('n', '<leader>xD', '<cmd>TroubleToggle document_diagnostics<cr>',
    { desc = "trouble:workspace_diag" })
map('n', '<leader>xl', '<cmd>TroubleToggle loclist<cr>', { desc = "trouble:loclist" })
map('n', '<leader>xq', '<cmd>TroubleToggle quickfix<cr>', { desc = "trouble:quickfix" })
map('n', '<leader>xR', '<cmd>TroubleToggle lsp_references<cr>',
    { desc = "trouble:reference" })
