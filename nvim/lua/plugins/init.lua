local ok, bootstrap, packer = pcall(require('plugins.bootstrap').setup)
if not ok then
    print('Error while bootstrapping packer ' .. bootstrap)
    return
end

local packer_conf = {
        compile_path = vim.fn.stdpath('data')..'/site/pack/loader/start/packer.nvim/plugin/packer_compiled.lua',
        compile_on_sync = true,
        profile = {
                enable = false,
                threshold = 3,
        },
        git = {
                clone_timeout = 120,
        },
        display = {
                open_fn = function()
                        return require('packer.util').float({ border = 'single' })
                end,
        }
}

local function plugins(use)
    use { 'wbthomason/packer.nvim' }

    -- Optimizations
    use 'lewis6991/impatient.nvim'
    use {
        'dstein64/vim-startuptime',
        cmd = "StartupTime"
    }
    use {
        'nvim-lua/plenary.nvim',
        module_pattern = 'plenary.*',
    }
    use {
       'kyazdani42/nvim-web-devicons',
       module = 'nvim-web-devicons',
   }
    -- Colorscheme
    use {
    'rebelot/kanagawa.nvim',
    config = function()
        local default_colors = require('kanagawa.colors').setup()
        require('kanagawa').setup({
            colors = { bg_visual = default_colors.waveBlue2 }
        })
        vim.opt.background = "dark"
        vim.cmd [[colorscheme kanagawa]]
        vim.cmd [[highlight WinSeparator guibg=None]]
    end,
   }
   -- Statusbar
    use {
        'nvim-lualine/lualine.nvim',
        requires = { 'kyazdani42/nvim-web-devicons' },
        config = require('plugins.config.statusline').setup,
    }
    -- Editorconfig
    use {
        'editorconfig/editorconfig-vim',
        event = 'BufRead',
        config = function()
            vim.g.EditorConfig_exclude_patterns = {
               'fugitive://.*',
               'scp://.*',
               'fzf://.*',
            }
        end,
    }
    -- LSP
    use {
        'williamboman/mason.nvim',
        config = function()
            require('mason').setup()
        end,
    }
    use {
        'WhoIsSethDaniel/mason-tool-installer.nvim',
        after = 'mason.nvim',
        config = function()
            require('mason-tool-installer').setup({
                ensure_installed = {
                    'codelldb',
                    'luacheck',
                    'shellcheck',
                },
                auto_update = false,
                run_on_start = false,
            })
        end,
    }
    use 'williamboman/mason-lspconfig.nvim'
    use 'simrat39/rust-tools.nvim'
    use 'folke/lua-dev.nvim'
    use {
        'neovim/nvim-lspconfig',
        event = 'BufReadPre',
        config = [[ require('plugins.config.lsp') ]]
    }
    use {
        'folke/trouble.nvim',
        module_pattern = 'trouble.*',
        config = [[ require('plugins.config.trouble') ]],
    }
    -- Fuzzy finder LSP client
    use {
        'junegunn/fzf.vim',
        requires = {
            'junegunn/fzf',
            {
                'ojroques/nvim-lspfuzzy',
                event = 'BufReadPre',
                config = function()
                    require('lspfuzzy').setup {}
                end
            }
        },
        config = function()
            vim.cmd([[command! -bang -nargs=* Rg call ]] ..
            [[fzf#vim#grep('rg --column --line-number --no-heading ]] ..
            [[--color=always --smart-case -- ]] ..
            [['.shellescape(<q-args>), 1, fzf#vim#with_preview(), <bang>0)]])
        end
    }
    -- Telescope
    use {
        'nvim-telescope/telescope.nvim',
        branch = '0.1.x',
        cmd = 'Telescope',
        modules_pattern = 'telescope.*',
        keys = { '<leader>f', '<localleader>f', '<leader>g' },
        requires = {
            -- 'nvim-lua/popup.nvim',
            {
                'nvim-telescope/telescope-fzf-native.nvim',
                after = 'telescope.nvim',
                run = 'make',
                config = function()
                    require('telescope').load_extension('fzf')
                end
            },
            {
                'nvim-telescope/telescope-project.nvim',
                after = 'telescope.nvim',
                config = function()
                    require('telescope').load_extension('project')
                end
            },
            {
                'nvim-telescope/telescope-file-browser.nvim',
                after = 'telescope.nvim',
                config = function()
                    require('telescope').load_extension('file_browser')
                end,
            }
            -- {
            --     'nvim-telescope/telescope-dap.nvim',
            --     after = { 'telescope.nvim', 'nvim-dap' },
            --     config = function()
            --         require('telescope').load_extension('dap')
            --     end
            -- },
        },
        config = [[ require('plugins.config.telescope') ]]
    }
    -- Completion
    use {
        'hrsh7th/nvim-cmp',
        event = { 'CmdLineEnter', 'InsertEnter' },
        requires = {
            { 'hrsh7th/cmp-buffer', after = 'nvim-cmp' },
            { 'hrsh7th/cmp-path', after = 'nvim-cmp' },
            { 'hrsh7th/cmp-cmdline', after = 'nvim-cmp' },
            { 'dmitmel/cmp-cmdline-history', after = 'nvim-cmp' },
            { 'hrsh7th/cmp-nvim-lsp', after = 'nvim-cmp' },
            { 'hrsh7th/cmp-nvim-lsp-document-symbol', after = 'nvim-cmp' },
            { 'hrsh7th/cmp-nvim-lsp-signature-help', after = 'nvim-cmp' },
            { 'hrsh7th/cmp-nvim-lua', after = 'nvim-cmp' },
            -- { 'quangnguyen30192/cmp-nvim-tags', after = 'nvim-cmp' },
            { 'onsails/lspkind.nvim', module = 'lspkind' },
            {
                'L3MON4D3/LuaSnip',
                module = 'luasnip',
                requires = {
                    { 'rafamadriz/friendly-snippets', after = 'LuaSnip' },
                },
            },
            { 'saadparwaiz1/cmp_luasnip', after = { 'LuaSnip', 'nvim-cmp' } },
        },
        config = [[ require('plugins.config.completion') ]]
    }
-- 		-- DAP
-- 		use {
-- 			'mfussenegger/nvim-dap';
-- 			opt = true,
-- 			event = 'BufReadPre',
-- 			module = { 'dap' },
-- 			wants = {
-- 				'nvim-dap-virtual-text',
-- 				'nvim-dap-ui',
-- 				'nvim-dap-python',
-- 				'which-key.nvim',
-- 			},
-- 			requires = {
-- 				-- {
-- 				--     'Pocco81/DAPInstall.nvim',
-- 				--     branch = 'dev',
-- 				--     -- after = 'nvim-dap',
-- 				--     config = function()
-- 				--         require('dap-install').setup({
-- 				--             installation_path = vim.fn.stdpath("data").."/dapinstall/",
-- 				--             verbosely_call_debuggers = false,
-- 				--         })
-- 				--     end
-- 				-- },
-- 				'theHamsta/nvim-dap-virtual-text',
-- 				'rcarriga/nvim-dap-ui',
-- 				"mfussenegger/nvim-dap-python",
-- 				{ "leoluz/nvim-dap-go", module = "dap-go" },
-- 				{ "jbyuki/one-small-step-for-vimkind", module = "osv" },
-- 			},
-- 			config = function()
-- 				require('plugins.config.dap').setup()
-- 			end,
-- 		}
    -- Autopairing by brackets
    use {
        'windwp/nvim-autopairs',
        module = 'nvim-autopairs.completion.cmp',
        config = function()
            require('nvim-autopairs').setup({
                disable_filetype = { 'TelescopePrompt', 'fzf' },
                disable_in_macro = true,
                disable_in_visualblocke = true,
                check_ts = true,
            })
        end,
    }
    -- use {
    --     'jiangmiao/auto-pairs',
    --     event = 'InsertEnter',
    --     config = function()
    --         vim.g.AutoPairsFlyMode = 1
    --     end,
    -- }
    -- Bracket mapping
    use {
        'tpope/vim-unimpaired',
        event = 'BufRead',
    }
    -- Indentation by vim object
    use {
        'michaeljsmith/vim-indent-object',
        event = 'BufRead',
        keys = require('utils').get_keys({'n', 'o', 'v'}, {{'a', 'i'}, {'i', 'I'}})
    }
    -- Repeat plugins commands
    use {
        'tpope/vim-repeat',
        event = 'BufRead',
    }
    use {
        'towolf/vim-helm',
        ft = 'helm',
    }
    use {
        'LnL7/vim-nix',
        ft = 'nix',
    }
    use {
        'hashivim/vim-terraform',
        ft = { 'terraform', 'terragrunt' },
    }
    -- Treesitter
    use {
        'nvim-treesitter/nvim-treesitter',
        run = ':TSUpdate',
        config = [[ require('plugins.config.treesitter') ]]
    }
    use {
        'nvim-treesitter/playground',
        cmd = 'TSPlaygroundToggle',
    }
    --- Rainbow parenthesis
    use 'p00f/nvim-ts-rainbow'
    -- Mark indentation column
    use {
        'Yggdroot/indentLine',
        event = 'BufRead',
        config = function()
            vim.g.indentLine_char_list = {'|', '¦', '┆', '┊'}
            vim.g.indentLine_fileTypeExclude = {"fzf", "dashboard", "packer"}
            vim.g.indentLine_conceallevel = 1
            vim.g.indentLine_concealcursor = 'nc'
            vim.g.indentLine_setConceal = 0
        end
    }
    -- Easy motion
    use {
        'phaazon/hop.nvim',
        event = 'BufRead',
        config = function()
            require('hop').setup{ winblend=0.85 }
            vim.keymap.set('n', '<localleader>w', require('hop').hint_words, { desc = 'Jump to word' })
            vim.keymap.set('n', '<localleader>l', require('hop').hint_lines, { desc = 'Jump to line' })
            vim.keymap.set('n', '<localleader>x', require('hop').hint_char1, { desc = 'Jump to character' })
            vim.keymap.set('n', '<localleader>X', require('hop').hint_char2, { desc = 'Jump to bigram' })
            vim.keymap.set('n', '<localleader>n', require('hop').hint_patterns, { desc = 'Jump to pattern' })
        end,
    }
    -- Git
    use {
        'tpope/vim-fugitive',
        config = [[ require('plugins.config.git') ]]
    }
    use {
        'lewis6991/gitsigns.nvim',
            event = 'BufRead',
            config = function()
                require('gitsigns').setup()
            end,
    }
    -- Quickterm
    use {
        'akinsho/toggleterm.nvim',
        keys = [[<c-\>]],
        cmd = 'ToggleTerm',
        config = function()
            require('toggleterm').setup{
                open_mapping = [[<c-\>]],
                hide_numbers = true,
            }
        end
    }
    -- Substitution, coersion, abbreviation
    use {
        'tpope/vim-abolish',
        cmd = { 'Abolish', 'S' },
        keys = require('utils').get_keys(
            {'n', 'o', 'v'},
            {
                {'cr'},
                {'c', 'm', '-', '_', 's', 'u', 'U', 'k', '.', '<space>', 't'}
            }),
    }
    -- Star search in visual mode
    use {
        'bronson/vim-visual-star-search',
        event = 'BufRead',
    }
    -- Surrond brackets
    use {
        'tpope/vim-surround',
        event = 'InsertEnter'
    }
    -- Session management
    use {
        'dhruvasagar/vim-prosession',
        requires = { 'tpope/vim-obsession', after = 'vim-prosession' },
        cmd = { 'Prossesion', 'ProsessionDelete', 'ProsessionClean' },
        config = function()
            vim.g.prosession_dir = os.getenv('HOME') .. '/.local/share/nvim/sessions/'
        end
    }
    -- Comment plugin
    use {
        'numToStr/Comment.nvim',
        -- event = 'BufRead',
        module_pattern = 'Comment.*',
        config = function()
            require('Comment').setup()
        end,
    }
    -- Tabularize
    use {
        'godlygeek/tabular',
        event = 'InsertEnter',
        config = require('plugins.config.tabularize').setup,
    }
    -- Undo tree
    use {
        'mbbill/undotree',
        cmd = 'UndotreeToggle',
        config = function()
            vim.g.undotree_WindowLayout=3
            vim.keymap.set('n', '<leader>U', '<cmd>UndotreeToggle<CR>')
        end,
    }
    -- Markdown preview
    use {
        'iamcco/markdown-preview.nvim',
        config = function()
            vim.g.mkdp_echo_preview_url = 1
            vim.g.mkdp_browser = 'Firefox'
            vim.g.mkdp_filetypes = {'markdown', 'pandoc'}
            -- vim.env.NVIM_MKDP_LOG_FILE = vim.fn.expand('~/mkdp-log.log')
            -- vim.env.NVIM_MKDP_LOG_LEVEL = 'debug'
        end,
        ft = { 'markdown', 'vimwiki', 'pandoc' },
        run='cd app && npm install'
    }
    use {
        'dhruvasagar/vim-table-mode',
        keys = { '<leader>tm' },
        fn = 'TableModeToggle',
        config = function()
            vim.g.vimwiki_table_auto_fmt=0
            local tm_au = vim.api.nvim_create_augroup('vim_table_mode_au', { clear = true })
            vim.api.nvim_create_autocmd({ 'BufRead', 'BufFilePre', 'BufNewFile' }, {
            pattern = '*.md',
            group = tm_au,
            command = [[let g:table_mode_corner='|']],
            })
        end,
    }
    -- use {
    --     'vimwiki/vimwiki',
    --     config = [[ require('plugins.config.vimwiki') ]],
    --     keys = { '<leader>Ww', '<leader>W<leader>w' },
    -- }
    -- Org-mode
    use {
        'nvim-orgmode/orgmode',
        config = [[ require('plugins.config.orgmode') ]],
        requires = {
            'akinsho/org-bullets.nvim',
            {
                'ranjithshegde/orgWiki.nvim',
                config = [[ require('plugins.config.orgwiki') ]],
            },
        }
    }
    -- Rooter
    use {
        'airblade/vim-rooter',
        event = 'BufRead',
        config = function()
            vim.g.rooter_cd_cmd = 'lcd'
            vim.g.rooter_resolve_links = 1
        end,
    }
    -- Tmux
    use {
        'aserowy/tmux.nvim',
        config = require('plugins.config.tmux').setup,
    }
    -- Test runner
    use {
        'vim-test/vim-test',
            requires = { { 'tpope/vim-dispatch', after = 'vim-test' } },
            fn = { 'TestFile', 'TestSuite', 'TestLast', 'TestVisit' },
            config = function()
                vim.g["test#strategy"] = "dispatch"
                vim.keymap.set('n', '<localleader>tn', '<cmd>TestNearest<CR>', { desc = 'Run nearest test' })
                vim.keymap.set('n', '<localleader>tf', '<cmd>TestFile<CR>', { desc = 'Run file tests' })
                vim.keymap.set('n', '<localleader>ts', '<cmd>TestSuite<CR>', { desc = 'Run suite tests' })
                vim.keymap.set('n', '<localleader>tl', '<cmd>TestLast<CR>', { desc = 'Run last test' })
                vim.keymap.set('n', '<localleader>tv', '<cmd>TestVisit<CR>')
            end,
    }
    -- Other
    use {
        'McAuleyPenney/tidy.nvim',
        event = 'BufWritePre',
    }
    use {
        'sickill/vim-pasta',
        keys = { ',p', ',P' },
        config = function()
            vim.g.pasta_paste_before_mapping = ',P'
            vim.g.pasta_paste_after_mapping = ',p'
        end
    }
    use {
        'moll/vim-bbye',
        event = 'BufEnter',
        config = function()
            vim.keymap.set('n', '<localleader>q', '<cmd>Bdelete<CR>')
            vim.keymap.set('n', '<localleader>Q', '<cmd>Bdelete!<CR>')
        end,
    }
    use {
        'tsandall/vim-rego',
        requires = { { 'sbdchd/neoformat', ft = 'rego' } },
        ft = 'rego',
        config = require('plugins.config.rego').setup,
    }
    use {
        'rhysd/vim-grammarous',
        fn = { 'GrammarousCheck', 'GrammarousReset' }
    }
    use {
        'folke/todo-comments.nvim',
        cmd = { 'TodoQuickFix', 'TodoLocList', 'TodoTrouble', 'TodoTelescope' },
        config = function()
            require('todo-comments').setup {}
        end,
    }
    use {
        'stevearc/dressing.nvim',
        config = function()
            require('dressing').setup {
                input = {
                    relative = 'editor',
                },
                select = {
                    backend = { 'telescope', 'fzf', 'builtin', },
                },
            }
        end,
    }
    use {
        'jpalardy/vim-slime',
        keys = { '<C-c><C-c>', '<C-c>v' },
        config = function()
            vim.g.slime_target = 'tmux'
        end,
    }
    use {
        'mattn/emmet-vim',
        ft = { 'html', 'css', 'sass', 'scss' },
        config = function()
            vim.g.user_emmet_install_global = 0
            vim.g.user_emmet_leader_key = '<C-Z>'
            local emmet_au = vim.api.nvim_create_augroup('emmet_au', { clear = true })
            vim.api.nvim_create_autocmd('FileType', {
                pattern = { 'html', 'css' },
                group = emmet_au,
                command = 'EmmetInstall'
            })
        end,
    }
    use {
        'folke/which-key.nvim',
        config = function()
            require("which-key").setup({
                triggers = { '<leader>', '<localleader>' },
            })
            vim.keymap.set('n', '<leader>?', '<cmd>WhickKey <CR>')
        end,
    }
    use {
        'declancm/maximize.nvim',
        config = function()
            vim.keymap.set('n', '<leader>z', require("maximize").toggle)
        end,
    }

    if bootstrap then
        packer.sync()
    end
end

pcall(require, 'impatient')
packer.init(packer_conf)
packer.startup(plugins)
