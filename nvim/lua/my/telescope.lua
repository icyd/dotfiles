local utils = require('utils')

local M = {}

M.search_dotfiles = function()
    require('telescope.builtin').find_files({
            prompt_title = "< Dotfiles >",
            cwd = os.getenv("DOTFILES"),
            hidden = true,
        })
end


local home = os.getenv("HOME")
M.search_home = function()
    require('telescope.builtin').find_files({
            prompt_title = "< HOME >",
            cwd = home,
        })
end

M.browse_home = function()
    require('telescope').extensions.file_browser.file_browser({
            prompt_title = "< HOME >",
            cwd = home,
        })
end

M.project_files = function()
    local opts = {}
    local ok = pcall(require('telescope.builtin').git_files, opts)
    if not ok then require('telescope.builtin').find_files(opts) end
end

M.find_notes = function()
    require('telescope.builtin').file_browser({
            prompt_title = "< Notes >",
            shorten_path = false,
            cwd = home .. "/Nextcloud/vimwiki",
        })
end

M.reload = function()
    local function get_module_name(s)
        local module_name

        module_name = s:gsub("%.lua", "")
        module_name = module_name:gsub("%/", ".")
        module_name = module_name:gsub("%.init", "")

        return module_name
    end

    local prompt_title = "~ Neovim modules ~"
    local path = vim.fn.stdpath('config') .. '/lua'
    local opts = {
        prompt_title = prompt_title,
        cwd = path,
        attach_mappings = function(_, map)
            map('i', '<C-e>', function(_)
                local entry = require("telescope.actions.state").get_selected_entry()
                local name = get_module_name(entry.value)

                utils.RELOAD(name)
                utils.P(name .. ' reloaded!!')
            end)

            return true
        end
    }

    require('telescope.builtin').find_files(opts)
end

return M
