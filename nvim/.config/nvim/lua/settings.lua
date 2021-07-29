local utils = require('utils')

local api, cmd, g = vim.api, vim.cmd, vim.g
local opt, augroup = utils.opt, utils.augroup

cmd 'filetype indent on'
cmd 'filetype plugin on'
cmd 'syntax on'
cmd 'syntax enable'
cmd 'colorscheme desert'

local indent = 4
opt('b', 'autoindent', true)
opt('b', 'expandtab', true)
opt('b', 'fileencoding', 'utf-8')
opt('b', 'fileformat', 'unix')
opt('b', 'infercase', true)
opt('b', 'shiftwidth', indent)
opt('b', 'softtabstop', indent)

opt('o', 'autoread', true)
opt('o', 'background', 'dark')
opt('o', 'clipboard', 'unnamedplus')
opt('o', 'cmdheight', 2)
opt('o', 'completeopt', 'menuone,noselect')
opt('o', 'diffopt', vim.o.diffopt..',vertical')
opt('o', 'grepprg', 'rg --vimgrep --smart-case --follow')
opt('o', 'hidden', true)
opt('o', 'history', 200)
opt('o', 'hlsearch', true)
opt('o', 'ignorecase', true)
opt('o', 'incsearch', true)
opt('o', 'mouse', 'n')
opt('o', 'scrolloff', 2)
opt('o', 'shell', 'zsh')
opt('o', 'shortmess', vim.o.shortmess..'atTAIc')
opt('o', 'showmatch', true)
opt('o', 'showmode', false)
opt('o', 'smartcase', true)
opt('o', 'splitbelow', true)
opt('o', 'splitright', true)
opt('o', 'termguicolors', true)
opt('o', 'undofile', true)
opt('o', 'wildignorecase', true)
opt('o', 'wildmenu', true)
opt('o', 'wildmode', 'longest,full')

opt('w', 'colorcolumn', '81')
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

api.nvim_exec([[
exec "set listchars=tab:\uBB\uBB,trail:\uB7,nbsp:~,eol:\uAC"
]], false)

cmd([[
set wildignore+=*.pyc
set wildignore+=*_build/*
set wildignore+=**/coverage/*
set wildignore+=**/node_modules/*
set wildignore+=**/android/*
set wildignore+=**/ios/*
set wildignore+=**/.git/*
]])

augroup('undo_temp', {
    'BufWritePre /tmp/* setlocal noundofile',
})


augroup('auto_spell', {
    'BufRead,BufNewFile *.md,*.txt,*.pandoc setlocal spell spelllang=en_us',
    'FileType gitcommit setlocal spell spelllang=en_us',
})

augroup('cd_on_tab', {
    'TabNewEntered * call OnTabEnter(expand("<amatch>"))',
})

augroup('term_start_insert', {
    'TermOpen * setlocal nonumber norelativenumber',
    'TermOpen * startinsert',
})

augroup('trim', {
    'BufWritePost * call TrimTrailingSpaces()',
})

api.nvim_exec([[
function! ReloadConfig() abort
  if &filetype == 'vim'
    :silent! write
    :source %
  elseif &filetype == 'lua'
    :silent! write
    :lua require("plenary.reload").reload_module'%'
    :luafile %
  endif

  return
endfunction

function! GrabServerName()
  if ! empty(v:servername)
    lua << EOF
      local server = io.open('/tmp/nvim-server', 'w')
      server:write(vim.api.nvim_get_vvar('servername'))
      server:close()
EOF
  endif
  echo "Setting servername to this nvim"
endfunction

function! VerticalSplitBuffer(buffer)
    execute "vert belowright sb" a:buffer
endfunction

function! TrimTrailingSpaces()
        %s/\s*$//
        ''
endfunction

function! OnTabEnter(path)
  if isdirectory(a:path)
    let dirname = a:path
  else
    let dirname = fnamemodify(a:path, ":h")
  endif
  execute "tcd ". dirname
endfunction

command! -nargs=1 Vbuffer call VerticalSplitBuffer(<f-args>)
command! ReloadConf call ReloadConfig()
command! Trim call TrimTrailingSpaces()

function! DScratch()
  let scratch_dir  = '~/Nextcloud/scratch/buffers'
  let scratch_date = strftime('%Y%m%d')
  let scratch_file = 'scratch-'. scratch_date . '.md'
  let scratch_buf  = bufnr(scratch_file)

  if scratch_buf == -1
    exe 'split ' . scratch_dir . '/' . scratch_file

    if empty(glob(scratch_dir . '/' . scratch_file))
      exe ':normal i# Scratch Buffer - ' . scratch_date
      exe ':normal o'
      " call CommentHeader()
      exe ':normal o'
      exe ':normal ^D'
      exe ':w'
    endif
  else
    exe 'split +buffer' . scratch_buf
  endif
endfunction

command! Scratch call DScratch()
]], false)
