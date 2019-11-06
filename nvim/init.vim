"###############################################################################
" General settings and configuration
"###############################################################################
    " Source functions file
    source $XDG_CONFIG_HOME/nvim/config/functions.vim

    " Reload configuration after save
    augroup reload_vimrc
        autocmd!
        autocmd BufWritePost $MYVIMRC,*.vim nested source $MYVIMRC | echom "Reloaded " . $MYVIMRC | redraw
    augroup END

    " Indentation
    set expandtab
    set shiftwidth=4
    set softtabstop=4
    set autoindent

    " Search
    set incsearch           "search as characters are entered
    set hlsearch            "highlight matches
    set ignorecase
    set smartcase

    " Folding
    set foldnestmax=8       "defines max nested folds
    set foldmethod=indent   "fold based on indent level
    set foldlevel=99

    " Softwrapping
    set wrap                "Enable wrapping
    set linebreak
    set nolist

    " Clipboard
    set clipboard=unnamedplus "Use plus register as default clipboard

    " Defaults
    set number              "insert line number column
    set history=200         "increase history number
    set relativenumber      "show relative number from current line and absolute in the line
    set cursorline          "highlight the actual line
    set showcmd             "show last executed command
    filetype indent on      "load specific filetype indent files
    filetype plugin on      "load specific filetype plugin files
    set infercase
    " Avoid open hover on autocompletion
    set completeopt-=preview
    " No text injection, show menu with one, no autoselect
    set completeopt=noinsert,menuone,noselect
    set shortmess+=c
    inoremap <c-c> <ESC>

    set wildmenu            "visual autocomplete for command
    set wildmode=longest,full
    set wildignorecase
    set lazyredraw          "redraw only when needed
    set showmatch           "highlight matching parenthesis
    set noshowmode          "remove showing mode, because of status line
    set hidden              "Allow buffer to keep open as hidden
    set fileformat=unix     "Use only LF for new lines
    set encoding=utf-8      "Set encoding displayed
    set fileencoding=utf-8  "Encoding of written file
    set nospell             "Disable spell check
    syntax on
    syntax enable
    set undofile            "Preserve undo history
    set scrolloff=2         "Preserve lines when scrolling
    set shortmess=aTAqI
    set signcolumn=yes
    set autoread
    augroup undo_temp
        autocmd!
        autocmd BufWritePre /tmp/* setlocal noundofile
    augroup END

    " Turn on spell check for certain filetypes automatically
    autocmd BufRead,BufNewFile *.md setlocal spell spelllang=en_us
    autocmd BufRead,BufNewFile *.txt setlocal spell spelllang=en_us
    autocmd FileType gitcommit setlocal spell spelllang=en_us

    " Mail configuration for neomutt
    augroup mail
        autocmd!
        autocmd FileType mail setlocal spell spelllang=en,es
        autocmd FileType mail nnoremap <F12> :exe ':silent !qutebrowser /tmp/email.html'<CR>
        autocmd BufWritePost neomutt-* :exe ':silent !mail2html.sh %'
    augroup END

    " Disable ruby, node.js and python2 support
    let g:loaded_python_provider = 1
    let g:loaded_node_provider = 1
    let g:loaded_ruby_provider = 1

    " Python provider (to use pyenv-virtualenv)
    if empty($SERVER_MODE)
        let g:python3_host_prog =  $PYENV_ROOT.'/versions/py3neovim/bin/python'
    else
        let g:python3_host_prog = 1
    endif


    " VerticalSplitBuffer command
    command! -nargs=1 Vb call VerticalSplitBuffer(<f-args>)
    command! -nargs=1 Vbuffer call VerticalSplitBuffer(<f-args>)

    " Windows config
    set splitbelow          "Split always below
    set splitright          "Split always right

    " Highlight on lines with more than 80 characters
    set colorcolumn=81

    " Set characters to represent weird whitespaces
    exec "set listchars=tab:\uBB\uBB,trail:\uB7,nbsp:~,eol:\uAC"
    set list

    " Command to call function for removing trailing spaces
    command! Trim call TrimTrailingSpaces()

"###############################################################################
" General keybindings
"###############################################################################
    " Map leader to 'space'
    let mapleader="\<space>"

    " Disable 'badhabit' keys
    nnoremap   <Up> <Nop>
    nnoremap   <Down>    <Nop>
    nnoremap   <Left>    <Nop>
    nnoremap   <Right>   <Nop>
    inoremap   <Up>      <Nop>
    inoremap   <Down>    <Nop>
    inoremap   <Left>    <Nop>
    inoremap   <Right>   <Nop>
    vnoremap   <Up>      <Nop>
    vnoremap   <Down>    <Nop>
    vnoremap   <Left>    <Nop>
    vnoremap   <Right>   <Nop>
    " inoremap   <BS>      <Nop>
    inoremap   <Del>     <Nop>

    " Map to un-highlight
    nnoremap <silent> <leader><space> :nohlsearch<CR>

    " Moving through lines
    nnoremap $ g$
    nnoremap ^ g^
    nnoremap j gj
    nnoremap k gk

    " ESC secuence
    inoremap jk <ESC>

    " Make session
    nnoremap <silent> <leader>s :mksession<CR>

    " Clipboard mapping
    inoremap <C-v> <ESC>"+pa
    vnoremap <C-v> c<ESC>"+pa
    vnoremap <C-c> "+y

    " Windows config
    inoremap <M-h> <C-\><C-N><C-w>h
    inoremap <M-j> <C-\><C-N><C-w>j
    inoremap <M-k> <C-\><C-N><C-w>k
    inoremap <M-l> <C-\><C-N><C-w>l
    nnoremap <M-h> <C-w>h
    nnoremap <M-j> <C-w>j
    nnoremap <M-k> <C-w>k
    nnoremap <M-l> <C-w>l

    if has('nvim')
        " Terminal configuration
        set shell=zsh
        autocmd! TermOpen * startinsert

        " Terminal configuration
        nnoremap <silent> <leader>' :terminal<CR>
        tnoremap <ESC> <C-\><C-N>
        tnoremap <C-q><Esc> <Esc>
        tnoremap <M-h> <C-\><C-N><C-w>h
        tnoremap <M-j> <C-\><C-N><C-w>j
        tnoremap <M-k> <C-\><C-N><C-w>k
        tnoremap <M-l> <C-\><C-N><C-w>l

        " On new tab, cd to the file's directory
        autocmd TabNewEntered * call OnTabEnter(expand("<amatch>"))

    endif

    " Increase with alt to avoid conflic with tmux
    nnoremap <M-a> <C-a>
    nnoremap <M-x> <C-x>

    " Define make shortcut
    nnoremap <leader>x :make<CR>

    " Define splits keybind
    nnoremap <leader>- :split<CR>
    nnoremap <leader>\ :vsplit<CR>

    " Define tab keybind
    nnoremap <leader>k :tabprev<CR>
    nnoremap <leader>j :tabprev<CR>

    " netrw configuration
    let g:netrw_banner=0
    let g:netrw_liststyle=3

    " Change directory to current file's folder
    nmap <silent> <leader>cd :lcd %:h<CR>:echo "Changed directory to: "expand('%:p:h')<CR>
    " Create parent directory of current file
    nmap <silent> <leader>md :!mkdir -p %:p:h<CR>

    " Open files located in the same dir in with the current file is edited
    map <leader>ew :e <C-R>=expand("%:p:h") . "/" <CR>

    " Expand current active directory
    cnoremap <expr> %% getcmdtype() == ':' ? expand('%:h').'/' : '%%'

    " Modify path to add bin from pyenv
    if empty($SERVER_MODE)
        let $PATH = $PYENV_ROOT.'/versions/py3neovim/bin/:'.$PATH
    endif

    " Write with sudo
    cmap w!! w !sudo tee % >/dev/null

    " Set colorscheme as fallback theme
    colorscheme desert

    if !has('nvim')
        " Create temp folder
        silent execute '!mkdir -p "'.$HOME.'/.vim/tmp"'
        " Clear old backups
        silent execute '!rm -f "'.$HOME.'/.vim/tmp/*~"'
        set backupdir=$HOME/.vim/tmp//
        set directory=$HOME/.vim/tmp//
        set undodir=$HOME/.vim/tmp//
    endif

    " Edit vimrc/zshrc and load vimrc bindings
    let s:main_config="$XDG_CONFIG_HOME/nvim/init.vim"
    exe "nnoremap <silent> <leader>ev :edit" . s:main_config . "<CR>"
    nnoremap <silent> <leader>eV :edit $MYVIMRC<CR>

    " Dynamic loading for plugins based on sys env
    let s:plugin_file="$XDG_CONFIG_HOME/nvim/config/plugins.vim"
    exe "nnoremap <silent> <leader>ep :edit " . s:plugin_file . "<CR>"
    call CheckandSource(s:plugin_file)
