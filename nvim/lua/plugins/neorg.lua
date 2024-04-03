local M = {
    "nvim-neorg/neorg",
    dependencies = { "luarocks.nvim" },
    lazy = false,
    version = "*",
}

function M.config()
    local vimwiki_dir = os.getenv("VIMWIKI_HOME")

    require("neorg").setup({
        load = {
            ["core.defaults"] = {},
            ["core.concealer"] = {
                config = {
                    icon_preset = "basic",
                    icons = {
                        todo = {
                            cancelled = { icon = "" },
                            done = { icon = "" },
                            on_hold = { icon = "" },
                            pending = { icon = "" },
                            uncertain = { icon = "" },
                            undone = { icon = " " },
                            urgent = { icon = "" },
                        },
                    },
                },
            },
            ["core.dirman"] = {
                config = {
                    workspaces = {
                        notes = vimwiki_dir .. "/org",
                    },
                    default_workspace = "notes",
                },
            },
            ["core.journal"] = {
                config = {
                    journal_folder = vimwiki_dir .. "/org/journal",
                },
            },
            ["core.completion"] = {
                config = {
                    engine = "nvim-cmp",
                },
            },
            ["core.export"] = {
                config = {
                    extensions = "all",
                },
            },
        },
    })
end

return M
