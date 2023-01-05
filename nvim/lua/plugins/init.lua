return {
    -- Core
    'nvim-tree/nvim-web-devicons',
    'nvim-lua/plenary.nvim',
    -- Colorscheme
    {
        'rebelot/kanagawa.nvim',
        lazy = false,
        priority = 1000,
        config = function()
            local default_colors = require('kanagawa.colors').setup()
            require('kanagawa').setup({
                colors = { bg_visual = default_colors.waveBlue2 }
            })
            vim.cmd([[colorscheme kanagawa]])
            vim.cmd([[highlight WinSeparator guibg=None]])
        end,
    },
    -- UI
    {
        'rcarriga/nvim-notify',
        config = function()
            vim.notify = require('notify')
        end,
    },
    {
        'folke/which-key.nvim',
        event = 'VeryLazy',
        config = function()
            require('which-key').setup({
                triggers = { '<leader>', '<localleader>' },
            })
            vim.keymap.set('n', '<leader>?', '<cmd>WhichKey<CR>')
        end,
    },
    {
        'stevearc/dressing.nvim',
        init = function()
            ---@diagnostic disable-next-line: duplicate-set-field
            vim.ui.select = function(...)
                require('lazy').load({ plugins = { 'dressing.nvim' } })
                return vim.ui.select(...)
            end
            ---@diagnostic disable-next-line: duplicate-set-field
            vim.ui.input = function(...)
                require('lazy').load({ plugins = { 'dressing.nvim' } })
                return vim.ui.input(...)
            end
        end,
    },
    -- Easy motion
    {
        'phaazon/hop.nvim',
        branch = 'v2',
        config = {
            winblend = 0.85,
        },
        keys = {
            { '<localleader>w', '<cmd>HopWord<CR>', desc = 'Hop to word' },
            { '<localleader>l', '<cmd>HopLine<CR>', desc = 'Hop to line' },
            { '<localleader>x', '<cmd>HopChar1<CR>', desc = 'Hop to char' },
            { '<localleader>w', '<cmd>HopChar2<CR>', desc = 'Hop to bigram' },
            { '<localleader>n', '<cmd>HopPattern<CR>', desc = 'Hop to pattern' },
        },
    },
    -- Editorconfig
    {
        'editorconfig/editorconfig-vim',
        event = 'BufRead',
        config = function()
            vim.g.EditorConfig_exclude_patterns = {
                'fugitive://.*',
                'scp://.*',
                'fzf://.*',
            }
        end,
    },
    -- Comment plugin
    {
        'numToStr/Comment.nvim',
        -- keys = { 'gcc', 'gbc' },
        event = 'BufReadPost',
        config = function()
            local my_pre_hook = nil
            local ok, ts_context_comment = pcall(require, 'ts_context_commentstring.integrations.comment_nvim')
            if ok then
                my_pre_hook = ts_context_comment.create_pre_hook()
            end

            require('Comment').setup({
                pre_hook = my_pre_hook,
            })
        end,
    },
    {
        'folke/todo-comments.nvim',
        cmd = { 'TodoTrouble', 'TodoTelescope' },
        event = 'BufReadPost',
        config = {},
        keys = {
            {
                ']c',
                function() require('todo-comments').jump_next() end,
                desc = 'Next todo comment',
            },
            {
                '[c',
                function() require('todo-comments').jump_prev() end,
                desc = 'Previous todo comment',
            },
        },
    },
    -- Autopairs
    {
        'windwp/nvim-autopairs',
        config = function()
            require('nvim-autopairs').setup({
                disable_filetype = { 'TelescopePrompt', 'fzf' },
                disable_in_macro = true,
                disable_in_visualblocke = true,
                check_ts = true,
            })
        end,
    },
    -- Surround
    {
        'andymass/vim-matchup',
        event = "BufReadPost",
        config = function()
            vim.g.matchup_matchparen_offscreen = { method = "status_manual" }
        end,
    },
    {
        'kylechui/nvim-surround',
        version = '*',
        event = 'BufReadPost',
        config = {},
    },
    -- Bracket mapping
    {
        'tpope/vim-unimpaired',
        lazy = false,
    },
    -- Indent object
    {
        'michaeljsmith/vim-indent-object',
        event = 'BufReadPre',
        keys = require('utils').gen_lazy_keys({ 'n', 'o', 'v' }, { { 'a', 'i' }, { 'i', 'I' } }),
    },
    -- Additional text object
    {
        'wellle/targets.vim',
        event = 'BufReadPre',
    },
    -- Mark indentation column
    {
        'lukas-reineke/indent-blankline.nvim',
        event = 'BufReadPre',
        config = function()
            vim.g.indent_blankline_char_priority = 50
            vim.g.indentLine_char_list = { '|', '¦', '┆', '┊' }
            vim.g.indentLine_fileTypeExclude = { "fzf", "dashboard", "packer" }
            require('indent_blankline').setup({
                show_current_context = false,
                show_current_context_start = false,
            })
        end,
    },
    -- Remove extra spaces
    {
        'McAuleyPenney/tidy.nvim',
        event = 'BufWritePre',
    },
    -- Close bufffer without closing window
    {
        'moll/vim-bbye',
        event = 'BufEnter',
        keys = {
            { '<localleader>q', '<cmd>Bdelete<CR>', desc = 'Remove buffer' },
            { '<localleader>Q', '<cmd>Bdelete!<CR>', desc = 'Remove buffer without saving' },
        },
    },
    -- Maximize windows
    {
        'declancm/maximize.nvim',
        keys = {
            { '<leader>z', function() require("maximize").toggle() end, desc = 'Maximize' },
        },
    },
    -- Undo tree
    {
        'mbbill/undotree',
        keys = {
            { '<leader>U', '<cmd>UndotreeToggle<CR>' },
        },
        config = function()
            vim.g.undotree_WindowLayout = 3
        end,
    },
    -- Quickterm
    {
        'akinsho/toggleterm.nvim',
        keys = [[<c-\>]],
        cmd = 'ToggleTerm',
        config = function()
            require('toggleterm').setup {
                open_mapping = [[<c-\>]],
                hide_numbers = true,
            }
        end,
    },
    -- Misc
    {
        'stevearc/aerial.nvim',
        cmd = { 'AerialToggle', 'AerialOpen' },
        keys = {
            { '<leader>xa', '<cmd>AerialToggle!<CR>', desc = "aerial:toggle" },
        },
        config = {},
    },
    -- Fuzzy finder
    {
        'junegunn/fzf.vim',
        cmd = 'Rg',
        dependencies = {
            { 'junegunn/fzf' },
        },
        config = function()
            vim.cmd([[command! -bang -nargs=* Rg call ]] ..
                [[fzf#vim#grep('rg --column --line-number --no-heading ]] ..
                [[--color=always --smart-case -- ]] ..
                [['.shellescape(<q-args>), 1, fzf#vim#with_preview(), <bang>0)]])
        end,
    },
    {
        'dstein64/vim-startuptime',
        cmd = 'StartupTime',
    },
    {
        'airblade/vim-rooter',
        event = 'BufReadPost',
        config = function()
            vim.g.rooter_cd_cmd = 'lcd'
            vim.g.rooter_resolve_links = 1
        end,
    },
    -- Sessions
    {
        'Shatur/neovim-session-manager',
        event = 'VeryLazy',
        config = function()
            require('session_manager').setup({
                autoload_mode = require('session_manager.config').AutoloadMode.Disabled,
            })
        end,
    },
    -- Colorizer
    {
        'NvChad/nvim-colorizer.lua',
        event = 'BufReadPre',
        config = {
            filetypes = { '*', '!lazy' },
            buftype = { '*', '!prompt', '!nofile' },
            user_default_options = {
                RGB = true, -- #RGB hex codes
                RRGGBB = true, -- #RRGGBB hex codes
                names = false, -- 'Name' codes like Blue
                RRGGBBAA = true, -- #RRGGBBAA hex codes
                AARRGGBB = false, -- 0xAARRGGBB hex codes
                rgb_fn = true, -- CSS rgb() and rgba() functions
                hsl_fn = true, -- CSS hsl() and hsla() functions
                css = false, -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
                css_fn = true, -- Enable all CSS *functions*: rgb_fn, hsl_fn
                mode = 'virtualtext',
                virtualtext = '■',
            },
        },
    },
    {
        'ThePrimeagen/harpoon',
        config = {},
    },
    {
        'jamessan/vim-gnupg',
        config = function()
            vim.g.GPGPreferArmor = 1
            vim.g.GPGPreferSign = 1
            vim.g.GPGDefaultRecipients = { 'beto.v25@gmail.com' }
        end,
    },
    {
        'aspeddro/pandoc.nvim',
        cmd = 'Pandoc',
        config = {},
    },
    {
        'rhysd/vim-grammarous',
        cmd = { 'GrammarousCheck', 'GrammarousReset' }
    },
    {
        'neomake/neomake',
        cmd = 'Neomake',
    },
    {
        'vim-test/vim-test',
        dependencies = 'neomake/neomake',
        cmd = { 'TestFile', 'TestSuite', 'TestLast', 'TestVisit' },
        config = function()
            local map = vim.keymap.set
            vim.g["test#strategy"] = "neomake"
            map('n', '<localleader>tn', '<cmd>TestNearest<CR>', { desc = 'Run nearest test' })
            map('n', '<localleader>tf', '<cmd>TestFile<CR>', { desc = 'Run file tests' })
            map('n', '<localleader>ts', '<cmd>TestSuite<CR>', { desc = 'Run suite tests' })
            map('n', '<localleader>tl', '<cmd>TestLast<CR>', { desc = 'Run last test' })
            map('n', '<localleader>tv', '<cmd>TestVisit<CR>')
        end,
    },
    -- Improved folding
    {
        'kevinhwang91/nvim-ufo',
        dependencies = { 'kevinhwang91/promise-async' },
        event = 'BufRead',
        -- keys = { }
        config = function()
            local ufo = require("ufo")
            vim.api.nvim_create_user_command('CloseFoldsWith', function(opts)
                local foldlevel = tonumber(opts.args)
                if foldlevel then
                    ufo.closeFoldsWith(foldlevel)
                end
            end, { nargs = 1 })
            vim.keymap.set('n', 'zR', ufo.openAllFolds, { desc = 'Open all folds' })
            vim.keymap.set('n', 'zM', ufo.closeAllFolds, { desc = 'Close all folds' })
            vim.keymap.set('n', 'zr', ufo.openFoldsExceptKinds, { desc = 'Open folds except kinds' })
            vim.keymap.set('n', 'zm', ':CloseFoldsWidth ', { desc = 'Close folds with level' })
            ufo.setup({
                open_fold_hl_timeout = 150,
                close_fold_kinds = { 'imports', 'comment' },
                preview = {
                    win_config = {
                        border = { '', '─', '', '', '', '─', '', '' },
                        winhighlight = 'Normal:Folded',
                        winblend = 0,
                    },
                    mappings = {
                        scrollU = '<C-u>',
                        scrollD = '<C-d>',
                    },
                },
            })
        end,
    },
    -- Word motion
    {
        'chaoren/vim-wordmotion',
        event = 'BufReadPre',
    },
    -- Others
    {
        'dhruvasagar/vim-table-mode',
        keys = { '<leader>tm' },
        cmd = 'TableModeToggle',
        config = function()
            vim.g.vimwiki_table_auto_fmt = 0
            vim.api.nvim_create_autocmd({ 'BufRead', 'BufFilePre', 'BufNewFile' }, {
                pattern = '*.md',
                group = vim.api.nvim_create_augroup('vim_table_mode_au', { clear = true }),
                command = [[let g:table_mode_corner='|']],
            })
        end,
    },
    {
        'jpalardy/vim-slime',
        keys = { '<C-c><C-c>', '<C-c>v' },
        config = function()
            vim.g.slime_target = 'tmux'
        end,
    },
}
