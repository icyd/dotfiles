"##############################################################################
" Plugin manager setup
"##############################################################################
call plug#begin($XDG_DATA_HOME.'/nvim/site/plugged')

" Gerenal plugins
    " Bracket mapping
    Plug 'tpope/vim-unimpaired'
    " Lightweight status bar plugin
    Plug 'itchyny/lightline.vim'
    " Snippet engine
    Plug 'SirVer/ultisnips'
    " Snippet plugin
    Plug 'honza/vim-snippets'
    " Declaration of custom textobj
    Plug 'kana/vim-textobj-user'
    " EditorConfig plugin
    Plug 'editorconfig/editorconfig-vim'
    " Run make async.
    Plug 'neomake/neomake'
    " Repeat plugins' commands
    Plug 'tpope/vim-repeat'
    " Increment dates, times, etc
    Plug 'tpope/vim-speeddating'
    " Gundo, undo tree
    Plug 'sjl/gundo.vim'
    " Lorem Ipsum
    Plug 'vim-scripts/loremipsum'
    " Autoread
    Plug 'chrisbra/vim-autoread'
    " Seamless navigation tmux-vim
    Plug 'christoomey/vim-tmux-navigator'
    " Session manager
    Plug 'tpope/vim-obsession'

    " Fuzzy finder
    " Fzf's vim wrapper
    Plug '~/.config/fzf'
    Plug 'junegunn/fzf.vim'

" Completion plugin
    " Ncm2 completion plug
    Plug 'ncm2/ncm2'
    Plug 'roxma/nvim-yarp'
    " Integration with Ultisnips
    Plug 'ncm2/ncm2-ultisnips'
    " Syntax source for ncm2
    Plug 'Shougo/neco-syntax'
    Plug 'ncm2/ncm2-syntax'
    " Detect js/css in html code
    Plug 'ncm2/ncm2-html-subscope'
    " Detect fenced code in mk
    Plug 'ncm2/ncm2-markdown-subscope'
    Plug 'ncm2/ncm2-path'
    Plug 'ncm2/ncm2-tmux'
    Plug 'ncm2/ncm2-gtags'
    Plug 'fgrsnau/ncm2-otherbuf', { 'branch': 'ncm2' }
    " Completion source for css/scss
    Plug 'ncm2/ncm2-cssomni'
    " vim-lsp support plugin
    Plug 'ncm2/ncm2-vim-lsp'
    " Completion from the current buffer
    Plug 'ncm2/ncm2-bufword'
    " Completion from github
    Plug 'ncm2/ncm2-github'

" Editing
    " Plugin to show marks
    Plug 'jacquesbh/vim-showmarks'
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
    Plug 'godlygeek/tabular'

    " Syntaxes plugin
    Plug 'sheerun/vim-polyglot'

    " Git
    Plug 'tpope/vim-fugitive'

    " HTML plugins
    Plug 'mattn/emmet-vim', { 'for': ['javascript', 'javascript.jsx', 'javascript.tsx', 'html', 'css', 'scss', 'php'] }

"#IGNORE
" DO NOT ERASE, USED TO GENERATE CONF FILE IGNORING FOLLOWING PLUGINS
" Colorschemes & themes
    Plug 'flazz/vim-colorschemes'

" Async plugin for ctags & gtags managment
    Plug 'jsfaint/gen_tags.vim'
    "Gtags source for ncm2
    Plug 'ncm2/ncm2-gtags'

    Plug 'prabirshrestha/async.vim'
    Plug 'prabirshrestha/vim-lsp'

" Grammar, spelling, related
    " Plugin for grammar checking with languagetool
    Plug 'rhysd/vim-grammarous', { 'on': 'GrammarousCheck' }
    " Synonims plugin
    Plug 'Ron89/thesaurus_query.vim', {
        \ 'on': 'ThesaurusQueryReplaceCurrentWord' }

" Syntax plugins
    " Detect filetype in context
    Plug 'Shougo/context_filetype.vim'
    " Jinja2 Syntax pluggin
    Plug 'Glench/Vim-Jinja2-Syntax'
    " Pandoc's syntax module
    Plug 'vim-pandoc/vim-pandoc-syntax'

    Plug 'metakirby5/codi.vim'
" Other plugins
    " Pandoc's Markdown integration
    Plug 'vim-pandoc/vim-pandoc'
    " Pyenv plugin
    Plug 'lambdalisue/vim-pyenv', { 'for': 'python' }
    " Multilanguage debugger
    " loaded on demand
    Plug 'vim-vdebug/vdebug', { 'on': 'VdebugStart' }
    "
"#ENDIGNORE

call plug#end()

"##############################################################################
" Plugin's configuration and keybindings
"##############################################################################
    " When openning new latex file, use latex filetype
    let g:tex_flavor="latex"    "Use latex as default filetype

    " Lightline configuration
    set laststatus=2
    let g:lightline = {
        \ 'colorscheme': 'seoul256',
        \ 'active': {
        \   'left': [ [ 'mode', 'paste' ],
        \             [ 'gitbranch', 'readonly', 'filename', 'modified' ] ]
        \ },
        \ 'component_function': {
        \   'gitbranch': 'fugitive#head'
        \ },
        \ }
    let g:tcomment#filetype#guess_typescript = 1
    let g:tcomment#filetype#guess_javascript = 1
    autocmd BufNewFile,BufRead *.js set filetype=javascript.jsx
    let g:vim_jsx_pretty_colorful_config = 1
    " Gundo configuration
    let g:gundo_prefer_python3 = 1
    let g:gundo_right=1
    nnoremap <silent> <leader>U :GundoToggle<CR>

    " Makeprg definitions to use :make
    autocmd! FileType python setlocal makeprg=python\ %

    " Ncm2 config
    autocmd! BufEnter * call ncm2#enable_for_buffer()
    " Avoid open hover on autocompletion
    set completeopt-=preview
    " No text injection, show menu with one, no autoselect
    set completeopt=noinsert,menuone,noselect
    " Enable selection with Tab
    inoremap <expr><tab> pumvisible()? "\<c-n>" : "\<tab>"
    inoremap <expr><s-tab> pumvisible()? "\<c-p>" : "\<s-tab>"

    " Snippet configuration
    let g:UltiSnipsExpandTrigger="<c-l>"
    let g:UltiSnipsJumpForwardTrigger="<tab>"
    let g:UltiSnipsJumpBackwardTrigger="<s-tab>"
    let g:UltiSnipsEditSplit="vertical"


    " FZF config
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
    let g:fzf_layout = { 'down': '~20%' }
    let g:fzf_tags_command = 'GenGTAGS'

    " Emmet
    let g:user_emmet_install_global=0
    " let g:user_emmet_leader_key='<C-Z>'
    let g:user_emmet_settings = {
    \  'javascript' : {
    \      'extends' : 'jsx',
    \  },
    \ 'typescript' : {
    \       'extends' : 'jsx',
    \ },
    \}
    autocmd FileType html,css,php,javascript,javascript.jsx,javascript.tsx EmmetInstall

    " set filetypes as typescript.tsx
    " autocmd BufNewFile,BufRead *.tsx,*.jsx set filetype=typescript.tsx

    " Fugitive
    autocmd! User fugitive
         \ if fugitive#buffer().type() =~# '^\%(tree\|blob\)$' |
         \   nnoremap <buffer> .. :edit %:h<CR> |
         \ endif
    autocmd BufReadPost fugitive://* set bufhidden=delete

    " Autopair
    let g:AutoPairsFlyMode = 0

    " Ansible-vim
     let g:ansible_unindent_after_newline = 1

    " Vim-tmux-navigtar
    let g:tmux_navigator_no_mapping = 1
    let g:tmux_navigator_save_no_switch = 1
    nnoremap <silent> <A-k> :TmuxNavigateUp<CR>
    nnoremap <silent> <A-j> :TmuxNavigateDown<CR>
    nnoremap <silent> <A-h> :TmuxNavigateLeft<CR>
    nnoremap <silent> <A-l> :TmuxNavigateRight<CR>
    nnoremap <silent> <A-#> :TmuxNavigatePrevious<CR>

    " Javascript plugins
    let g:javascript_plugin_jsdoc = 1
    let g:jsx_ext_required = 1

    " Vim-pyenv
    let g:pyenv#auto_activate=0
    let g:pyenv#python_exec='/usr/bin/python'

"#IGNORE
" DO NOT REMOVE, USED TO GENERATE CONF FILE FOR SERVER
" FOLLOWING CONFIGURATIONS ARE IGNORED
     if (has("termguicolors"))
         set termguicolors
     endif
    " Set colorscheme
    set background=dark
    " let gruvbox_bold=1
    " let gruvbox_italic=1
    " let g:oceanic_next_terminal_bold=1
    " let g:oceanic_next_terminal_italic=1
    colorscheme Tomorrow-Night-Eighties

    " Gen_tags config
    let g:gen_tags#ctags=1
    let g:gen_tags#gtags_auto_gen=1
    let g:gen_tags#gtags_default_map=0
    let g:gen_tags#statusline=1
    let g:gen_tags#use_cache_dir=0


    let g:rg_command = '
        \ rg --column --line-number --no-heading --fixed-strings --smart-case --no-ignore --hidden --color "always"
        \ -g "*.{js,json,php,md,styl,jade,html,config,py,cpp,c,go,hs,rb,conf}"
        \ -g "!{.git,node_modules,vendor}/*" '
    command! -bang -nargs=* Find call fzf#vim#grep(g:rg_command .shellescape(<q-args>), 1, <bang>0)

    " LSP
    let g:lsp_log_verbose = 1
    let g:lsp_log_file = '/tmp/vim-lsp.log'
    let g:lsp_signs_enabled = 1         " enable signs
    let g:lsp_diagnostics_echo_cursor = 1 " enable echo under cursor when in normal mode
    let g:lsp_virtual_text_enabled = 0
    let g:lsp_signs_error = {'text': '✗'}
    let g:lsp_signs_warning = {'text': '⚠'}
    let g:lsp_signs_information = {'text': '‼'}
    let g:lsp_signs_hint = {'text': '✦'}

    " Load lsp configuration files
    let lsp_files = systemlist('find $XDG_CONFIG_HOME/nvim/config/lsp -name "*.vim" ! -name "_*" -type f')
    for conf_file in lsp_files
        execute 'source '.fnameescape(conf_file)
    endfor

    " let g:LanguageClient_autoStart=1
    " let g:LanguageClient_loggingFile = '/tmp/LanguageClient.log'
    " let g:LanguageClient_serverStderr = '/tmp/LanguageServer.log'
    " let g:LanguageClient_loggingLevel = 'DEBUG'
    " let g:LanguageClient_selectionUI = 'fzf'
    " let g:LanguageClient_useVirtualText = 0
    " let g:LanguageClient_serverCommands = {
    "     \ 'python': ['pyls'],
    "     \ 'c': ['ccls', '--log-file=/tmp/cc.log'],
    "     \ 'cpp': ['ccls', '--log-file=/tmp/cc.log'],
    "     \ 'javascript': ['javascript-typescript-stdio'],
    "     \ 'typescript': ['typescript-language-server', '--stdio'],
    "     \ 'css': ['css-languageserver', '--stdio'],
    "     \ 'html': ['html-languageserver', '--stdio'],
    "     \ 'json': ['json-languageserver', '--stdio'],
    "     \ 'sh': ['bash-language-server', 'start'],
    "     \ 'lua': ['~/.luarocks/bin/lua-lsp'],
    "     \ 'yaml': ['yaml-language-server', '--stdio'],
    "     \ 'php': ['php', $HOME . '/.config/nvim/plugged/LanguageServer-php-neovim/vendor/bin/php-language-server.php'],
    "     \ 'vue': ['vls'],
    "     \ }

   " LSP keymap definition
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
    call SetLSPShortcuts()


    " EditorConfig
    let g:EditorConfig_exclude_patterns = ['fugitive://.*', 'scp://.*']

    " Neomake
    augroup my_neomake
      au!
      autocmd FileType scss,html,yaml,json call neomake#configure#automake_for_buffer('nrwi', 500)
    augroup END

    " Pandoc
    let g:pandoc#modules#enabled = ["formatting"]
    let g:pandoc#filetypes#pandoc_markdown = 1
    let g:pandoc#syntax#codeblocks#embeds#langs = ['html', 'python', 'bash=sh']
    let g:polyglot_disabled = ['html', 'markdown', 'coffee-script', 'vue']

    " Pweave
    augroup pandoc
        autocmd!
        autocmd BufNewFile,BufFilePre,BufRead *.pmd setlocal filetype=pandoc
        autocmd FileType pandoc setlocal makeprg=pweave\ -f\ pandoc\ %
    augroup END

    " Grammarous
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
        " nmap <buffer>gr <Plug>(grammarous-move-to-info-window)r
        nmap <buffer>gf <Plug>(grammarous-move-to-info-window)f
        " nmap <buffer>gR <Plug>(grammarous-move-to-info-window)R
    endfunction
    function! g:grammarous#hooks.on_reset(errs) abort
        nunmap <buffer>gn
        nunmap <buffer>gp
        " nunmap <buffer>gr
        nunmap <buffer>gf
        " nunmap <buffer>gR
    endfunction

    " Thesaurus
    let g:tq_map_keys=0
    nnoremap <Leader>zs :ThesaurusQueryReplaceCurrentWord<CR>
    let g:tq_mthesaur_file="~/.config/nvim/thesaurus/mthesaur.txt"
    let g:tq_enabled_backends=["openoffice_en", "mthesaur_txt", "datamuse_com", "openthesaurus_de"]
    let g:tq_language=['en', 'de']


    " Vdebug
     " let g:vdebug_keymap = {
     "     \    "run" : "<Leader>xs",
     "     \    "run_to_cursor" : "<F9>",
     "     \    "step_over" : "<F2>",
     "     \    "step_into" : "<F3>",
     "     \    "step_out" : "<F4>",
     "     \    "close" : "<F6>",
     "     \    "detach" : "<F7>",
     "     \    "set_breakpoint" : "<Leader>xb",
     "     \    "get_context" : "<F11>",
     "     \    "eval_under_cursor" : "<F12>",
     "     \    "eval_visual" : "<Leader>e",
     "     \}

    " if !exists('g:vdebug_options')
    "     let g:vdebug_options = {}
    " endif

    " let g:vdebug_options = {'ide_key': 'netbeans-xdebug'}
    " let g:vdebug_keymap['run'] = '<C-s>'
    " -------- Vdebug ---------
    " let g:vdebug_options= {
    " \    "port" : 9009,
    " \    "timeout" : 20,
    " \    "on_close" : "detach",
    " \    "break_on_open" : 0,
    " \    "ide_key" : "PHPSTORM",
    " \    "path_maps" : {},
    " \    "server" : "",
    " \    "debug_window_level" : 0,
    " \    "debug_file_level" : 8,
    " \    "debug_file" : "/tmp/vdebug.log",
    " \    "continuous_mode" : 1,
    " \    "watch_window_style" : "expanded",
    " \    "marker_default" : "⬦",
    " \    "marker_closed_tree" : "▸",
    " \    "marker_open_tree" : "▾"
    " \}

    " Iron lua config (temporary until implementation)
    " if has('nvim')
    "     luafile $HOME/.config/nvim/config/iron.lua
    " endif
"#ENDIGNORE
