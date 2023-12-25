local swap_next, swap_prev = (function()
    local swap_objects = {
        p = '@parameter.inner',
        f = '@function.outer',
        c = '@class.outer',
    }

    local n, p = {}, {}
    for key, obj in pairs(swap_objects) do
        n[string.format('<leader>x%s', key)] = obj
        p[string.format('<leader>x%s', string.upper(key))] = obj
    end

    return n, p
end)()

-- local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
--
-- parser_config.nu = {
--     install_info = {
--         url = "https://github.com/nushell/tree-sitter-nu",
--         files = { "src/parser.c" },
--         branch = "main",
--     },
--     filetype = "nu",
-- }
--
return {
    {
        'nvim-treesitter/playground',
        cmd = 'TSPlaygroundToggle',
    },
    {
        'mfussenegger/nvim-treehopper',
        keys = { { "m", mode = { "o", "x" } } },
        dependencies = {
            'phaazon/hop.nvim',
        },
        config = function()
            vim.cmd([[
            omap     <silent> m :<C-U>lua require('tsht').nodes()<CR>
            xnoremap <silent> m :lua require('tsht').nodes()<CR>
          ]])
        end,
    },
    {
        'nvim-treesitter/nvim-treesitter',
        build = ':TSUpdate',
        -- build = function()
        --    local ts_install = require("nvim-treesitter.install")
        --    ts_install.compilers({ "gcc" })
        --    ts_install.update({ with_sync = true })
        -- end,
        event = 'BufReadPost',
        config = function()
            require('nvim-treesitter.configs').setup({
                ensure_installed = {
                    'bash',
                    'c',
                    'css',
                    'cpp',
                    'go',
                    'hcl',
                    'haskell',
                    'html',
                    'java',
                    'json',
                    'latex',
                    'lua',
                    'make',
                    'markdown',
                    'nix',
                    'org',
                    'python',
                    'query',
                    'regex',
                    'ruby',
                    'rust',
                    'toml',
                    'yaml',
                },
                indent = {
                    enable = true,
                    disable = { 'org' },
                },
                highlight = {
                    enable = true,
                    disable = { 'markdown' },
                    additional_vim_regex_highlighting = { 'org' },
                },
                matchup = {
                    enable = true,
                    disable = {},
                },
                rainbow = {
                    enable = true,
                    extended_mode = true,
                    max_file_lines = 1000
                },
                textsubjects = {
                    enable = true,
                    prev_selection = ',', -- (Optional) keymap to select the previous selection
                    keymaps = {
                        ['.'] = 'textsubjects-smart',
                        [';'] = 'textsubjects-container-outer',
                        ['i;'] = 'textsubjects-container-inner',
                    },
                },
                textobjects = {
                    select = {
                        enable = true,
                        lookahead = true,
                        keymaps = {
                            -- You can use the capture groups defined in textobjects.scm
                            ["af"] = "@function.outer",
                            ["if"] = "@function.inner",
                            ["ac"] = "@class.outer",
                            -- you can optionally set descriptions to the mappings (used in the desc parameter of nvim_buf_set_keymap
                            ["ic"] = { query = "@class.inner", desc = "Select inner part of a class region" },
                        },
                    },
                    selection_modes = {
                        ['@parameter.outer'] = 'v', -- charwise
                        ['@function.outer'] = 'V',  -- linewise
                        ['@class.outer'] = '<c-v>', -- blockwise
                    },
                    move = {
                        enable = true,
                        set_jumps = true,
                        goto_next_start = {
                            [']m'] = '@function.outer',
                            [']]'] = '@class.outer'
                        },
                        goto_next_end = {
                            [']M'] = '@function.outer',
                            [']['] = '@class.outer'
                        },
                        goto_previous_start = {
                            ['[m'] = '@function.outer',
                            ['[['] = '@class.outer'
                        },
                        goto_previous_end = {
                            ['[M'] = '@function.outer',
                            ['[]'] = '@class.outer'
                        }
                    },
                    swap = {
                        enable = true,
                        swap_next = swap_next,
                        swap_previous = swap_prev,
                    },
                    include_surronding_whitespace = true,
                },
            })
        end,
        dependencies = {
            { 'p00f/nvim-ts-rainbow' },
            { 'RRethy/nvim-treesitter-textsubjects' },
            { 'nvim-treesitter/nvim-treesitter-textobjects' },
            {
                'JoosepAlviste/nvim-ts-context-commentstring',
                opts = {
                    enable_autocmd = false,
                },
            },
            { 'm-demare/hlargs.nvim', opts = true },
            -- {
            --     'nvim-treesitter/nvim-treesitter-context',
            --     cmd = { 'TSContextEnable', 'TSContextDisable', 'TSContextToggle' },
            --     opts = {
            --         enable = false,
            --     },
            -- },
        },
    },
}
