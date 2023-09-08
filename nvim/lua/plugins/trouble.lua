local M = {
    'folke/trouble.nvim',
    config = {},
    cmd = { 'Trouble', 'TroubleToggle' },
    keys = {
        { '<leader>xx', '<cmd>TroubleToggle<cr>', desc = "trouble:toggle" },
        { '<leader>xW', '<cmd>TroubleToggle workspace_diagnostics<cr>',
            desc = "trouble:workspace_diag" },
        { '<leader>xD', '<cmd>TroubleToggle document_diagnostics<cr>',
            desc = "trouble:workspace_diag" },
        { '<leader>xl', '<cmd>TroubleToggle loclist<cr>', desc = "trouble:loclist" },
        { '<leader>xq', '<cmd>TroubleToggle quickfix<cr>', desc = "trouble:quickfix" },
        { '<leader>xR', '<cmd>TroubleToggle lsp_references<cr>',
            desc = "trouble:reference" },
        { '[X', function() require('trouble').previous({skip_groups=true, jump=true}) end,
            desc = "trouble:goto_prev" },
        { ']X', function() tire('trouble')rouble.next({skip_groups=true, jump=true}) end,
            desc = "trouble:goto_next" },
    },
}

return M
