-- vim.opt.shadafile = 'NONE'
vim.opt.shadafile = ''
vim.g.mapleader = ' '
local ok_lazy = pcall(require, 'config.lazy')
require('config.options')
if not ok_lazy then
    require('config.autocmds')
    require('config.keymaps')
    require('config.fallback')
else
    vim.api.nvim_create_autocmd('User', {
        pattern = 'VeryLazy',
        callback = function()
            require('config.autocmds')
            require('config.keymaps')
        end,
    })
end
--
-- if root then
--     set.shada = ''
-- else
--     vim.opt.shadafile = ''
-- end
