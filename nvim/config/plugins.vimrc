"################################################################################
" Plugin manager setup
"################################################################################
    if has('win32') || has('win64')
        call plug#begin('~/AppData/Local/nvim/plugged')
    else
       call plug#begin('~/.config/nvim/plugged')
    endif

    "Colorschemes & themes
        Plug 'morhetz/gruvbox'

    "Gerenal plugins
        Plug 'tpope/vim-unimpaired'         "Bracket mapping
        Plug 'autozimu/LanguageClient-neovim', {
        \ 'branch': 'next',
        \ 'do': 'bash install.sh',
        \ }                                 "Language server setup
        Plug 'Shougo/deoplete.nvim', {
        \ 'do': ':UpdateRemotePlugins' }    "Completion plugin
        Plug 'itchyny/lightline.vim'        "Lightweight status bar plugin
        Plug 'sheerun/vim-polyglot'         "Syntaxes plugin
        " Plug 'zchee/deoplete-jedi'          "Python completion
        " Plug 'Shougo/deoplete-clangx'       "C/C++ source for deoplete
        Plug 'SirVer/ultisnips'             "Snippet engine
        Plug 'honza/vim-snippets'           "Snippet plugin
        Plug 'Shougo/denite.nvim'           "Dark powered plugin to unite all vim interfaces
        Plug 'ozelentok/denite-gtags'       "Denite's source: gtags
        Plug 'neoclide/denite-git'          "Denite's source: git
        Plug 'Shougo/neomru.vim'            "Enable file_mru for denite
        " Plug 'neomake/neomake'              "Run asynchronously programs
        Plug 'sjl/gundo.vim'                "Gundo tree
        Plug 'kana/vim-textobj-user'        "Declaration of custom textobj
        Plug 'jremmen/vim-ripgrep'          "Ripgrep plugin
        Plug 'editorconfig/editorconfig-vim' "EditorConfig plugin
        " Plug 'airblade/vim-rooter'          "Plugin to change directory to root

    "Editing
        Plug 'jacquesbh/vim-showmarks'      "Plugin to show marks
        Plug 'sjl/gundo.vim'                "Plugin to display undo tree
        Plug 'jiangmiao/auto-pairs'         "Auto pairing brackets plugin
        Plug 'tpope/vim-abolish'            "Plugin for sustitution, coresion, abbreviation
        Plug 'bronson/vim-visual-star-search' "Plugin for enable star search in visual mode
        Plug 'tpope/vim-surround'           "Surround brackets plugin
        Plug 'tpope/vim-commentary'         "Comment plugin
        Plug 'jsfaint/gen_tags.vim'         "Async plugin for ctags & gtags managment
        Plug 'godlygeek/tabular'            "Tabularize plugin

    "Git plugins
        Plug 'tpope/vim-fugitive'           "Git

    "Syntax plugins
        Plug 'rhysd/vim-grammarous'         "Plugin for grammar checking with languagetool
        Plug 'Ron89/thesaurus_query.vim'    "Synonims

    "HTML plugins
        Plug 'mattn/emmet-vim'
        Plug 'Glench/Vim-Jinja2-Syntax'     "Jinja2 Syntax pluggin

    "Markdown plugins
        Plug 'vim-pandoc/vim-pandoc'        "Pandoc's Markdown integration
        Plug 'vim-pandoc/vim-pandoc-syntax' "Pandoc's syntax module

    "Pweave plugin
        " Plug 'coyotebush/vim-pweave'

    call plug#end()

"################################################################################
" Plugin's configuration and keybindings
"################################################################################
    "Set colorscheme
    let gruvbox_bold=1
    let gruvbox_italic=1
    set background=dark
    colorscheme gruvbox

    "When openning new latex file, use latex filetype
    let g:tex_flavor="latex"    "Use latex as default filetype

    "Lightline configuration
    set laststatus=2
    let g:lightline = {
          \ 'colorscheme': 'jellybeans',
          \ 'active': {
          \   'left': [ [ 'mode', 'paste' ],
          \             [ 'gitbranch', 'readonly', 'filename', 'modified' ] ]
          \ },
          \ 'component_function': {
          \   'gitbranch': 'fugitive#head'
          \ },
          \ }

    "Gundo config
    if has('python3')
        let g:gundo_prefer_python3 = 1
    endif
    let g:gundo_right=1

    "Run python scripts
    autocmd! FileType python nnoremap <buffer> <F9> :exec '!python' shellescape(@%,1)<CR>

    "Denite config
    call denite#custom#map('insert','<Tab>','<denite:move_to_next_line>','noremap')
    call denite#custom#map('insert','<s-Tab>','<denite:move_to_previous_line>','noremap')
    call denite#custom#map('insert','<C-space>','<denite:choose_action>','noremap')
    call denite#custom#var('file_rec', 'command', ['rg', '--files', '--glob', '!.git'])
    call denite#custom#var('grep', 'command', ['rg'])
    call denite#custom#var('grep', 'default_opts', ['--no-heading', '--vimgrep', '--smart-case'])
    call denite#custom#var('grep', 'recursive_opts', [])
    call denite#custom#var('grep', 'pattern_opt', ['--regexp'])
    call denite#custom#var('grep', 'separator', ['--'])
    call denite#custom#var('grep', 'final_opts', [])

    "Deoplete enable
    let g:deoplete#enable_at_startup=1
    let g:deoplete#enable_smart_case=1
    call deoplete#custom#source('LanguageClient',
                                \ 'min_pattern_length',
                                \ 2)

    "Snippet configuration
    let g:UltiSnipsExpandTrigger="<c-j>"
    let g:UltiSnipsJumpForwardTrigger="<tab>"
    let g:UltiSnipsJumpBackwardTrigger="<s-tab>"
    let g:UltiSnipsEditSplit="vertical"

    "Gundo config
    nnoremap <silent> <F5> :GundoToggle<CR>

    "Gen_tags config
    let g:gen_tags#ctags=1
    let g:gen_tags#gtags_auto_gen=1
    let g:gen_tags#gtags_default_map=0
    let g:gen_tags#statusline=1
    let g:gen_tags#use_cache_dir=0
    "let g:gen_tags#verbose=1

    "Denite config
    nnoremap <silent> <leader>ff :<C-u>Denite file_rec<CR>
    nnoremap <silent> <leader>fr :<C-u>Denite file_mru<CR>
    nnoremap <silent> <leader>fb :<C-u>Denite buffer<CR>
    nnoremap <silent> <leader>fc :<C-u>Denite command<CR>
    nnoremap <silent> <leader>fg :<C-u>Denite grep<CR>

    "Deoplete enable
    inoremap <expr><tab> pumvisible()? "\<c-n>" : "\<tab>"
    inoremap <expr><s-tab> pumvisible()? "\<c-p>" : "\<s-tab>"

    "Neomake
    " call neomake#configure#automake('w')

    "LSP
    let g:LanguageClient_autoStart=1
    let g:LanguageClient_settingsPath='/home/beto/.config/nvim/settings.json'
    " let g:LanguageClient_fzfContextMenu = 0
    " let g:LanguageClient_hasSnippetSupport=0
    let g:LanguageClient_loggingFile = '/tmp/LanguageClient.log'
    let g:LanguageClient_loggingLevel = 'INFO'
    let g:LanguageClient_serverStderr = '/tmp/LanguageServer.log'
    let g:LanguageClient_serverCommands = {
        \ 'python': ['~/.pyenv/versions/py3neovim/bin/pyls'],
        \ 'c': ['ccls', '--log-file=/tmp/cc.log'],
        \ 'cpp': ['ccls', '--log-file=/tmp/cc.log'],
        \ 'javascript': ['~/.pyenv/versions/py3neovim/bin/javascript-typescript-stdio'],
        \ 'typescript': ['~/.pyenv/versions/py3neovim/bin/typescript-language-server', '--stdio'],
        \ 'css': ['~/.pyenv/versions/py3neovim/bin/css-languageserver', '--stdio'],
        \ 'html': ['~/.pyenv/versions/py3neovim/bin/html-languageserver', '--stdio'],
        \ 'json': ['~/.pyenv/versions/py3neovim/bin/json-languageserver', '--stdio'],
        \ 'sh': ['~/.pyenv/versions/py3neovim/bin/bash-language-server', 'start'],
    \ }

    "LSP keymap definition
    function! SetLSPShortcuts()
      nnoremap <leader>ld :call LanguageClient#textDocument_definition({'gotoCmd': 'split'})<CR>
      nnoremap <leader>lr :call LanguageClient#textDocument_rename()<CR>
      nnoremap <leader>lf :call LanguageClient#textDocument_formatting()<CR>
      nnoremap <leader>lt :call LanguageClient#textDocument_typeDefinition()<CR>
      nnoremap <leader>lx :call LanguageClient#textDocument_references()<CR>
      nnoremap <leader>la :call LanguageClient_workspace_applyEdit()<CR>
      nnoremap <leader>lc :call LanguageClient#textDocument_completion()<CR>
      nnoremap <leader>lh :call LanguageClient#textDocument_hover()<CR>
      nnoremap <leader>ls :call LanguageClient_textDocument_documentSymbol()<CR>
      nnoremap <leader>lm :call LanguageClient_contextMenu()<CR>
    endfunction()

    augroup LSP
      autocmd!
      autocmd FileType cpp,c,python,typescript,javascript,css,html,json call SetLSPShortcuts()
    augroup END

    "Avoid open hover on autocompletion
    set completeopt-=preview

    "EditorConfig
    let g:EditorConfig_exclude_patterns = ['fugitive://.*', 'scp://.*']

    "Vim-Rooter
    " let g:rooter_change_directory_for_non_project_files = ''
    " let g:rooter_manual_only = 1
    " let g:rooter_use_lcd = 1
    " let g:rooter_patterns = ['.root', 'Rakefile', '.git/']

    "Pandoc
    let g:pandoc#filetypes#pandoc_markdown = 1
    let g:pandoc#modules#enabled = ["formatting"]
    let g:pandoc#formatting#mode="ha"

    "Grammarous
    let g:grammarous#languagetool_cmd = 'languagetool'
    let g:grammarous#use_vim_spelllang = 1
    let g:grammarous#enable_spell_check = 1
    let g:grammarous#use_location_list = 1
    let g:grammarous#default_comments_only_filetypes = {
                \ '*' : 1, 'help' : 0, 'markdown' : 0,
                \ 'pandoc' : 0,
                \ }
    nnoremap <silent> <buffer><leader>zg :GrammarousCheck<CR>
    nnoremap <silent> <buffer><leader>zr :GrammarousReset<CR>
    let g:grammarous#hooks = {}
    function! g:grammarous#hooks.on_check(errs) abort
        nmap <buffer>gn <Plug>(grammarous-move-to-next-error)
        nmap <buffer>gp <Plug>(grammarous-move-to-previous-error)
        nmap <buffer>gr <Plug>(grammarous-move-to-info-window)r
        nmap <buffer>gf <Plug>(grammarous-move-to-info-window)f
        nmap <buffer>gR <Plug>(grammarous-move-to-info-window)R
    endfunction
    function! g:grammarous#hooks.on_reset(errs) abort
        nunmap <buffer>gn
        nunmap <buffer>gp
        nunmap <buffer>gr
        nunmap <buffer>gf
        nunmap <buffer>gR
    endfunction

    "Thesaurus
    let g:tq_map_keys=0
    nnoremap <Leader>zs :ThesaurusQueryReplaceCurrentWord<CR>
    let g:tq_mthesaur_file="~/.config/nvim/thesaurus/mthesaur.txt"
    let g:tq_enabled_backends=["openoffice_en", "mthesaur_txt", "datamuse_com", "openthesaurus_de"]
    let g:tq_language=['en', 'de']

    "Emmet
    let g:user_emmet_install_global=0
    autocmd FileType html,css EmmetInstall
    autocmd! FileType stylus setlocal makeprg=stylus\ %

    "Fugitive
    autocmd! User fugitive
      \ if fugitive#buffer().type() =~# '^\%(tree\|blob\)$' |
      \   nnoremap <buffer> .. :edit %:h<CR> |
  \ endif
    autocmd BufReadPost fugitive://* set bufhidden=delete

    "Autopair
    let g:AutoPairsFlyMode = 1

    "Javascript plugins
    let g:javascript_plugin_jsdoc = 1
    let g:jsx_ext_required = 1
