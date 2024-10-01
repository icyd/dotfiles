return {
    {
        "lewis6991/gitsigns.nvim",
        event = "BufReadPre",
        config = function()
            local gitsigns = require("gitsigns")
            local map = vim.keymap.set
            map("n", "]h", gitsigns.next_hunk, { desc = "Next Hunk" })
            map("n", "[h", gitsigns.prev_hunk, { desc = "Prev Hunk" })
            map("n", "<leader>gv", gitsigns.preview_hunk, { desc = "Preview Hunk" })
            map("n", "<leader>gr", gitsigns.reset_hunk, { desc = "Reset Hunk" })
            map("n", "<leader>gR", gitsigns.reset_buffer, { desc = "Reset Buffer" })
            map("n", "<leader>gt", gitsigns.stage_hunk, { desc = "Stage Buffer" })
            map("n", "<leader>gu", gitsigns.undo_stage_hunk, { desc = "Undo stage Buffer" })
            map("n", "<leader>gd", gitsigns.diffthis, { desc = "Diff" })
            map("n", "<leader>gD", function()
                gitsigns.diffthis("~")
            end, { desc = "Diff" })
            gitsigns.setup()
        end,
    },
    -- {
    --     'akinsho/git-conflict.nvim',
    --     version = '*',
    --     event = 'BufReadPre',
    --     config = true,
    -- },
    {
        "sindrets/diffview.nvim",
        cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFocusFiles" },
        config = true,
    },
    -- {
    --     "TimUntersberger/neogit",
    --     cmd = 'Neogit',
    --     keys = {
    --         { '<leader>gn', '<cmd>Neogit<CR>', desc = 'Open Neogit' },
    --     },
    --     opts = {
    --         integrations = { diffview = true }
    --     },
    --     dependencies = {
    --         'sindrets/diffview.nvim',
    --     },
    -- },
    {
        "ThePrimeagen/git-worktree.nvim",
        config = function()
            local git_worktree = require("git-worktree")
            git_worktree.setup({})
            git_worktree.on_tree_change(function(op, metadata)
                if op == git_worktree.Operations.Switch then
                    print("Switched from " .. metadata.prev_path .. " to " .. metadata.path)
                end
            end)
        end,
    },
    {
        "tpope/vim-fugitive",
        keys = {
            { "<leader>gs", "<cmd>Git<CR>", desc = "Git status" },
            { "<leader>gd", "<cmd>Gvdiffsplit!<CR>", desc = "Git diff split" },
            { "<leader>gP", "<cmd>Git -c push.default=current push <CR>", desc = "Git push to upstream" },
            { "<leader>gp", "<cmd>Git pull<CR>", desc = "Git pull from upstream" },
            { "<leader>gh", "<cmd>diffget //2<CR>", desc = "Git diff get left" },
            { "<leader>gl", "<cmd>diffget //3<CR>", desc = "Git diff get right" },
        },
        config = function()
            local fugitive_au = vim.api.nvim_create_augroup("fugitive_au", { clear = true })
            vim.api.nvim_create_autocmd("BufReadPost", {
                pattern = "fugitive://*",
                group = fugitive_au,
                command = "set bufhidden=delete",
            })
            vim.api.nvim_create_autocmd("User", {
                pattern = "fugitive",
                group = fugitive_au,
                command = [[if fugitive#buffer().type() =~# '^\%(tree\|blob\)$' ]]
                    .. [[nnoremap <buffer> .. :edit %:h<CR> | endif]],
            })
            -- vim.api.nvim_create_autocmd('FugitiveIndex', {
            --     group = fugitive_au,
            --     buffer = bufnr,
            --     command = function()
            --         vim.keymap.set('n', '<localleader>pP', '<cmd>Git -c push.default=current push <CR>', { desc = 'Git force push', buffer =true })
            --     end,
            -- })
        end,
    },
    -- {
    --     'kdheepak/lazygit.nvim',
    --     dependencies = { 'nvim-lua/plenary.nvim' },
    --     keys = {
    --         { '<leader>gg', '<cmd>LazyGit<CR>', desc = 'LazyGit' },
    --     }
    -- }
}
