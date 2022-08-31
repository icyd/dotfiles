vim.opt.shadafile = 'NONE'
require('settings')
require('keybindings')
require('plugins')

if root then
   set.shada = ''
else
   vim.opt.shadafile = ''
end
