local M = {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
}

local utils = require("utils")

aux_color = "#ff9e64"
ok, colors = pcall(require, "kanagawa.colors")
if ok then
    aux_color = colors.setup({ theme = "wave" }).co
end

local function get_modified()
    -- local file_name = vim.fn.expand('%:t')
    -- local ext = vim.fn.expand('%:e')

    -- if file_name then
    --     local icon, color = require('nvim-web-devicons').get_icon_color(file_name, ext, { default = true })
    --     local hl_group = 'FileIconColor' .. ext
    --     vim.api.nvim_set_hl(0, hl_group, { fg = color })
    --     if not icon then
    --         icon = ''
    --     end
    --
    --     local ret_string = '%#' .. hl_group .. '#' .. icon .. '%*' .. ' ' .. file_name
    if utils.get_buf_option("mod") then
        return "" .. " "
    end

    return ""
end

local function get_location()
    local location = require("nvim-navic").get_location()
    if not utils.is_empty(location) then
        return " " .. ">" .. " " .. location
    end

    return ""
end

function M.config()
    local function maximize_status()
        return vim.t.maximized and "   " or ""
    end

    -- local lazy = require("lazy")
    local status = require("lazy.status")

    require("lualine").setup({
        options = {
            theme = "auto",
            icons_enabled = true,
            component_separators = { "", "" },
            section_separators = { "", "" },
            disabled_filetypes = {
                statusline = {},
                winbar = {
                    "help",
                    "startify",
                    "dashboard",
                    "packer",
                    "neogitstatus",
                    "NvimTree",
                    "Trouble",
                    "toggleterm",
                    "dapui_scopes",
                    "dapui_breakpoints",
                    "dapui_stacks",
                    "dapui_console",
                    "dap-repl",
                    "dapui_watches",
                },
            },
        },
        sections = {
            lualine_a = { "mode" },
            lualine_b = { "branch", "diff" },
            lualine_c = {
                -- {
                --     'filename',
                --     file_status = true,
                --     path = 3,
                --     shorting_target = 40,
                -- },
            },
            lualine_x = {
                -- {
                --     'diagnostics',
                --     sources = { 'nvim_diagnostic' }
                -- },
                "encoding",
                "fileformat",
                "filetype",
                maximize_status,
                {
                    function()
                        return status.updates()
                    end,
                    cond = status.has_updates,
                    color = { fg = aux_color },
                },
                -- {
                --     function()
                --         local stats = lazy.stats()
                --         local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
                --         return "羽" .. ms .. "ms"
                --     end,
                --     color = { fg = aux_color },
                -- },
            },
            lualine_y = { "progress" },
            lualine_z = { "location" },
        },
        inactive_sections = {
            lualine_a = {},
            lualine_b = {},
            lualine_c = { "filename" },
            lualine_x = { "location" },
            lualine_y = {},
            lualine_z = {},
        },
        tabline = {},
        extensions = { "nvim-tree", "toggleterm", "quickfix" },
        winbar = {
            lualine_a = {},
            lualine_b = {
                {
                    "diagnostics",
                    sources = { "nvim_diagnostic" },
                },
                {
                    get_location,
                    cond = function()
                        if package.loaded["nvim-navic"] then
                            return require("nvim-navic").is_available()
                        end
                    end,
                    color = { fg = aux_color },
                },
            },
            lualine_c = {},
            lualine_x = {
                {
                    get_modified,
                    color = { fg = aux_color },
                },
                {
                    "filename",
                    file_status = false,
                    newfile_status = true,
                    path = 3,
                },
            },
            lualine_y = {},
            lualine_z = {},
        },
    })
end

return M
