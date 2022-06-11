vim.opt.shadafile = 'NONE'
pcall(require, 'impatient')
require('settings')
require('keybindings')

if root then
   set.shada = ''
else
   vim.opt.shadafile = ''
end
