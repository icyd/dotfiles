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
    " Mark the indentation column
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
    Plug 'Shougo/neco-syntax'
    Plug 'roxma/nvim-yarp'
    " Integration with Ultisnips
    Plug 'ncm2/ncm2-ultisnips'
    " Syntax source for ncm2
    Plug 'ncm2/ncm2-syntax'
    " Detect js/css in html code
    Plug 'ncm2/ncm2-html-subscope'
    " Detect fenced code in mk
    Plug 'ncm2/ncm2-markdown-subscope'
    Plug 'ncm2/ncm2-path'
    Plug 'ncm2/ncm2-tmux'
    "Gtags source for ncm2
    Plug 'ncm2/ncm2-gtags'
    Plug 'fgrsnau/ncm2-otherbuf', { 'branch': 'master' }
    " Completion source for css/scss
    Plug 'ncm2/ncm2-cssomni'
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
    " LSP
    Plug 'neovim/nvim-lsp'

" Syntax plugins
    " Golang plugin
    Plug 'arp242/gopher.vim'
    " Interactive interpreter REPL
    Plug 'jpalardy/vim-slime'

" Other plugins
    " Pandoc's Markdown integration
    Plug 'vim-pandoc/vim-pandoc'
    " reStructuredText plugin
    Plug 'gu-fan/riv.vim'
    Plug 'Rykka/InstantRst'
    " Pyenv plugin
    Plug 'lambdalisue/vim-pyenv', { 'for': 'python' }
    " Multilanguage debugger
    Plug 'puremourning/vimspector', {
        \ 'do': './install_gadget.py --enable-c --enable-python --enable-go --enable-bash --force-enable-chrome --force-enable-rust'
    \ }
else
    " Native vim completion engine
    Plug 'ajh17/VimCompletesMe'
endif


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

    " Makeprg definitions to use :make
    autocmd! FileType python setlocal makeprg=python\ %

     if (has("termguicolors"))
         set termguicolors
     endif

    " Set colorscheme
    colorscheme gruvbox8_soft
    let g:gruvbox_italics = 1
    highlight SignColumn ctermbg=NONE guibg=NONE

    if exists(":Tabularize")
      nnoremap <silent> <Leader>ae :Tabularize /=<CR>
      vnoremap <silent> <Leader>ae :Tabularize /=<CR>
      nnoremap <silent> <Leader>a<space> :Tabularize /\s\zs<CR>
      vnoremap <silent> <Leader>a<space> :Tabularize /\s\zs<CR>
      nnoremap <silent> <Leader>a\| :Tabularize /\|<CR>
      vnoremap <silent> <Leader>a\| :Tabularize /\|<CR>
      nnoremap <silent> <Leader>a\: :Tabularize /:\zs<CR>
      vnoremap <silent> <Leader>a\: :Tabularize /:\zs<CR>
      nnoremap <silent> <Leader>a, :Tabularize /,\zs<CR>
      vnoremap <silent> <Leader>a, :Tabularize /,\zs<CR>
    endif

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

        let g:rg_command = '
            \ rg --column --line-number --no-heading --fixed-strings --smart-case --no-ignore --hidden --color "always"
            \ -g "*.{js,json,php,md,styl,jade,html,config,py,cpp,c,go,hs,rb,conf}"
            \ -g "!{.git,node_modules,vendor}/*" '
        command! -bang -nargs=* Find call fzf#vim#grep(g:rg_command .shellescape(<q-args>), 1, <bang>0)

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
        endfunction()
        call SetLSPShortcuts()

        " Pandoc
        let g:pandoc#modules#enabled = ["formatting"]
        let g:pandoc#filetypes#pandoc_markdown = 1
        let g:pandoc#syntax#codeblocks#embeds#langs = ['html', 'python', 'bash=sh']
        let g:polyglot_disabled = ['html', 'markdown', 'coffee-script', 'vue']

        " RIV
        let g:riv_python_rst_hl = 1

        " Gopher plugin
        autocmd FileType go nnoremap <leader>gb :setl makeprg=go\ build\|:make<CR>
        autocmd FileType go nnoremap <leader>gr :setl makeprg=go\ run\|:make %<CR>
        autocmd FileType go nnoremap <leader>gt :compiler gotest\|:make<CR>
        autocmd FileType go nnoremap <Leader>gc :GoCoverage toggle<CR>
        autocmd FileType go nnoremap <Leader>gi :GoImport<Space>
        autocmd FileType go nnoremap <Leader>gd :GoImport -rm<Space>


        " Vimspector
        let g:vimspector_enable_mappings = 'HUMAN'

        " Pweave
        augroup pandoc
            autocmd!
            autocmd BufNewFile,BufFilePre,BufRead *.pmd setlocal filetype=pandoc
            autocmd FileType pandoc setlocal makeprg=pweave\ -f\ pandoc\ %
        augroup END

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

        " LSP
        let s:nvimlsp_file="$XDG_CONFIG_HOME/nvim/config/nvimlsp.lua"
        call CheckandSourceLua(s:nvimlsp_file)
endif
