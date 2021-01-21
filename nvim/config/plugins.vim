"##############################################################################
" Plugin manager setup
"##############################################################################
call plug#begin($XDG_DATA_HOME.'/nvim/site/plugged')

" Colorschemes & themes
    Plug 'lifepillar/vim-gruvbox8'

" Gerenal plugins
    " Bracket mapping
    Plug 'tpope/vim-unimpaired'
    " Lightweight status bar plugin
    Plug 'itchyny/lightline.vim'
    " Object by indentation
    Plug 'michaeljsmith/vim-indent-object'
    " EditorConfig plugin
    Plug 'editorconfig/editorconfig-vim'
    " Repeat plugins' commands
    Plug 'tpope/vim-repeat'
    " Increment dates, times, etc
    Plug 'tpope/vim-speeddating'
    " Lorem Ipsum
    Plug 'vim-scripts/loremipsum'
    " Seamless navigation tmux-vim
    Plug 'christoomey/vim-tmux-navigator'
    " Session manager
    Plug 'tpope/vim-obsession'
    " Nvim-treesitter
    Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
    " Git
    Plug 'tpope/vim-fugitive'
    Plug 'idanarye/vim-merginal'
    " Maximizer
    Plug 'szw/vim-maximizer'

" Editing
    " Mark the indentation column
    Plug 'Yggdroot/indentLine'
    " Auto pairing brackets plugin
    Plug 'jiangmiao/auto-pairs'
    " Plugin for sustitution, coresion, abbreviation
    Plug 'tpope/vim-abolish'
    " Plugin for enable star search in visual mode
    Plug 'bronson/vim-visual-star-search'
    " Surround brackets plugin
    Plug 'tpope/vim-surround'
    " Comment plugin
    Plug 'tomtom/tcomment_vim'
    " Tabularize plugin
    Plug 'godlygeek/tabular', { 'on': ['Tabularize', 'Tab'] }


" General plugins that require python
    " Undo tree
    Plug 'mbbill/undotree'
    " Snips engine
    Plug 'Shougo/neosnippet.vim'
    " Snippets
    Plug 'Shougo/neosnippet-snippets'
    " Plug 'honza/vim-snippets'
    " cheat.sh
    Plug 'RishabhRD/popfix'
    Plug 'RishabhRD/nvim-cheat.sh'
    " Async make
    Plug 'neomake/neomake'
    " Plug 'tpope/vim-dispatch'

" Completion plugin
    " HTML plugins
    Plug 'mattn/emmet-vim', { 'for': [
                \ 'javascript',
                \ 'javascript.jsx',
                \ 'javascript.tsx',
                \ 'html',
                \ 'css',
                \ 'scss',
                \ 'php',
                \ ] }
    " Completion plugin
    Plug 'nvim-lua/completion-nvim'
    Plug 'steelsojka/completion-buffers'
    Plug 'albertoCaroM/completion-tmux'
    Plug 'kristijanhusak/completion-tags'
    Plug 'nvim-treesitter/completion-treesitter'

    " Fuzzy finder
    Plug 'lotabout/skim', { 'dir': '~/.config/skim', 'do': './install' }
    Plug 'lotabout/skim.vim'

    " Async plugin for ctags & gtags managment
    Plug 'ludovicchabant/vim-gutentags'
    " LSP
    Plug 'neovim/nvim-lspconfig'
    Plug 'mattn/vim-lsp-settings', { 'on': 'LspInstallServer' }

" Syntax plugins
    " Golang plugin
    " Plug 'arp242/gopher.vim'
    " Plug 'tweekmonster/gofmt.vim'
    " Terraform plugin
    Plug 'hashivim/vim-terraform'
    " Dockerfile
    Plug 'ekalinin/Dockerfile.vim'
    " Rust plugin
    Plug 'rust-lang/rust.vim'
    " Openscad
    Plug 'sirtaj/vim-openscad'

" Other plugins
    " reStructuredText plugin
    Plug 'gu-fan/riv.vim', { 'for': 'rst' }
    Plug 'Rykka/InstantRst', { 'on': 'InstantRst' }
    " Interactive interpreter REPL
    Plug 'jpalardy/vim-slime'
    " Multilanguage debugger
    Plug 'puremourning/vimspector', {
        \ 'do': './install_gadget.py --enable-c --enable-python --enable-go --enable-bash --force-enable-chrome'
    \ }
call plug#end()

"##############################################################################
" Plugin's configuration and keybindings
"##############################################################################
if (has('termguicolors'))
   set termguicolors
endif

" Set colorscheme
colorscheme gruvbox8_soft

" Lightline configuration
set laststatus=2
let g:lightline = {
    \ 'colorscheme': 'gruvbox8',
    \ 'active': {
    \   'left': [ [ 'mode', 'paste' ],
    \             [ 'gitbranch', 'readonly', 'relativepath', 'modified' ] ],
    \   'right': [ [ 'lineinfo' ],
    \              [ 'percent' ],
    \              [ 'spell', 'obsession', 'fileformat', 'fileencoding', 'filetype' ],
    \              ['gutentags'] ],
    \ },
    \ 'component_function': {
    \   'gitbranch': 'fugitive#head',
    \    'obsession': 'ObsessionStatus',
    \    'gutentags': 'gutentags#statusline',
    \ },
    \ 'component': {
    \   'charvaluehex': '0x%B'
    \ },
    \ }

function! LightlineFilename()
    return expand('%')
endfunction

let g:tcomment#filetype#guess_typescript = 1
let g:tcomment#filetype#guess_javascript = 1

" Neomake
let g:neomake_place_signs = 0
let g:neomake_open_list = 2

" Makeprg definitions to use :make
" autocmd! FileType python setlocal makeprg=python\ %

let g:indentLine_char_list = ['|', '¦', '┆', '┊']
let g:indentLine_fileTypeExclude = ["fzf", "skim"]

" highlight SignColumn ctermbg=NONE guibg=NONE

function! TabularizeMapping()
  nnoremap <silent> <localleader>e :Tabularize /=<CR>
  vnoremap <silent> <localleader>e :Tabularize /=<CR>
  nnoremap <silent> <localleader><space> :Tabularize /\s\zs<CR>
  vnoremap <silent> <localleader><space> :Tabularize /\s\zs<CR>
  nnoremap <silent> <localleader>\| :Tabularize /\|<CR>
  vnoremap <silent> <localleader>\| :Tabularize /\|<CR>
  nnoremap <silent> <localleader>\: :Tabularize /:\zs<CR>
  vnoremap <silent> <localleader>\: :Tabularize /:\zs<CR>
  nnoremap <silent> <localleader>, :Tabularize /,\zs<CR>
  vnoremap <silent> <localleader>, :Tabularize /,\zs<CR>
endfunction
autocmd! VimEnter * if exists(":Tabularize") | call TabularizeMapping() | endif

" EditorConfig
let g:EditorConfig_exclude_patterns = [
    \ 'fugitive://.*',
    \ 'scp://.*',
    \ 'skim://.*',
    \ 'fzf://.*',
\ ]

" Vim-tmux-navigtor
let g:tmux_navigator_no_mapping = 1
let g:tmux_navigator_save_no_switch = 1
if has('nvim')
    nnoremap <silent> <M-k> :TmuxNavigateUp<CR>
    nnoremap <silent> <M-j> :TmuxNavigateDown<CR>
    nnoremap <silent> <M-h> :TmuxNavigateLeft<CR>
    nnoremap <silent> <M-l> :TmuxNavigateRight<CR>
    nnoremap <silent> <M-#> :TmuxNavigatePrevious<CR>
else
    nnoremap <silent> <Esc>k :TmuxNavigateUp<CR>
    nnoremap <silent> <Esc>j :TmuxNavigateDown<CR>
    nnoremap <silent> <Esc>h :TmuxNavigateLeft<CR>
    nnoremap <silent> <Esc>l :TmuxNavigateRight<CR>
endif

" Undotree configuration
let g:undotree_WindowLayout=3
nnoremap <silent> <leader>U :UndotreeToggle<CR>

" Completion-nvim config
" Enable selection with Tab
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
let g:completion_confirm_key = "\<C-l>"
let g:completion_matching_strategy_list = ['exact', 'substring']
" let g:completion_matching_strategy_list = ['exact', 'substring', 'fuzzy']
let g:completion_matching_smart_case = 1
let g:completion_auto_change_source = 1
let g:completion_trigger_keyword_length = 3 " default = 1
let g:completion_enable_snippets = 'Neosnippet'
let g:completion_chain_complete_list = {
    \ 'default': [
        \{'complete_items': ['lsp', 'snippet', 'ts', 'tags']},
        \{'complete_items': ['buffers', 'tmux']},
        \{'mode': '<c-p>'},
        \{'mode': '<c-n>'}
    \ ],
\}
imap <c-j> <Plug>(completion_next_source)
imap <c-k> <Plug>(completion_prev_source)
" Use completion-nvim in every buffer
autocmd BufEnter * lua require'completion'.on_attach()

" Skim config
autocmd! FileType fzf tnoremap <buffer> <Esc> <Esc>
nnoremap <silent> <leader>ff :<C-u>Files<CR>
nnoremap <silent> <leader>fF :<C-u>Files $HOME<CR>
nnoremap <silent> <leader>pr :<C-u>ProjectMru<CR>
nnoremap <silent> <leader>fr :<C-u>History<CR>
nnoremap <silent> <leader>hs :<C-u>History/<CR>
nnoremap <silent> <leader>hc :<C-u>History:<CR>
nnoremap <silent> <leader>fg :<C-u>Find<CR>
nnoremap <silent> <leader>ft :<C-u>Tags<CR>
nnoremap <silent> <leader>fh :<C-u>Helptags<CR>
nnoremap <silent> <leader>b :<C-u>Buffers<CR>
nnoremap <silent> <leader>fc :<C-u>Commits<CR>
nnoremap <silent> <leader>fx :<C-u>Commands<CR>
nnoremap <silent> <leader>fs :<C-u>Snippets<CR>
nnoremap <silent> <leader>f/ :<C-u>History/<CR>
nnoremap <silent> <leader>f: :<C-u>History:<CR>
nnoremap <silent> <leader>fl :<C-u>Lines<CR>
nnoremap <silent> <leader>fo :<C-u>BLines<CR>
let g:skim_layout = { 'down': '~30%' }
let g:fzf_tags_command = 'GenGTAGS'

" Maximize
let g:maximizer_set_default_mapping = 0
nnoremap <silent><leader>az :MaximizerToggle<CR>
vnoremap <silent><leader>az :MaximizerToggle<CR>gv

" set filetypes as typescript.tsx
autocmd BufNewFile,BufRead *.tsx,*.jsx set filetype=typescript.tsx

" Fugitive
nnoremap <leader>gs :Gstatus<CR>
nnoremap <leader>gd :Gvdiffsplit<CR>
nnoremap <leader>gdh :diffget //2<CR>
nnoremap <leader>gdl :diffget //3<CR>
autocmd! User fugitive
     \ if fugitive#buffer().type() =~# '^\%(tree\|blob\)$' |
     \   nnoremap <buffer> .. :edit %:h<CR> |
     \ endif
autocmd BufReadPost fugitive://* set bufhidden=delete

" Autopair
let g:AutoPairsFlyMode = 0

" Gutertags
let g:gutentags_cache_dir = $HOME .'/.cache/guten_tags'
let g:gutentags_add_ctrlp_root_markers = 0
let g:gutentags_ctags_exclude=[
                 \ '*.css',            '*.html', '*.js','*.json',     '*.xml',
                \ '*.phar',             '*.ini','*.rst',  '*.md','*/vendor/*',
       \ '*vendor/*/test*',   '*vendor/*/Test*',
    \ '*vendor/*/fixture*','*vendor/*/Fixture*',
           \ '*var/cache*',         '*var/log*'
\ ]

augroup MyGutentagsStatusLineRefresher
    autocmd!
    autocmd User GutentagsUpdating call lightline#update()
    autocmd User GutentagsUpdated call lightline#update()
augroup END

" Snippets
" let g:neosnippet#enable_snipmate_compatibility = 1
" let g:neosnippet#snippets_directory='~/.local/share/nvim/site/plugged/vim-snippets/snippets'

" LSP keymap definition
function! SetLSPShortcuts()
    nnoremap <leader>ld <cmd>lua vim.lsp.buf.definition()<CR>
    nnoremap <leader>lk <cmd>lua vim.lsp.buf.declaration()<CR>
    nnoremap <leader>lf <cmd>lua vim.lsp.buf.references()<CR>
    nnoremap <leader>lt <cmd>lua vim.lsp.buf.type_definition()<CR>
    nnoremap <leader>li <cmd>lua vim.lsp.buf.implementation()<CR>
    nnoremap <leader>ls <cmd>lua vim.lsp.buf.signature_help()<CR>
    nnoremap <leader>lh <cmd>lua vim.lsp.buf.hover()<CR>
    nnoremap <leader>lW <cmd>lua vim.lsp.buf.workspace_symbol()<CR>
    nnoremap <leader>lD <cmd>lua vim.lsp.buf.document_symbol()<CR>
endfunction
call SetLSPShortcuts()

" Gopher plugin
" autocmd FileType go nnoremap <localleader>gb :setl makeprg=go\ build\|:make<CR>
" autocmd FileType go nnoremap <localleader>gr :setl makeprg=go\ run\|:make %<CR>
" autocmd FileType go nnoremap <localleader>gt :compiler gotest\|:make<CR>
" autocmd FileType go nnoremap <localLeader>gc :GoCoverage toggle<CR>
" autocmd FileType go nnoremap <localLeader>gi :GoImport<Space>
" autocmd FileType go nnoremap <localLeader>gd :GoImport -rm<Space>

" Vimspector
let g:vimspector_enable_mappings = 'HUMAN'

" Terraform
let g:terraform_align = 1
let g:terraform_fold_sections = 1
let g:terraform_fmt_on_save = 1

" Rust
let g:rustfmt_autosave = 1

" Slime
let g:slime_target = "tmux"
let g:slime_paste_file = "/tmp/slime_paste"
let g:slime_default_config = {"socket_name": "default", "target_pane": "{last}"}
let g:slime_python_ipython = 1
let g:slime_dont_ask_default = 1
let g:slime_no_mappings = 1
xmap <localleader>s    <Plug>SlimeRegionSend
nmap <localleader>s    <Plug>SlimeParagraphSend
nmap <localleader>l    :SlimeSend0 "<c-l>"<CR>
nmap <localleader>c    :SlimeSend0 "<c-c>"<CR>
nmap <localleader>q    :SlimeSend0 "<c-d>"<CR>

" When openning new latex file, use latex filetype
let g:tex_flavor="latex" "Use latex as default filetype

" Treesitter
lua require'nvim-treesitter.configs'.setup { highlight = { enable = true } }

" LSP
let s:nvimlsp_file="$XDG_CONFIG_HOME/nvim/config/nvimlsp.lua"
call CheckandSourceLua(s:nvimlsp_file)
