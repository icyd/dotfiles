return {
    -- Core
    "nvim-tree/nvim-web-devicons",
    "nvim-lua/plenary.nvim",
    -- Colorscheme
    {
        "rebelot/kanagawa.nvim",
        lazy = false,
        priority = 1000,
        config = function()
            vim.cmd([[colorscheme kanagawa-wave]])
        end,
    },
    -- UI
    {
        "rcarriga/nvim-notify",
        config = function()
            vim.notify = require("notify")
        end,
    },
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        init = function()
            vim.o.timeout = true
            vim.o.timeoutlen = 500
        end,
        dependencies = { "afreakk/unimpaired-which-key.nvim" },
        config = function()
            local wk = require("which-key")
            wk.setup({
                -- triggers = { '<leader>', '<localleader>' },
                triggers_blacklist = {
                    n = { "i", '"' },
                },
            })
            local uwk = require("unimpaired-which-key")
            wk.register(uwk.normal_mode)
            wk.register(uwk.normal_mode_and_visual_mode, { mode = { "n", "v" } })
            -- wk.register({ ['?'] = { '<cmd>WhichKey<cr>' } }, { prefix = '<leader>' })
            vim.keymap.set("n", "<leader>?", "<cmd>WhichKey<CR>")
        end,
    },
    {
        "stevearc/dressing.nvim",
        opts = {},
        init = function()
            ---@diagnostic disable-next-line: duplicate-set-field
            vim.ui.select = function(...)
                require("lazy").load({ plugins = { "dressing.nvim" } })
                return vim.ui.select(...)
            end
            ---@diagnostic disable-next-line: duplicate-set-field
            vim.ui.input = function(...)
                require("lazy").load({ plugins = { "dressing.nvim" } })
                return vim.ui.input(...)
            end
        end,
    },
    { "kevinhwang91/nvim-bqf", ft = "qf" },
    -- Easy motion
    {
        "phaazon/hop.nvim",
        branch = "v2",
        opts = {
            winblend = 0.85,
        },
        keys = {
            { "<localleader>w", "<cmd>HopWord<CR>", desc = "Hop to word" },
            { "<localleader>l", "<cmd>HopLine<CR>", desc = "Hop to line" },
            { "<localleader>x", "<cmd>HopChar1<CR>", desc = "Hop to char" },
            { "<localleader>w", "<cmd>HopChar2<CR>", desc = "Hop to bigram" },
            { "<localleader>n", "<cmd>HopPattern<CR>", desc = "Hop to pattern" },
        },
    },
    {
        "folke/flash.nvim",
        event = "VeryLazy",
        -- enabled = false,
        opts = {},
    },
    -- Editorconfig
    {
        "editorconfig/editorconfig-vim",
        event = "BufRead",
        config = function()
            vim.g.EditorConfig_exclude_patterns = {
                "fugitive://.*",
                "scp://.*",
                "fzf://.*",
            }
        end,
    },
    -- Comment plugin
    {
        "numToStr/Comment.nvim",
        keys = { "gcc", "gbc" },
        event = "BufReadPost",
        config = function()
            local my_pre_hook = nil
            local ok, ts_context_comment = pcall(require, "ts_context_commentstring.integrations.comment_nvim")
            if ok then
                my_pre_hook = ts_context_comment.create_pre_hook()
            end

            ---@diagnostic disable-next-line: missing-fields
            require("Comment").setup({
                ---@diagnostic disable-next-line
                pre_hook = my_pre_hook,
            })

            vim.keymap.set("n", "<localleader>cc", "yy<Plug>(comment_toggle_linewise_current)p")
            vim.keymap.set("x", "<localleader>cc", "ygv<Plug>(comment_toggle_linewise_visual)`>p")
        end,
    },
    {
        "folke/todo-comments.nvim",
        cmd = { "TodoTrouble", "TodoTelescope", "TodoLocList", "TodoQuickFix" },
        event = "BufReadPost",
        config = true,
        keys = {
            {
                "]c",
                function()
                    require("todo-comments").jump_next()
                end,
                desc = "Next todo comment",
            },
            {
                "[c",
                function()
                    require("todo-comments").jump_prev()
                end,
                desc = "Previous todo comment",
            },
        },
    },
    -- Autopairs
    {
        "windwp/nvim-autopairs",
        config = function()
            require("nvim-autopairs").setup({
                disable_filetype = { "TelescopePrompt", "fzf" },
                disable_in_macro = true,
                disable_in_visualblocke = true,
                check_ts = true,
            })
        end,
    },
    -- Surround
    {
        "andymass/vim-matchup",
        event = "BufReadPost",
        config = function()
            vim.g.matchup_matchparen_offscreen = { method = "status_manual" }
        end,
    },
    {
        "kylechui/nvim-surround",
        version = "*",
        event = "BufReadPost",
        config = true,
    },
    -- Bracket mapping
    {
        "tpope/vim-unimpaired",
        lazy = false,
    },
    -- Indent object
    {
        "michaeljsmith/vim-indent-object",
        event = "BufReadPre",
        keys = require("utils").gen_lazy_keys({ "n", "o", "v" }, { { "a", "i" }, { "i", "I" } }),
    },
    -- Additional text object
    {
        "wellle/targets.vim",
        event = "BufReadPre",
    },
    -- Mark indentation column
    {
        "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
        event = "BufReadPre",
        config = function()
            require("ibl").setup({
                indent = {
                    char = { "|", "¦", "┆", "┊" },
                    priority = 50,
                },
            })
        end,
    },
    -- Remove extra spaces
    {
        "McAuleyPenney/tidy.nvim",
        opts = {},
        event = "BufWritePre",
    },
    -- Close buffer without closing window
    {
        "moll/vim-bbye",
        event = "BufEnter",
        keys = {
            { "<localleader>q", "<cmd>Bdelete<CR>", desc = "Remove buffer" },
            { "<localleader>Q", "<cmd>Bdelete!<CR>", desc = "Remove buffer without saving" },
        },
    },
    -- Maximize windows
    {
        "declancm/maximize.nvim",
        keys = {
            {
                "<leader>z",
                function()
                    require("maximize").toggle()
                end,
                desc = "Maximize",
            },
        },
    },
    -- Undo tree
    {
        "mbbill/undotree",
        keys = {
            { "<leader>U", "<cmd>UndotreeToggle<CR>" },
        },
        config = function()
            vim.g.undotree_WindowLayout = 3
        end,
    },
    -- Quickterm
    {
        "akinsho/toggleterm.nvim",
        keys = [[<c-\>]],
        cmd = "ToggleTerm",
        config = function()
            require("toggleterm").setup({
                open_mapping = [[<c-\>]],
                hide_numbers = true,
            })
        end,
    },
    -- Misc
    {
        "stevearc/aerial.nvim",
        cmd = { "AerialToggle", "AerialOpen" },
        keys = {
            { "<leader>xa", "<cmd>AerialToggle!<CR>", desc = "aerial:toggle" },
        },
        config = true,
    },
    -- Fuzzy finder
    -- {
    --     'junegunn/fzf.vim',
    --     -- cmd = 'Rg',
    --     -- event = 'VeryLazy',
    --     dependencies = {
    --         { 'junegunn/fzf' },
    --     },
    --     config = function()
    --         vim.opt.runtimepath:append(os.getenv('HOME') .. '/.nix-profile/bin/fzf')
    --         vim.cmd([[command! -bang -nargs=* Rg call ]] ..
    --             [[fzf#vim#grep('rg --column --line-number --no-heading ]] ..
    --             [[--color=always --smart-case -- ]] ..
    --             [['.shellescape(<q-args>), 1, fzf#vim#with_preview(), <bang>0)]])
    --     end,
    -- },
    {
        "airblade/vim-rooter",
        event = "BufReadPost",
        config = function()
            vim.g.rooter_cd_cmd = "lcd"
            vim.g.rooter_resolve_links = 1
        end,
    },
    -- Sessions
    {
        "Shatur/neovim-session-manager",
        event = "VeryLazy",
        config = function()
            require("session_manager").setup({
                autoload_mode = require("session_manager.config").AutoloadMode.Disabled,
            })
        end,
    },
    -- Colorizer
    {
        "NvChad/nvim-colorizer.lua",
        event = "BufReadPre",
        opts = {
            filetypes = { "*", "!lazy" },
            buftype = { "*", "!prompt", "!nofile" },
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
                mode = "virtualtext",
                virtualtext = "■",
            },
        },
    },
    {
        "ThePrimeagen/harpoon",
        opts = {},
        keys = {
            {
                "<leader>hm",
                function()
                    require("harpoon.mark").add_file()
                end,
                desc = "Harpoon add mark",
            },
            {
                "<leader>hu",
                function()
                    require("harpoon.ui").toggle_quick_menu()
                end,
                desc = "Harpoon quick menu",
            },
            {
                "<leader>hU",
                function()
                    require("telescope").extensions.harpoon.marks()
                end,
                desc = "Harpoon telescope menu",
            },
            {
                "<leader>hg",
                function()
                    if vim.v.count > 0 then
                        return require("harpoon.ui").nav_file(vim.v.count)
                    end

                    return require("harpoon.ui").nav_next()
                end,
                desc = "Harpoon go to file",
            },
            {
                "<leader>ht",
                function()
                    require("harpoon.term").gotoTerminal(vim.v.count1)
                end,
                desc = "Harpoon go to terminal",
            },
        },
    },
    {
        "jamessan/vim-gnupg",
        event = "VeryLazy",
        config = function()
            vim.g.GPGPreferArmor = 1
            vim.g.GPGPreferSign = 1
            vim.g.GPGDefaultRecipients = { "beto.v25@gmail.com" }
        end,
    },
    {
        -- 'rhysd/vim-grammarous',
        "rodolfoap/vim-grammarous",
        cmd = { "GrammarousCheck", "GrammarousReset" },
    },
    {
        "neomake/neomake",
        event = "VeryLazy",
    },
    { "skywind3000/asyncrun.vim", event = "VeryLazy" },
    {
        "nvim-neotest/neotest",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-treesitter/nvim-treesitter",
            "antoinemadec/FixCursorHold.nvim",
            "rouge8/neotest-rust",
            "mrcjkb/neotest-haskell",
            "nvim-neotest/neotest-go",
            "nvim-neotest/neotest-python",
        },
        keys = {
            {
                "<localleader>tt",
                function() require("neotest").run.run() end,
                desc = "Run nearest test"
            },
            {
                "<localleader>tf",
                function() require("neotest").run.run(vim.fn.expand("%")) end,
                desc = "Run test in current file"
            },
            {
                "<localleader>tw",
                function()
                    require("neotest").watch.toggle(vim.fn.expand("%"))
                end,
                desc = "Toggle test watch in current file"
            },

            {
                "<localleader>td",
                function()
                    require('neotest').run.run(vim.fn.getcwd())
                end,
                desc = "Run tests in current directory",
            },
            {
                "<localleader>ts",
                function() require("neotest").summary.toggle() end,
                desc = "Toggle test summary window"
            },
            {
                "<localleader>to",
                function() require("neotest").output_panel.toggle() end,
                desc = "Toggle test output pane window"
            },
        },
        config = function()
            require("neotest").setup({
                library = { plugins = { "neotest" }, types = true },
                adapters = {
                    require("neotest-go"),
                    require("neotest-haskell"),
                    require("neotest-python"),
                    require("neotest-rust"),
                },
                quickfix = {
                    enabled = true,
                    open = true,
                },
                icons = {
                    running_animated = { "/", "|", "\\", "-", "/", "|", "\\", "-" },
                    passed = "",
                    running = "",
                    failed = "",
                    skipped = "",
                    unknown = "",
                    non_collapsible = "─",
                    collapsed = "─",
                    expanded = "╮",
                    child_prefix = "├",
                    final_child_prefix = "╰",
                    child_indent = "│",
                    final_child_indent = " ",
                    watching = "",
                },
            })
        end,
    },
    -- Improved folding
    {
        "kevinhwang91/nvim-ufo",
        dependencies = { "kevinhwang91/promise-async" },
        event = "BufRead",
        -- keys = { }
        config = function()
            local ufo = require("ufo")
            vim.api.nvim_create_user_command("CloseFoldsWith", function(opts)
                local foldlevel = tonumber(opts.args)
                if foldlevel then
                    ufo.closeFoldsWith(foldlevel)
                end
            end, { nargs = 1 })
            vim.keymap.set("n", "zR", ufo.openAllFolds, { desc = "Open all folds" })
            vim.keymap.set("n", "zM", ufo.closeAllFolds, { desc = "Close all folds" })
            vim.keymap.set("n", "zr", ufo.openFoldsExceptKinds, { desc = "Open folds except kinds" })
            vim.keymap.set("n", "zm", ":CloseFoldsWidth ", { desc = "Close folds with level" })
            ---@diagnostic disable-next-line: missing-fields
            ufo.setup({
                open_fold_hl_timeout = 150,
                close_fold_kinds = { "imports", "comment" },
                preview = {
                    win_config = {
                        border = { "", "─", "", "", "", "─", "", "" },
                        winhighlight = "Normal:Folded",
                        winblend = 0,
                    },
                    mappings = {
                        scrollU = "<C-u>",
                        scrollD = "<C-d>",
                    },
                },
            })
        end,
    },
    -- Word motion
    {
        "chaoren/vim-wordmotion",
        event = "BufReadPre",
    },
    -- Others
    {
        "dhruvasagar/vim-table-mode",
        keys = { "<leader>tm" },
        cmd = "TableModeToggle",
        config = function()
            vim.g.vimwiki_table_auto_fmt = 0
            vim.api.nvim_create_autocmd({ "BufRead", "BufFilePre", "BufNewFile" }, {
                pattern = "*.md",
                group = vim.api.nvim_create_augroup("vim_table_mode_au", { clear = true }),
                command = [[let g:table_mode_corner='|']],
            })
        end,
    },
    {
        "jpalardy/vim-slime",
        keys = { "<C-c><C-c>", "<C-c>v" },
        enabled = false,
        config = function()
            vim.g.slime_target = "tmux"
        end,
    },
    {
        "tpope/vim-dispatch",
        event = "VeryLazy",
    },
    {
        "michaelb/sniprun",
        cmd = { "SnipRun", "SnipInfo" },
        build = "bash install.sh",
        keys = {
            { "<C-c>", "<Plug>SnipRun", desc = "SnipRun", mode = "v" },
            -- { '<C-c>',  '<Plug>SnipRunOperator', desc = 'SnipRunOperator' },
            { "<C-c>c", "<Plug>SnipRun", desc = "SnipRun" },
        },
    },
    {
        "direnv/direnv.vim",
        event = "VeryLazy",
    },
    {
        "stevearc/oil.nvim",
        lazy = false,
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            require("oil").setup({})
        end,
    },
    {
        "preservim/vim-markdown",
        dependencies = "godlygeek/tabular",
        ft = "markdown",
        config = function()
            vim.g.vim_markdown_frontmatter = 1
            vim.g.vim_markdown_strikethrough = 1
        end,
    },
    {
        "iamcco/markdown-preview.nvim",
        ft = "markdown",
        build = 'bash -c "cd app && npm install"',
        config = function()
            vim.g.mkdp_filetypes = { "markdown" }
        end,
    },
    {
        "mattn/emmet-vim",
        cmd = { "EmmetInstall" },
        config = function()
            vim.g.user_emmet_install_global = 0
        end,
    },
}
