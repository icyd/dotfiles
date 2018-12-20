"###############################################################################
"General settings and configuration
"###############################################################################
    "Reload configuration after save
    augroup reload_vimrc
        autocmd!
        autocmd BufWritePost $MYVIMRC,*.vimrc nested source $MYVIMRC | echom "Reloaded " . $MYVIMRC | redraw
    augroup END

    "Colorscheme
    if has('termguicolors') && ($TERM != 'rxvt-unicode-256color')
        set termguicolors
    endif

    "Indentation
    set expandtab
    set shiftwidth=4
    set softtabstop=4
    set autoindent

    "Indentation for file types (deprecated by editorconfig file)
    " autocmd! BufRead,BufNewFile *.html,*.htm,*.css setlocal shiftwidth=2 softtabstop=2
    " autocmd! BufRead,BufNewFile *.js setlocal shiftwidth=2 softtabstop=2
    " autocmd! FileType markdown,pandoc setlocal textwidth=79 spell
    " autocmd! BufNewFile,BufRead *.py
        " \ setlocal textwidth=79

    augroup mail
        autocmd!
        autocmd FileType mail setlocal spell spelllang=en,es
        autocmd FileType mail nnoremap <F12> :exe ':silent !qutebrowser /tmp/email.html'<CR>
        autocmd BufWritePost neomutt-* :exe ':silent !mail2html.sh %'
    augroup END

    "Search
    set incsearch           "search as characters are entered
    set hlsearch            "highlight matches
    set ignorecase
    set smartcase

    "Folding
    "set nofoldenable          "enable folding
    "set foldlevelstart=2    "open most folds by default
    set foldnestmax=8       "defines max nested folds
    set foldmethod=indent   "fold based on indent level
    set foldlevel=99

    "Softwrapping
    set wrap                "Enable wrapping
    set linebreak
    set nolist

    "Clipboard
    set clipboard=unnamedplus "Use plus register as default clipboard

    "Defaults
    set number              "insert line number column
    set history=200         "increase history number
    set relativenumber      "show relative number from current line and absolute in the line
    set cursorline          "highlight the actual line
    set showcmd             "show last executed command
    filetype indent on      "load specific filetype indent files
    filetype plugin on      "load specific filetype plugin files
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
    augroup undo_temp
        autocmd!
        autocmd BufWritePre /tmp/* setlocal noundofile
    augroup END

    "Disable ruby, node.js and python2 support
    let g:loaded_python_provider = 1
    let g:loaded_node_provider = 1
    let g:loaded_ruby_provider = 1

    "Python provider (to use pyenv-virtualenv)
    let g:python3_host_prog = '/home/beto/.pyenv/versions/py3neovim/bin/python'

    "Vertical split function
    function! VerticalSplitBuffer(buffer)
        execute "vert belowright sb" a:buffer
    endfunction

    "VerticalSplitBuffer command
    command! -nargs=1 Vb call VerticalSplitBuffer(<f-args>)
    command! -nargs=1 Vbuffer call VerticalSplitBuffer(<f-args>)

    "Windows config
    set splitbelow          "Split always below
    set splitright          "Split always right

    "Terminal configuration
    set shell=zsh
    autocmd! TermOpen * startinsert

    "Highlight on lines with more than 80 characters
    set colorcolumn=81

    "Set characters to represent weird whitespaces
    exec "set listchars=tab:\uBB\uBB,trail:\uB7,nbsp:~,eol:\uAC"
    set list

    "Function to remove trailing whitespaces
    function! TrimTrailingSpaces()
            " Delete trailing spaces
            %s/\s*$//
            "Jump back to previous position
            ''
    endfunction

    "Command to call function for removing trailing spaces
    command! Trim call TrimTrailingSpaces()

"###############################################################################
"General keybindings
"###############################################################################
    "Map leader to 'space'
    let mapleader="\<space>"

    "Edit vimrc/zshrc and load vimrc bindings
    nnoremap <silent> <leader>ev :edit $MYVIMRC<CR>
    nnoremap <silent> <leader>ep :edit $HOME/.config/nvim/config/plugins.vim<CR>

    "Remaping to improve
    " Semicolon switch to command mode
    " nnoremap ; :
    " vnoremap ; :
    " " Comma find next match of f F t T etc
    " nnoremap , ;
    " vnoremap , ;
    " " Colon find prev match of f F t T etc
    " nnoremap : ,
    " vnoremap : ,

    "Disable 'badhabit' keys
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

    "Map to un-highlight
    nnoremap <silent> <leader><space> :nohlsearch<CR>

    "Moving through lines
    nnoremap $ g$
    nnoremap ^ g^
    nnoremap j gj
    nnoremap k gk

    "ESC secuence
    inoremap jk <ESC>

    "Make session
    nnoremap <silent> <leader>s :mksession<CR>

    "Clipboard mapping
    inoremap <C-v> <ESC>"+pa
    vnoremap <C-v> c<ESC>"+pa
    vnoremap <C-c> "+y

    "Defaults
    nnoremap <silent> <leader>b :ls<CR>:b<space>

    "Windows config
    inoremap <A-h> <C-\><C-N><C-w>h
    inoremap <A-j> <C-\><C-N><C-w>j
    inoremap <A-k> <C-\><C-N><C-w>k
    inoremap <A-l> <C-\><C-N><C-w>l
    nnoremap <A-h> <C-w>h
    nnoremap <A-j> <C-w>j
    nnoremap <A-k> <C-w>k
    nnoremap <A-l> <C-w>l

    "Terminal configuration
    nnoremap <silent> <leader>' :terminal<CR>
    tnoremap <ESC> <C-\><C-N>
    tnoremap <C-q><Esc> <Esc>
    tnoremap <A-h> <C-\><C-N><C-w>h
    tnoremap <A-j> <C-\><C-N><C-w>j
    tnoremap <A-k> <C-\><C-N><C-w>k
    tnoremap <A-l> <C-\><C-N><C-w>l

    "netrw configuration
    let g:netrw_banner=0
    let g:netrw_liststyle=3

    "Change directory to current file's folder
    nmap <silent> <leader>cd :lcd %:h<CR>:echo "Changed directory to: "expand('%:p:h')<CR>
    "Create parent directory of current file
    nmap <silent> <leader>md :!mkdir -p %:p:h<CR>

    " Open files located in the same dir in with the current file is edited
    map <leader>ew :e <C-R>=expand("%:p:h") . "/" <CR>

    "Expand current active directory
    cnoremap <expr> %% getcmdtype() == ':' ? expand('%:h').'/' : '%%'

    "Change directory on tabenter
    function! OnTabEnter(path)
      if isdirectory(a:path)
        let dirname = a:path
      else
        let dirname = fnamemodify(a:path, ":h")
      endif
      execute "tcd ". dirname
    endfunction()

    autocmd TabNewEntered * call OnTabEnter(expand("<amatch>"))

    "Source functions file
    source $HOME/.config/nvim/config/functions.vim

    "Grab nvr server
    augroup nvr
        autocmd!
        autocmd VimEnter * call Grab()
    augroup END

    "Plugin specific configuration comment out to disable plugins
    source $HOME/.config/nvim/config/plugins.vim
