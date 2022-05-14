local ok, packer = pcall(require, 'plugins.bootstrap')

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
        use 'nathom/filetype.nvim'
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
            'neovim/nvim-lspconfig',
            event = 'BufReadPre',
            after = 'nvim-lspfuzzy',
            requires = { { 'williamboman/nvim-lsp-installer', module = 'nvim-lsp-installer' } },
            config = [[ require('plugins.config.lsp') ]]
        }
        -- -- Fuzzy finder LSP client
        use {
            'junegunn/fzf.vim',
            requires = {
                'junegunn/fzf',
            },
            config = function()
                vim.cmd([[command! -bang -nargs=* Rg call ]]..
                [[fzf#vim#grep('rg --column --line-number --no-heading --color=always ]]..
                [[--smart-case -- '.shellescape(<q-args>), 1, fzf#vim#with_preview(), <bang>0)]])
            end
        }
        use {
            'ojroques/nvim-lspfuzzy',
            event = 'BufReadPre',
            after = 'fzf.vim',
            config = function()
                require('lspfuzzy').setup {}
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
            requires = {
                { 'hrsh7th/cmp-buffer', after = 'nvim-cmp' },
                { 'hrsh7th/cmp-path', after = 'nvim-cmp' },
                { 'hrsh7th/cmp-cmdline', after = 'nvim-cmp' },
                { 'hrsh7th/cmp-nvim-lsp', after = 'nvim-cmp' },
                { 'quangnguyen30192/cmp-nvim-tags', after = 'nvim-cmp' },
                { 'hrsh7th/vim-vsnip', after = 'nvim-cmp' },
                { 'hrsh7th/vim-vsnip-integ', after = 'nvim-cmp' },
                { 'rafamadriz/friendly-snippets', after = 'nvim-cmp' },
                { 'hrsh7th/cmp-vsnip', after = { 'nvim-cmp', 'vim-vsnip-integ' } },
            },
            event = { 'BufReadPre', 'CmdwinEnter' },
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
            module = 'dap',
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
            keys = { '[', ']' }
        }
        -- Indentation by vim object
        use {
            'michaeljsmith/vim-indent-object',
            keys = require('utils').get_keys({'n', 'o', 'v'}, {{'a', 'i'}, {'i', 'I'}})
        }
        -- Repeat plugins commands
        use 'tpope/vim-repeat'
        -- -- Syntax
        use {
            'sheerun/vim-polyglot',
            event = 'BufRead',
        }
        -- Treesitter
        use {
            'nvim-treesitter/nvim-treesitter',
            event = 'BufRead',
            run = ':TSUpdate',
            config = [[ require('plugins.config.treesitter') ]]
        }
        --- Rainbow parenthesis
        use {
            'p00f/nvim-ts-rainbow',
            event = 'BufRead'
        }
        -- Mark indentation column
        use {
             'Yggdroot/indentLine',
             event = 'BufRead',
             config = function()
                vim.g.indentLine_char_list = {'|', '¦', '┆', '┊'}
                vim.g.indentLine_fileTypeExclude = {"fzf", "dashboard", "packer"}
            end
        }
        -- -- Easy motion
        use {
            'phaazon/hop.nvim',
            module = 'hop',
            config = [[ require('plugins.config.hop') ]]
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
             event = 'BufWritePost',
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
            keys = '*'
        }
        -- Surrond brackets
        use {
            'tpope/vim-surround',
            event = 'InsertEnter'
        }
        -- Session management
        -- use {
        --     'dhruvasagar/vim-prosession',
        --     disable = true,
        --     requires = { 'tpope/vim-obsession', disable = true },
        --     config = function()
        --         vim.g.prosession_dir = os.getenv("XDG_DATA_HOME") .. "/nvim/sessions/"
        --     end
        -- }
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
            run='cd app && yarn install'
        }
        use {
            'vim-pandoc/vim-pandoc',
            ft = { 'markdown', 'pandoc' },
            requires = { { 'vim-pandoc/vim-pandoc-syntax' } },
            config = [[ require('plugins.config.pandoc') ]]
        }
        use {
            'vimwiki/vimwiki',
            config = [[ require('plugins.config.vimwiki') ]],
            requires = { { 'mattn/calendar-vim' }, cmd = "Calendar" }
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
            event = 'VimEnter',
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
    end,
})
