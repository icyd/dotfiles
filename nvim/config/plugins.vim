"##############################################################################
" Plugin manager setup
"##############################################################################
call plug#begin($XDG_DATA_HOME.'/nvim/site/plugged')

" Gerenal plugins
    " Bracket mapping
    Plug 'tpope/vim-unimpaired'
    " Lightweight status bar plugin
    Plug 'itchyny/lightline.vim'
    " Declaration of custom textobj
    Plug 'kana/vim-textobj-user'
    " EditorConfig plugin
    Plug 'editorconfig/editorconfig-vim'
    " Repeat plugins' commands
    Plug 'tpope/vim-repeat'
    " Increment dates, times, etc
    Plug 'tpope/vim-speeddating'
    " Lorem Ipsum
    Plug 'vim-scripts/loremipsum'
    " Autoread
    Plug 'chrisbra/vim-autoread'
    " Seamless navigation tmux-vim
    Plug 'christoomey/vim-tmux-navigator'
    " Session manager
    Plug 'tpope/vim-obsession'
    " Syntaxes plugin
    Plug 'sheerun/vim-polyglot'
    " Git
    Plug 'tpope/vim-fugitive'
    " HTML plugins
    Plug 'mattn/emmet-vim', { 'for': ['javascript', 'javascript.jsx', 'javascript.tsx', 'html', 'css', 'scss', 'php'] }

" Editing
"       set listchars=tab:‣\ ,trail:·,precedes:«,extends:»,eol:¬
    Plug 'Yggdroot/indentLine'
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

" Colorschemes & themes
    Plug 'lifepillar/vim-gruvbox8'

if empty($SERVER_MODE)
" General plugins that require python
    " Gundo, undo tree
    Plug 'sjl/gundo.vim'
    " Snippet engine
    Plug 'SirVer/ultisnips'
    " Snippet plugin
    Plug 'honza/vim-snippets'

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

    " Fuzzy finder
    " Fzf's vim wrapper
    Plug '~/.config/fzf'
    Plug 'junegunn/fzf.vim'

" Async plugin for ctags & gtags managment
    Plug 'ludovicchabant/vim-gutentags'
    "Gtags source for ncm2
    Plug 'ncm2/ncm2-gtags'
    " Run make async.
    Plug 'neomake/neomake'
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
    " reStructuredText plugin
    Plug 'gu-fan/riv.vim'
    " Pyenv plugin
    Plug 'lambdalisue/vim-pyenv', { 'for': 'python' }
    " Multilanguage debugger
    " loaded on demand
    Plug 'vim-vdebug/vdebug', { 'on': 'VdebugStart' }
else
    " Native vim completion engine
    Plug 'ajh17/VimCompletesMe'
endif
    "

call plug#end()

"##############################################################################
" Plugin's configuration and keybindings
"##############################################################################
    " When openning new latex file, use latex filetype
    let g:tex_flavor="latex"    "Use latex as default filetype

    let g:indentLine_char_list = ['|', '¦', '┆', '┊']

    " Lightline configuration
    set laststatus=2
    let g:lightline = {
        \ 'colorscheme': 'seoul256',
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
    autocmd BufNewFile,BufRead *.js set filetype=javascript.jsx
    let g:vim_jsx_pretty_colorful_config = 1

    " Makeprg definitions to use :make
    autocmd! FileType python setlocal makeprg=python\ %

     if (has("termguicolors"))
         set termguicolors
     endif

    " Set colorscheme
    set background=dark
    colorscheme gruvbox8_soft

    " EditorConfig
    let g:EditorConfig_exclude_patterns = ['fugitive://.*', 'scp://.*']

    " Vim-tmux-navigtar
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

    if empty($SERVER_MODE)
        " Ncm2 config
        autocmd! BufEnter * call ncm2#enable_for_buffer()
        " Enable selection with Tab
        inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
        inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

        " Snippet configuration
        let g:UltiSnipsExpandTrigger="<c-l>"
        let g:UltiSnipsJumpForwardTrigger="<tab>"
        let g:UltiSnipsJumpBackwardTrigger="<s-tab>"
        let g:UltiSnipsEditSplit="vertical"

        " Gundo configuration
        let g:gundo_prefer_python3 = 1
        let g:gundo_right=1
        nnoremap <silent> <leader>U :GundoToggle<CR>

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

        " Javascript plugins
        let g:javascript_plugin_jsdoc = 1
        let g:jsx_ext_required = 1

        " Vim-pyenv
        let g:pyenv#auto_activate=0
        let g:pyenv#python_exec='/usr/bin/python'

        " Gen_tags config
        let g:gen_tags#ctags=1
        let g:gen_tags#gtags_auto_gen=1
        let g:gen_tags#gtags_default_map=0
        let g:gen_tags#statusline=1
        let g:gen_tags#use_cache_dir=0
        " Gutertags
        let g:gutentags_ctags_exclude=['*.css', '*.html', '*.js', '*.json', '*.xml',
        \ '*.phar', '*.ini', '*.rst', '*.md','*/vendor/*',
        \ '*vendor/*/test*', '*vendor/*/Test*',
        \ '*vendor/*/fixture*', '*vendor/*/Fixture*',
        \ '*var/cache*', '*var/log*']

        " augroup MyGutentagsStatusLineRefresher
        "     autocmd!
        "     autocmd User GutentagsUpdating call lightline#update()
        "     autocmd User GutentagsUpdated call lightline#update()
        " augroup END

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

        "RIV
        let g:riv_python_rst_hl = 1

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
        if filereadable("$XDG_CONFIG_HOME/nvim/thesaurus/mthesaur.txt")
            let g:tq_map_keys=0
            nnoremap <Leader>zs :ThesaurusQueryReplaceCurrentWord<CR>
            let g:tq_mthesaur_file="~/.config/nvim/thesaurus/mthesaur.txt"
            let g:tq_enabled_backends=["openoffice_en", "mthesaur_txt", "datamuse_com", "openthesaurus_de"]
            let g:tq_language=['en', 'de']
        endif
    endif
