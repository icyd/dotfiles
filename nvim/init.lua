vim.opt.shadafile = 'NONE'
vim.g.did_load_filetypes = 1
pcall(require, 'impatient')
require('settings')
require('keybindings')

if root then
   set.shada = ''
else
   vim.opt.shadafile = ''
end
