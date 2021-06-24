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


return M
