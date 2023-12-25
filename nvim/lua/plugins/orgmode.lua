local heading_config = {
    fat_headline_upper_string = "▄",
    fat_headline_lower_string = "▀"
}

local orgmode_dir = os.getenv('ORGMODE_HOME')
if orgmode_dir == nil or orgmode_dir == '' then
    orgmode_dir = os.getenv('HOME') .. '/.org'
end

return {
    'nvim-orgmode/orgmode',
    keys = { '<leader>oc', '<leader>oa' },
    ft = 'org',
    dependencies = {
        {
            'akinsho/org-bullets.nvim',
            opts = {},
            enabled = false,
        },
        {
            'lukas-reineke/headlines.nvim',
            dependencies = 'nvim-treesitter/nvim-treesitter',
            opts = {
                org = heading_config,
                norg = heading_config,
            }
        },
        {
            'ranjithshegde/orgWiki.nvim',
            opts = {
                wiki_path = { orgmode_dir .. '/orgwiki' },
                diary_path = orgmode_dir .. '/orgwiki/diary',
            }
        }
    },
    config = function()
        local orgmode = require('orgmode')
        orgmode.setup_ts_grammar()
        orgmode.setup({
            org_agenda_files = {
                orgmode_dir .. '/org/**/*',
            },
            org_default_notes_file = orgmode_dir .. '/org/refile.org',
            mappings = {
                org_return = false,
            }
            -- org_capture_templates = {
            --     t = {
            --         description = 'Todo',
            --         template = '* TODO %?\n %u',
            --         target = orgmode_dir .. '/org/refile.org',
            --     },
            --     l = {
            --         description = 'Ledger entry',
            --         template = '\n%<%m-%d> %^{Description}\n    %?',
            --         target = string.format(orgmode_dir .. '/ledger/journals/%s.ledger', vim.fn.strftime('%Y-%m')),
            --         filetype = 'ledger',
            --     }
            -- },
        })

        vim.keymap.set('n', '<leader>ww', function() vim.cmd('e ' .. orgmode_dir .. '/org/orgwiki/Index.org') end,
            { desc = 'Open orgwiki index' })
    end,
}
