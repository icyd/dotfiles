local M = {
    "nvim-neorg/neorg",
    dependencies = { "luarocks.nvim" },
    cmd = { "Neorg" },
    ft = { "norg" },
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
                        code_block = {
                            spell_check = false,
                        },
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
            ["core.esupports.metagen"] = {
                config = {
                    author = "Alberto Vázquez",
                },
            },
            ["core.dirman"] = {
                config = {
                    workspaces = {
                        notes = vimwiki_dir .. "/org",
                        work = vimwiki_dir .. "/org/work",
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
                config = {},
            },
            ["core.export.markdown"] = {
                config = {
                    -- extensions = "all",
                },
            },
            ["core.presenter"] = {
                config = {
                    zen_mode = "zen-mode",
                },
            },
            ["core.summary"] = {
                config = {
                    strategy = "default",
                },
            },
        },
    })
end

return M
