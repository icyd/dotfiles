local utils = require('utils')
local api, cmd, g = vim.api, vim.cmd, vim.g
local opt, augroup = utils.opt, utils.augroup

local disabled_built_ins = {
  'gzip',
  'man',
  -- 'matchit',
  -- 'matchparen',
  'shada_plugin',
  'tarPlugin',
  'tar',
  'zipPlugin',
  'zip',
  -- 'netrwPlugin',
}

for i, name in ipairs(disabled_built_ins) do
  vim.g['loaded_' .. name] = 1
end

local indent = 4
opt('b', 'autoindent', true)
opt('b', 'expandtab', true)
opt('b', 'fileencoding', 'utf-8')
opt('b', 'fileformat', 'unix')
opt('b', 'infercase', true)
opt('b', 'shiftwidth', indent)
opt('b', 'softtabstop', indent)

opt('o', 'autochdir', false)
opt('o', 'autoread', true)
opt('o', 'background', 'dark')
opt('o', 'clipboard', 'unnamedplus')
opt('o', 'cmdheight', 2)
opt('o', 'completeopt', 'menu,menuone,noselect')
opt('o', 'diffopt', vim.o.diffopt..',vertical')
opt('o', 'grepprg', 'rg --vimgrep --smart-case --follow')
opt('o', 'hidden', true)
opt('o', 'history', 200)
opt('o', 'hlsearch', true)
opt('o', 'icm', 'nosplit')
opt('o', 'ignorecase', true)
opt('o', 'incsearch', true)
opt('o', 'mouse', 'n')
opt('o', 'scrolloff', 4)
opt('o', 'shell', 'zsh')
opt('o', 'shortmess', vim.o.shortmess..'atTAIc')
opt('o', 'showmatch', true)
opt('o', 'showmode', false)
opt('o', 'smartcase', true)
opt('o', 'splitbelow', true)
opt('o', 'splitright', true)
opt('o', 'termguicolors', true)
opt('o', 'lazyredraw', true)
opt('o', 'splitbelow', true)
opt('o', 'wildignorecase', true)
opt('o', 'undofile', true)
opt('o', 'writebackup', true)
opt('o', 'wildmenu', true)
opt('o', 'wildmode', 'longest,full')
vim.opt.wildignore = {
    '*.pyc',
    '*_build/*',
    '**/coverage/*',
    '**/node_modules/*',
    '**/android/*',
    '**/ios/*',
    '**/.git/*'
}
vim.opt.listchars = {
    nbsp = '~',
    extends = '»',
    precedes = '«',
    tab = '▷─',
    trail = '•',
    eol = '¬',
}
opt('w', 'colorcolumn', '79')
opt('w', 'cursorcolumn', false)
opt('w', 'cursorline', false)
opt('w', 'foldlevel', 99)
opt('w', 'foldmethod', 'indent')
opt('w', 'foldnestmax', 8)
opt('w', 'linebreak', true)
opt('w', 'list', true)
opt('w', 'number', true)
opt('w', 'relativenumber', true)
opt('w', 'signcolumn', 'auto')
opt('w', 'spell', false)
opt('w', 'wrap', true)

g.loaded_python_provider = 0
g.loaded_node_provider = 0
g.loaded_ruby_provider = 0
g.loaded_perl_provider = 0
g.loaded_python3_provider = 0

g.netrw_banner = 0
g.netrw_liststyle = 3
g.netrw_browse_split = 4
g.netrw_winsize = 20

augroup('undo_temp', {
    'BufWritePre /tmp/* setlocal noundofile',
})

augroup('CursorLine', {
        'VimEnter,WinEnter,BufWinEnter * setlocal cursorline',
        ' WinLeave * setlocal nocursorline',
})

augroup('auto_spell', {
    'BufRead,BufNewFile *.md,*.txt,*.pandoc setlocal spell spelllang=en_us',
    'FileType gitcommit setlocal spell spelllang=en_us',
})

augroup('term_start_insert', {
    'TermOpen,TermEnter * setlocal nonumber norelativenumber nocursorline signcolumn=no',
    'TermOpen * startinsert',
})

-- Packer
augroup('packer_compile_on_save', {
    'BufWritePost init.lua source <afile> | lua require("plugins").compile()',
})

cmd [[silent! command! PackerClean lua require("plugins").clean()]]
cmd [[silent! command! PackerCompile lua require("plugins").compile()]]
cmd [[silent! command! PackerInstall lua require("plugins").install()]]
cmd [[silent! command! PackerStatus lua require("plugins").status()]]
cmd [[silent! command! PackerSync lua require("plugins").sync()]]
cmd [[silent! command! PackerUpdate lua require("plugins").update()]]

cmd [[command! GrabServer lua require("utils").grab_server()]]

cmd [[
function! VerticalSplitBuffer(buffer)
    execute "vert belowright sb" a:buffer
endfunction

command! -nargs=1 Vbuffer call VerticalSplitBuffer(<f-args>)
]]

local pyenv = os.getenv("PY_ENV")
local nvr =  pyenv and pyenv .. "/nvr/bin/nvr" or nil
if nvr and vim.fn.has('nvim') and vim.fn.executable(nvr) then
    vim.env.VISUAL = nvr .. " -cc split --remote-wait-silent"
end
