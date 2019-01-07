"##############################################################################
" Plugin manager setup
"##############################################################################
  call plug#begin('~/.config/nvim/plugged')
    "Colorschemes & themes
       Plug 'morhetz/gruvbox'

    "Gerenal plugins
        "Bracket mapping
       Plug 'tpope/vim-unimpaired'
        "Language server setup
       Plug 'autozimu/LanguageClient-neovim', {
           \ 'branch': 'next',
           \ 'do': 'bash install.sh',
           \ 'for': ['python', 'c', 'cpp', 'javascript', 'typescript',
           \ 'css', 'html', 'json', 'sh', 'lua', 'yaml']
           \ }
        "Lightweight status bar plugin
       Plug 'itchyny/lightline.vim'
        "Syntaxes plugin
       Plug 'sheerun/vim-polyglot'
         "Snippet engine
       Plug 'SirVer/ultisnips'
        "Snippet plugin
       Plug 'honza/vim-snippets'
        "Declaration of custom textobj
       Plug 'kana/vim-textobj-user'
        "EditorConfig plugin
       Plug 'editorconfig/editorconfig-vim'
        "Run make async.
       Plug 'neomake/neomake'

    "Fuzzy finder
        "fzf's vim wrapper
       Plug 'junegunn/fzf.vim'

    "Completion plugin
        "Ncm2 completion plug
       Plug 'ncm2/ncm2'
       Plug 'roxma/nvim-yarp'
        "Integration with Ultisnips
       Plug 'ncm2/ncm2-ultisnips'
        "Gtags source for ncm2
       Plug 'ncm2/ncm2-gtags'
        "Syntax source for ncm2
       Plug 'Shougo/neco-syntax'
       Plug 'ncm2/ncm2-syntax'
        "Detect js/css in html code
       Plug 'ncm2/ncm2-html-subscope'
        "Detect fenced code in mk
       Plug 'ncm2/ncm2-markdown-subscope'
       Plug 'ncm2/ncm2-path'
        "Completing words from other buffers
       Plug 'fgrsnau/ncm2-otherbuf'

    "Editing
        "Plugin to show marks
       Plug 'jacquesbh/vim-showmarks'
        "Auto pairing brackets plugin
       Plug 'jiangmiao/auto-pairs'
        "Plugin for sustitution, coresion, abbreviation
       Plug 'tpope/vim-abolish'
        "Plugin for enable star search in visual mode
       Plug 'bronson/vim-visual-star-search'
        "Surround brackets plugin
       Plug 'tpope/vim-surround'
        "Comment plugin
       Plug 'tpope/vim-commentary'
        "Async plugin for ctags & gtags managment
       Plug 'jsfaint/gen_tags.vim'
        "Tabularize plugin
       Plug 'godlygeek/tabular'

    "Syntax plugins
        "Git
       Plug 'tpope/vim-fugitive'
        "Jinja2 Syntax pluggin
       Plug 'Glench/Vim-Jinja2-Syntax'
        "Pandoc's syntax module
       Plug 'vim-pandoc/vim-pandoc-syntax'
        "Plugin for grammar checking with languagetool
       Plug 'rhysd/vim-grammarous', { 'on': 'GrammarousCheck' }
       Plug 'Ron89/thesaurus_query.vim', {
            \ 'on': 'ThesaurusQueryReplaceCurrentWord' }    "Synonims

    "HTML plugins
       Plug 'mattn/emmet-vim'

    "Markdown plugins
        "Pandoc's Markdown integration
       Plug 'vim-pandoc/vim-pandoc'

    "REPL plugin
        "Interact with REPL
       Plug 'Vigemus/iron.nvim'
        "Allow change of pyenv
       Plug 'lambdalisue/vim-pyenv', { 'for': 'python' }
    call plug#end()

"##############################################################################
" Plugin's configuration and keybindings
"##############################################################################
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

   "Run scripts
   " autocmd! FileType python nnoremap <buffer> <F9> :exec '!python' shellescape(@%,1)<CR>
   autocmd! FileType python setlocal makeprg=python\ %
   autocmd! FileType sh nnoremap <buffer> <F9> :exec '!sh' shellescape(@%,1)<CR>
   autocmd! FileType javascript nnoremap <buffer> <F9> :exec '!node' shellescape(@%,1)<CR>

   "Ncm2 config
   autocmd! BufEnter * call ncm2#enable_for_buffer()
   "No text injection, show menu with one, no autoselect
   set completeopt=noinsert,menuone,noselect
   "Enable selection with Tab
   inoremap <expr><tab> pumvisible()? "\<c-n>" : "\<tab>"
   inoremap <expr><s-tab> pumvisible()? "\<c-p>" : "\<s-tab>"
   "Expand snipppet with enter
   inoremap <silent> <expr> <CR> ncm2_ultisnips#expand_or("\<CR>", 'n')

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

   "FZF config
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
   nnoremap <silent> <leader>fb :<C-u>Buffers<CR>
   nnoremap <silent> <leader>fc :<C-u>Commits<CR>
   nnoremap <silent> <leader>fx :<C-u>Commands<CR>
   nnoremap <silent> <leader>fs :<C-u>Snippets<CR>
   nnoremap <silent> <leader>f/ :<C-u>History/<CR>
   nnoremap <silent> <leader>f: :<C-u>History:<CR>
   nnoremap <silent> <leader>fl :<C-u>Lines<CR>
   nnoremap <silent> <leader>fo :<C-u>BLines<CR>
   command! -bang Test
               \ call fzf#run({'options': '--reverse --hidden'})
   let g:fzf_layout = { 'down': '~20%' }
   let g:fzf_tags_command = 'GenGTAGS'
   let g:rg_command = '
     \ rg --column --line-number --no-heading --fixed-strings --ignore-case --no-ignore --hidden --color "always"
     \ -g "*.{js,json,php,md,styl,jade,html,config,py,cpp,c,go,hs,rb,conf}"
     \ -g "!{.git,node_modules,vendor}/*" '
   command! -bang -nargs=* Find call fzf#vim#grep(g:rg_command .shellescape(<q-args>), 1, <bang>0)

   "LSP
   let g:LanguageClient_autoStart=1
   let g:LanguageClient_settingsPath='/home/beto/.config/nvim/settings.json'
   let g:LanguageClient_loggingFile = '/tmp/LanguageClient.log'
   let g:LanguageClient_loggingLevel = 'WARN'
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
       \ 'lua': ['~/.luarocks/bin/lua-lsp'],
       \ 'yaml': ['~/.pyenv/versions/py3neovim/bin/yaml-language-server', '--stdio'],
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

   "Pandoc
   let g:pandoc#modules#enabled = ["formatting"]
   let g:pandoc#formatting#mode="ha"
   let g:pandoc#syntax#codeblocks#embeds#langs = ["python"]
   let g:pandoc#filetypes#pandoc_markdown = 1

   "Pweave
   augroup pandoc
       autocmd!
       autocmd BufNewFile,BufFilePre,BufRead *.pmd setlocal filetype=pandoc
       autocmd FileType pandoc setlocal makeprg=pweave\ -f\ pandoc\ %
   augroup END

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

   "Vim-Rooter
   let g:rooter_use_lcd = 1
   let g:rooter_change_directory_for_non_project_files = 'home'

   "Autopair
   let g:AutoPairsFlyMode = 1

   "Javascript plugins
   let g:javascript_plugin_jsdoc = 1
   let g:jsx_ext_required = 1

   "Iron lua config (temporary until implementation)
   luafile $HOME/.config/nvim/config/iron.lua
