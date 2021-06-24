local M = {}

M.search_dotfiles = function()
    require('telescope.builtin').find_files({
            prompt_title = "< Dotfiles >",
            cwd = os.getenv("DOTFILES"),
        })
end


local home = os.getenv("HOME")
M.search_home = function()
    require('telescope.builtin').find_files({
            prompt_title = "< HOME >",
            cwd = home
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
            cwd = home .. "/vimwiki",
        })
end

return M
