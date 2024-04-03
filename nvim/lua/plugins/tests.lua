local M = {
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
            function()
                require("neotest").run.run()
            end,
            desc = "Run nearest test",
        },
        {
            "<localleader>tf",
            function()
                require("neotest").run.run(vim.fn.expand("%"))
            end,
            desc = "Run test in current file",
        },
        {
            "<localleader>tw",
            function()
                require("neotest").watch.toggle(vim.fn.expand("%"))
            end,
            desc = "Toggle test watch in current file",
        },

        {
            "<localleader>td",
            function()
                require("neotest").run.run(vim.fn.getcwd())
            end,
            desc = "Run tests in current directory",
        },
        {
            "<localleader>ts",
            function()
                require("neotest").summary.toggle()
            end,
            desc = "Toggle test summary window",
        },
        {
            "<localleader>to",
            function()
                require("neotest").output_panel.toggle()
            end,
            desc = "Toggle test output pane window",
        },
    },
}

M.config = function()
    ---@diagnostic disable-next-line: missing-fields
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
end

return M
