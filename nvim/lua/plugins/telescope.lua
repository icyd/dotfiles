local M = {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    dependencies = {
        { "nvim-telescope/telescope-fzf-native.nvim" },
        { "nvim-telescope/telescope-project.nvim" },
        { "nvim-telescope/telescope-file-browser.nvim" },
        { "nvim-telescope/telescope-dap.nvim" },
    },
    cmd = "Telescope",
    keys = {
        {
            "<leader>ff",
            function()
                require("telescope.builtin").find_files()
            end,
            desc = "Find files",
        },
        {
            "<leader>fl",
            function()
                require("telescope.builtin").find_files({
                    cwd = string.gsub(vim.fn.expand("%:p:h"), "oil://", ""),
                })
            end,
            desc = "Find files relative current file",
        },
        {
            "<leader>fg",
            function()
                require("telescope.builtin").current_buffer_fuzzy_find()
            end,
            desc = "Find in current buffer",
        },
        {
            "<leader>fG",
            function()
                require("telescope.builtin").live_grep()
            end,
            desc = "Live grep",
        },
        {
            "<leader>fh",
            function()
                require("telescope.builtin").help_tags()
            end,
            desc = "Help tags",
        },
        {
            "<leader>fR",
            function()
                require("telescope.builtin").oldfiles()
            end,
            desc = "Oldfiles",
        },
        {
            "<leader>b",
            function()
                require("telescope.builtin").buffers({
                    show_all_buffers = true,
                    sort_lastused = true,
                    ignore_current_buffer = true,
                    sort_mru = true,
                })
            end,
            desc = "Buffers",
        },
        {
            "<leader>fv",
            function()
                require("utils.telescope").search_dotfiles()
            end,
            desc = "Search in dotfiles",
        },
        {
            "<leader>fF",
            function()
                require("utils.telescope").search_home()
            end,
            desc = "Search in home",
        },
        {
            "<leader>fB",
            function()
                require("utils.telescope").browse_home()
            end,
            desc = "Browse home",
        },
        {
            "<leader>f/",
            function()
                require("telescope.builtin").search_history()
            end,
            desc = "Search history",
        },
        {
            "<leader>f:",
            function()
                require("telescope.builtin").command_history()
            end,
            desc = "Command history",
        },
        {
            "<leader>fs",
            function()
                require("telescope.builtin").grep_string({ search = vim.fn.expand([[<cword>]]) })
            end,
            desc = "Grep current string",
        },
        {
            "<leader>fS",
            function()
                require("telescope.builtin").grep_string({ search = vim.fn.input("Grep for: ") })
            end,
            desc = "Grep string",
        },
        {
            "<localleader>fR",
            function()
                require("telescope.builtin").registers()
            end,
            desc = "Registers",
        },
        {
            "<localleader>fm",
            function()
                require("telescope.builtin").marks()
            end,
            desc = "Marks",
        },
        {
            "<localleader>fj",
            function()
                require("telescope.builtin").jumplist()
            end,
            desc = "Jumplint",
        },
        {
            "<localleader>fx",
            function()
                require("telescope.builtin").commands()
            end,
            desc = "Commands",
        },
        {
            "<localleader>fn",
            function()
                require("utils.telescope").find_notes()
            end,
            desc = "Find notes",
        },
        {
            "<localleader>fk",
            function()
                require("telescope.builtin").keymaps()
            end,
            desc = "Keymaps",
        },
        -- { '<leader>gb', function()
        --     require('telescope.builtin').git_branches()
        -- end, desc = 'Git branches' },
        -- { '<leader>gc', function()
        --     require('telescope.builtin').git_commits()
        -- end, desc = 'Git commits' },
        {
            "<leader>gC",
            function()
                require("telescope.builtin").git_bcommits()
            end,
            desc = "Git current buffer commits",
        },
        {
            "<leader>fi",
            function()
                require("telescope.builtin").treesitter()
            end,
            desc = "Treesitter",
        },
    },
}

function M.config()
    local telescope = require("telescope")
    local api, map = vim.api, vim.keymap.set

    local extensions = {}
    if pcall(require, "aerial") then
        telescope.load_extension("aerial")
        extensions["aerial"] = {
            show_nesting = {
                ["_"] = false, -- This key will be the default
                json = true, -- You can set the option for specific filetypes
                yaml = true,
            },
        }
    end

    pcall(telescope.load_extension, "notify")

    if pcall(require, "harpoon") then
        telescope.load_extension("harpoon")
    end

    local gwt_ok = pcall(require, "git-worktree")
    if gwt_ok then
        telescope.load_extension("git_worktree")
        map("n", "<leader>gw", telescope.extensions.git_worktree.git_worktrees, { desc = "Git worktree" })
        map("n", "<leader>gW", telescope.extensions.git_worktree.create_git_worktree, { desc = "Create worktree" })
    end

    local lazygit_ok = pcall(require, "lazygit")
    if lazygit_ok then
        telescope.load_extension("lazygit")
        map("n", "<localleader>gg", require("telescope").extensions.lazygit.lazygit, { desc = "Lazygit" })
    end

    if pcall(require, "telescope._extensions.fzf") then
        telescope.load_extension("fzf")
        extensions["fzf"] = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "smart_case",
        }
    end

    if pcall(require, "telescope._extensions.project") then
        telescope.load_extension("project")
        map("n", "<leader>fp", function()
            telescope.extensions.project.project({ display_type = "full" })
        end, { desc = "Projects" })
        extensions["project"] = {
            base_dirs = {
                { path = "~/Projects", max_depth = 1 },
                { path = "~/Projects/ea", max_depth = 2 },
            },
            hidden_files = false,
        }
    end

    -- if pcall(require, 'telescope._extensions.file_browser') then
    --     telescope.load_extension('file_browser')
    --     map('n', '<leader>fb', function()
    --         telescope.extensions.file_browser.file_browser()
    --     end, { desc = 'Browse files' })
    --     extensions['file_browser'] = {
    --         hijack_netrw = false,
    --     }
    -- end

    if pcall(require, "telescope._extensions.dap") then
        telescope.load_extension("dap")
    end

    local telescope_mappings = {
        i = {
            ["<C-x>"] = false,
            ["<C-q>"] = require("telescope.actions").send_to_qflist,
        },
    }

    -- local ok_tr, trouble = pcall(require, "trouble.providers.telescope")
    -- if ok_tr then
    --     telescope_mappings.i['<C-t>'] = trouble.open_with_trouble
    --     telescope_mappings.n = {}
    --     telescope_mappings.n['<C-t>'] = trouble.open_with_trouble
    -- end

    telescope.setup({
        defaults = {
            file_sorter = require("telescope.sorters").get_fzf_sorter,
            prompt_prefix = "> ",
            color_devicons = true,
            file_previewer = require("telescope.previewers").vim_buffer_cat.new,
            grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
            qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,
            mappings = telescope_mappings,
        },
        pickers = {
            find_files = {
                find_command = { "fd", "--hidden", "--exclude=.git" },
            },
        },
        extensions = extensions,
    })

    api.nvim_create_autocmd("FileType", {
        pattern = "TelescopePrompt",
        group = vim.api.nvim_create_augroup("telescope_au", { clear = true }),
        command = "setlocal nocursorline nonumber norelativenumber signcolumn=no",
    })
end

return M
