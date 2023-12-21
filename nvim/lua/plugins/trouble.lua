local M = {
    'folke/trouble.nvim',
    enabled = false,
    opts = {
        mode = 'document_diagnostics',
    },
    cmd = { 'Trouble', 'TroubleToggle' },
    keys = {
        {
            '<leader>xx',
            function() require('trouble').toggle() end,
            desc = "trouble:toggle"
        },
        {
            '<leader>xW',
            function() require('trouble').toggle('workspace_diagnostics') end,
            desc = "trouble:workspace_diag"
        },
        {
            '<leader>xD',
            function() require('trouble').toggle('document_diagnostics') end,
            desc = "trouble:workspace_diag"
        },
        {
            '<leader>xl',
            function() require('trouble').toggle('loclist') end,
            desc = "trouble:loclist"
        },
        {
            '<leader>xq',
            function() require('trouble').toggle('quickfix') end,
            desc = "trouble:quickfix"
        },
        {
            '<leader>xR',
            function() require('trouble').toggle('lsp_references') end,
            desc = "trouble:references"
        },
        {
            '[X',
            function() require('trouble').first({ skip_groups = true, jump = true }) end,
            desc = "trouble:goto_prev"
        },
        {
            '[x',
            function() require('trouble').previous({ skip_groups = true, jump = true }) end,
            desc = "trouble:goto_prev"
        },
        {
            ']x',
            function() require('trouble').next({ skip_groups = true, jump = true }) end,
            desc = "trouble:goto_next"
        },
        {
            ']X',
            function() require('trouble').last({ skip_groups = true, jump = true }) end,
            desc = "trouble:goto_next"
        },
    },
}

return M
