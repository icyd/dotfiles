local ok, packer = pcall(require, 'plugins.bootstrap')
local augroup = require('utils').augroup

if not ok then return end

local use = packer.use

return packer.startup({
    function()
        -- Packer
        use {
            'wbthomason/packer.nvim',
            opt = true
        }
        -- Optimizations
        use 'lewis6991/impatient.nvim'
        use {
            'dstein64/vim-startuptime',
            cmd = "StartupTime"
        }
        -- Colorscheme
        use {
            'rebelot/kanagawa.nvim',
            config = function()
                local default_colors = require('kanagawa.colors').setup()
                require('kanagawa').setup({
                    colors = {
                        bg_visual = default_colors.waveBlue2
                    }
                })
                vim.opt.background = "dark"
                vim.cmd([[colorscheme kanagawa]])
            end,
        }
        -- Statusbar
        use {
            'nvim-lualine/lualine.nvim',
            requires = {{ 'kyazdani42/nvim-web-devicons', opt = true }},
            config = [[ require('plugins.config.statusline') ]]
        }
        -- Editorconfig
        use {
            'editorconfig/editorconfig-vim',
            event = 'BufRead',
            config = [[ require('plugins.config.editorconfig') ]]
        }
        -- LSP
        use {
            'williamboman/nvim-lsp-installer',
            {
                'neovim/nvim-lspconfig',
                config = [[ require('plugins.config.lsp') ]]
            }
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
                vim.cmd([[command! -bang -nargs=* Rg call ]]..
                    [[fzf#vim#grep('rg --column --line-number --no-heading --color=always ]]..
                    [[--smart-case -- '.shellescape(<q-args>), 1, fzf#vim#with_preview(), <bang>0)]])
            end
        }
        -- Telescope
        use {
            'nvim-telescope/telescope.nvim',
            requires = {
                'nvim-lua/popup.nvim',
                'nvim-lua/plenary.nvim',
                {
                    'nvim-telescope/telescope-fzf-native.nvim',
                    after = 'telescope.nvim',
                    run = 'make',
                    config = function()
                        require('telescope').load_extension('fzf')
                    end
                },
                        {
                            'nvim-telescope/telescope-ui-select.nvim',
                            after = 'telescope.nvim',
                            config = function()
                                require('telescope').load_extension('ui-select')
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
                            'nvim-telescope/telescope-dap.nvim',
                            after = { 'telescope.nvim', 'nvim-dap' },
                            config = function()
                                require('telescope').load_extension('dap')
                            end
                        },
            },
                cmd = 'Telescope',
                module = 'telescope',
                keys = { '<leader>f', '<leader>g', '<localleader>f', '<leader>b'},
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
                { 'quangnguyen30192/cmp-nvim-tags', after = 'nvim-cmp' },
                {
                    'L3MON4D3/LuaSnip',
                    after = 'nvim-cmp',
                    config = function()
                        require('luasnip.loaders.from_snipmate').lazy_load()
                    end
                },
                { 'honza/vim-snippets', after = 'nvim-cmp' },
                { 'saadparwaiz1/cmp_luasnip', after = { 'LuaSnip', 'nvim-cmp' } },
            },
            config = [[ require('plugins.config.completion') ]]
        }
        -- DAP
        use {
            'mfussenegger/nvim-dap';
            requires = {
                {
                    'Pocco81/DAPInstall.nvim',
                    after = 'nvim-dap',
                    config = function()
                        require('dap-install').setup({
                            installation_path = vim.fn.stdpath("data").."/dapinstall/",
                            verbosely_call_debuggers = false,
                        })
                    end
                },
                {
                    'theHamsta/nvim-dap-virtual-text',
                    after = 'nvim-dap',
                    config = function()
                        require('nvim-dap-virtual-text').setup()
                    end
                },
                {
                    'rcarriga/nvim-dap-ui',
                    after = 'nvim-dap',
                    config = function()
                        require('dapui').setup()
                        local home = os.getenv('HOME')
                        local dap_dir = home .. '/.local/share/nvim/dap/'
                        require('dap').adapters.cppdbg = {
                            type = 'executable',
                            command = dap_dir .. 'extension/debugAdapters/OpenDebugAD7',
                        }
                    end
                },
            },
            keys = '<leader>d',
            config = [[ require('plugins.config.dap') ]]
        }
        -- Autopairing by brackets
        use {
            'jiangmiao/auto-pairs',
            event = 'InsertEnter',
            config = [[ require('plugins.config.autopairs') ]]
        }
        -- Bracket mapping
        use {
            'tpope/vim-unimpaired',
            event = 'BufRead',
            keys = { '[', ']' }
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
        -- Syntax
        use {
            'sheerun/vim-polyglot',
            setup = function()
                vim.g.polyglot_disabled = {
                    'ftdetect',
                    'org',
                }
            end
        }
        -- Treesitter
        use {
            'nvim-treesitter/nvim-treesitter',
            run = ':TSUpdate',
            config = [[ require('plugins.config.treesitter') ]]
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
            end
        }
        -- Easy motion
        use {
            'phaazon/hop.nvim',
            module = 'hop',
            config = function()
                require('hop').setup{winblend=0.85}
            end,
            setup = [[ require('plugins.config.hop') ]]
        }
        -- Git
        use {
            'tpope/vim-fugitive',
            config = [[ require('plugins.config.git') ]]
        }
        use {
            'lewis6991/gitsigns.nvim',
            requires = { { 'nvim-lua/plenary.nvim' } },
            event = 'BufRead',
            config = function() require('gitsigns').setup() end
        }
        -- Async ctags & gtags management
        use {
            'preservim/tagbar',
            cmd = 'TagbarToggle'
        }
        use {
            'ludovicchabant/vim-gutentags',
            event = 'BufRead',
            config = [[ require('plugins.config.gutentags') ]]
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
            keys = require('utils').get_keys({'n', 'o', 'v'}, {{'cr'}, {'c', 'm', '-', '_', 's', 'u', 'U', 'k', '.', '<space>', 't'}})
        }
        -- Star search in visual mode
        use {
            'bronson/vim-visual-star-search',
            event = 'BufRead',
            keys = '*'
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
            'tomtom/tcomment_vim',
            event = 'BufRead',
        }
        -- Tabularize
        use {
            'godlygeek/tabular',
            event = 'InsertEnter',
            config = [[ require('plugins.config.tabularize') ]]
        }
        -- Undo tree
        use {
            'mbbill/undotree',
            cmd = 'UndotreeToggle',
            config = function()
                vim.g.undotree_WindowLayout=3
                require('utils').map('n', '<leader>U', ':UndotreeToggle<CR>')
            end
        }
        -- Markdown preview
        use {
            'iamcco/markdown-preview.nvim',
            config = [[ require('plugins.config.markdown') ]],
            ft = { 'markdown', 'vimwiki', 'pandoc' },
            run='cd app && npm install'
        }
        -- -- use {
        -- --     'vim-pandoc/vim-pandoc',
        -- --     ft = { 'markdown', 'pandoc' },
        -- --     requires = { { 'vim-pandoc/vim-pandoc-syntax' } },
        -- --     config = [[ require('plugins.config.pandoc') ]]
        -- -- }
        use {
            'vimwiki/vimwiki',
            config = [[ require('plugins.config.vimwiki') ]],
            -- keys = { '<leader>Ww' },
        }
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
            config = [[ require('plugins.config.rooter') ]]
        }
        -- Tmux
        use {
            'aserowy/tmux.nvim',
            config = [[ require('plugins.config.tmux') ]]
        }
        -- Test runner
        use {
            'vim-test/vim-test',
            requires = { { 'tpope/vim-dispatch', after = 'vim-test' } },
            fn = { 'TestFile', 'TestSuite', 'TestLast', 'TestVisit' },
            config = [[ require('plugins.config.vim-test') ]]
        }
        -- Other
        use{
            'McAuleyPenney/tidy.nvim',
            event = 'BufWritePre',
        }
        use {
            'sickill/vim-pasta',
            keys = { ',p', ',P' },
            event = 'BufRead',
            config = function()
                vim.g.pasta_paste_before_mapping = ',P'
                vim.g.pasta_paste_after_mapping = ',p'
            end
        }
        use {
            'moll/vim-bbye',
            event = 'BufEnter',
            config = [[ require('plugins.config.bbye') ]]
        }
        use {
            'tsandall/vim-rego',
            requires = { { 'sbdchd/neoformat', ft = 'rego' } },
            ft = 'rego',
            config = [[ require('plugins.config.rego') ]]
        }
        use {
            'rhysd/vim-grammarous',
            fn = { 'GrammarousCheck', 'GrammarousReset' }
        }
        use {
            'simrat39/rust-tools.nvim',
            module = 'rust-tools',
            ft = 'rust'
        }
        use {
            'glepnir/dashboard-nvim',
            config = [[ require('plugins.config.dashboard') ]]
        }
        use {
            'dhruvasagar/vim-table-mode',
            keys = { '<leader>tm' },
            fn = 'TableModeToggle',
            config = function()
                vim.g.vimwiki_table_auto_fmt=0
                augroup('markdown_table', {
                    "BufRead,BufFilePre,BufNewFile *.md let g:table_mode_corner='|'"
                })
            end
        }
        use {
            'michaelb/sniprun',
            run = 'bash install.sh',
        }
    end,
})
