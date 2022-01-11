vim.opt.shadafile = 'NONE'
vim.g.did_load_filetypes = 1
pcall(require, 'impatient')
require('settings')
require('keybindings')
-- pcall(require, 'packer_compiled')

-- vim.defer_fn(function()
--    require('plugins/packer')
-- end, 0)

if root then
   set.shada = ''
else
   vim.opt.shadafile = ''
end
