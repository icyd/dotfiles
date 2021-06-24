local utils = require('utils')
local map, augroup = utils.map, utils.augroup
local api, cmd, g = vim.api, vim.cmd, vim.g

cmd [[packadd paq-nvim]]
local paq = require('paq-nvim').paq

paq{'savq/paq-nvim', opt=true}

-- Colorscheme & themes
-- paq 'lifepillar/vim-gruvbox8'
paq 'rktjmp/lush.nvim'
paq 'npxbr/gruvbox.nvim'
-- Neovim lsp
paq 'neovim/nvim-lspconfig'
-- Lsp server installer
paq 'kabouzeid/nvim-lspinstall'
-- Lua functions
paq 'nvim-lua/plenary.nvim'
-- Statusbar
paq 'hoob3rt/lualine.nvim'
-- paq 'glepnir/galaxyline.nvim'
-- paq {'glepnir/galaxyline.nvim', branch='main'}
paq {'kyazdani42/nvim-web-devicons', opt=true}
-- paq 'tjdevries/astronauta.nvim'
-- Bracket mapping
paq 'tpope/vim-unimpaired'
-- Indentation by vim object
paq 'michaeljsmith/vim-indent-object'
-- Editorconfig
paq 'editorconfig/editorconfig-vim'
-- Repeat plugins commands
paq 'tpope/vim-repeat'
-- Increment dates, times, etc
paq 'tpope/vim-speeddating'
-- Lorem ipsum
paq {'vim-scripts/loremipsum', opt=true}
-- Tmux-vim navigation
paq 'christoomey/vim-tmux-navigator'
-- Session management
paq 'tpope/vim-obsession'
-- Polyglot
paq 'sheerun/vim-polyglot'
-- Git
paq 'tpope/vim-fugitive'
-- paq 'idanarye/vim-merginal'
-- Window maximizer
paq 'szw/vim-maximizer'
-- Treesitter
paq {'nvim-treesitter/nvim-treesitter', run=':TSUpdate'}
-- Mark indentation column
paq 'Yggdroot/indentLine'
-- Autopairing by brackets
paq 'jiangmiao/auto-pairs'
-- Substitution, coersion, abbreviation
paq 'tpope/vim-abolish'
-- Star search in visual mode
paq 'bronson/vim-visual-star-search'
-- Surrond brackets
paq 'tpope/vim-surround'
-- Comment plugin
paq 'tomtom/tcomment_vim'
-- Tabularize
paq 'godlygeek/tabular'
-- Undo tree
paq 'mbbill/undotree'
-- Async make
paq 'neomake/neomake'
-- Snips
paq 'hrsh7th/vim-vsnip'
paq 'hrsh7th/vim-vsnip-integ'
paq 'rafamadriz/friendly-snippets'
-- Fuzzy finder
-- paq {'junegunn/fzf', run='-> fzf#install()'}
-- paq 'junegunn/fzf.vim'
paq 'nvim-lua/popup.nvim'
paq 'nvim-lua/plenary.nvim'
paq 'nvim-telescope/telescope.nvim'
paq {'nvim-telescope/telescope-fzy-native.nvim', run='git submodule update --init --recursive'}
paq {'nvim-telescope/telescope-fzf-native.nvim', run='make'}
-- Completion
paq 'nvim-lua/completion-nvim'
paq 'steelsojka/completion-buffers'
paq 'albertoCaroM/completion-tmux'
paq 'kristijanhusak/completion-tags'
paq 'nvim-treesitter/completion-treesitter'
-- Syntax
paq 'hashivim/vim-terraform'
paq 'ekalinin/Dockerfile.vim'
paq 'rust-lang/rust.vim'
paq {'sirtaj/vim-openscad', opt=true}
-- Markdown
paq {'iamcco/markdown-preview.nvim', run='cd app && yarn install'}
paq 'vim-pandoc/vim-pandoc-syntax'
paq 'vim-pandoc/vim-pandoc'
paq 'vimwiki/vimwiki'
-- Async ctags & gtags management
paq 'ludovicchabant/vim-gutentags'
-- REPL
paq 'jpalardy/vim-slime'
-- Debugger
paq 'mfussenegger/nvim-dap'
-- Easy motion
paq 'phaazon/hop.nvim'
-- Registers preview
-- paq 'gennaro-tedesco/nvim-peekup'

--[[
Configurations
--]]
-- cmd [[colorscheme gruvbox8_soft]]
cmd [[colorscheme gruvbox]]
cmd [[autocmd Filetype openscad packadd! vim-openscad]]

-- Autopair
g.AutoPairsFlyMode = 0

-- Completion-nvim
-- Enable selection with Tab
cmd([[imap <expr> <Tab> pumvisible() ? '<C-n>' : vsnip#jumpable(1)  ? '<Plug>(vsnip-jump-next)' : '<Tab>']])
cmd([[imap <expr> <S-Tab> pumvisible() ? '<C-p>' : vsnip#jumpable(-1) ? '<Plug>(vsnip-jump-prev)' : '<S-Tab>']])

-- Expand or jump
cmd([[imap <expr> <C-l>   vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>']])
cmd([[smap <expr> <C-l>   vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>']])

-- Jump forward or backward
cmd([[smap <expr> <Tab>   vsnip#jumpable(1)   ? '<Plug>(vsnip-jump-next)'      : '<Tab>']])
cmd([[smap <expr> <S-Tab> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)'      : '<S-Tab>']])

map('i', '<C-j>', '<Plug>(completion_next_source)')
map('i', '<C-k>', '<Plug>(completion_prev_source)')

g.completion_confirm_key = '<C-y>'
g.completion_matching_strategy_list = {'exact', 'substring'}
g.completion_matching_smart_case = 1
g.completion_auto_change_source = 1
g.completion_trigger_keyword_length = 1
g.completion_trigger_keyword_length = 3
g.completion_enable_snippet = 'vim-vsnip'
g.completion_chain_complete_list = {
   default = {
       {complete_items = {'lsp', 'snippet', 'ts'}},
       {complete_items = {'tags', 'buffers', 'tmux'}},
       {mode = '<c-p>'},
       {mode = '<c-n>'},
    }
}

-- Select or cut text to use as $TM_SELECTED_TEXT in the next snippet.
map('n', 's', '<Plug>(vsnip-select-text)')
map('x', 's', '<Plug>(vsnip-select-text)')
map('n', 'S', '<Plug>(vsnip-cut-text)')
map('x', 'S', '<Plug>(vsnip-cut-text)')

cmd[[autocmd BufEnter * if &buftype != "nofile" | lua require'completion'.on_attach()]]

-- EditorConfig
g.EditorConfig_core_mode = "external_command"
g.EditorConfig_exec_path = "/usr/bin/editorconfig"
g.EditorConfig_exclude_patterns = {
   'fugitive://.*',
   'scp://.*',
   'fzf://.*',
}

-- Fugitive
map('n', '<leader>gs', ':Gstatus<CR>')
map('n', '<leader>gd', ':Gvdiffsplit!<CR>')
map('n', '<leader>gph', ':call GitPushUpstream()<CR>')
map('n', '<leader>gpl', ':call GitPullUpstream()<CR>')
map('n', '<leader>gh', ':diffget //2<CR>')
map('n', '<leader>gl', ':diffget //3<CR>')

api.nvim_exec([[
function! GitPushUpstream() abort
   echo "Pushing..."
   exec 'Git push -u origin ' . FugitiveHead()
   echo 'Pushed!'
endfunction

function! GitPullUpstream() abort
   echo "Pulling..."
   exec 'Git pull --set-upstream origin ' . FugitiveHead()
   echo 'Pulled!'
endfunction
]], false)

local fugitive_autocmd =  [[User fugitive if fugitive#buffer().type() =~# '^\%(tree\|blob\)$' ]]..
    [[nnoremap <buffer> .. :edit %:h<CR> | endif]]
augroup('fugitive', {
    fugitive_autocmd,
    'BufReadPost fugitive://* set bufhidden=delete',
})

-- FZF
-- g.fzf_tags_command = 'GenGTAGS'
-- g.fzf_preview_window = {'right:50%', 'ctrl-/'}
-- augroup('fzf', {
--     'FileType fzf tnoremap <buffer> <Esc> <Esc>',
--  })
-- map('n', '<leader>ff', ':<C-u>Files<CR>')
-- map('n', '<leader>fF', ':<C-u>Files $HOME<CR>')
-- map('n', '<leader>fv', ':<C-u>Files $XDG_CONFIG_HOME/nvim<CR>')
-- map('n', '<leader>pr', ':<C-u>ProjectMru<CR>')
-- map('n', '<leader>fr', ':<C-u>History<CR>')
-- map('n', '<leader>hs', ':<C-u>History/<CR>')
-- map('n', '<leader>hc', ':<C-u>History:<CR>')
-- map('n', '<leader>fg', ':<C-u>Rg<CR>')
-- map('n', '<leader>ft', ':<C-u>Tags<CR>')
-- map('n', '<leader>fh', ':<C-u>Helptags<CR>')
-- map('n', '<leader>b',  ':<C-u>Buffers<CR>')
-- map('n', '<leader>fc', ':<C-u>Commits<CR>')
-- map('n', '<leader>fx', ':<C-u>Commands<CR>')
-- map('n', '<leader>fs', ':<C-u>Snippets<CR>')
-- map('n', '<leader>f/', ':<C-u>History/<CR>')
-- map('n', '<leader>f:', ':<C-u>History:<CR>')
-- map('n', '<leader>fl', ':<C-u>Lines<CR>')
-- map('n', '<leader>fo', ':<C-u>BLines<CR>')

-- cmd([[command! -bang -nargs=* Rg call ]]..
--     [[fzf#vim#grep('rg --column --line-number --no-heading --color=always ]]..
--     [[--smart-case -- '.shellescape(<q-args>), 1, fzf#vim#with_preview(), <bang>0)]])

-- Gutentags
-- local home = os.getenv('HOME')
-- g.gutentags_cache_dir = home..'/.cache/guten_tags'
g.gutentags_ctags_tagfile = ".tags"
g.gutentags_add_ctrlp_root_markers = 0
g.gutentags_ctags_exclude={'*.css', '*.html', '*.js', '*.json', '*.xml',
    '*.phar', '*.ini', '*.rst', '*.md', '*/vendor/*', '*vendor/*/test*',
    '*vendor/*/Test*', '*vendor/*/fixture*', '*vendor/*/Fixture*',
    '*var/cache*', '*var/log*',
}

-- Hop
require('hop').setup{winblend=0.85}
map('n', '<localleader>w', "<CMD>lua require'hop'.hint_words()<CR>")
map('n', '<localleader>l', "<CMD>lua require'hop'.hint_lines()<CR>")
map('n', '<localleader>x', "<CMD>lua require'hop'.hint_char1()<CR>")
map('n', '<localleader>X', "<CMD>lua require'hop'.hint_char2()<CR>")
map('n', '<localleader>n', "<CMD>lua require'hop'.hint_patterns()<CR>")

-- IndentLine
g.indentLine_char_list = {'|', '¦', '┆', '┊'}
g.indentLine_fileTypeExclude = {"fzf"}

-- Markdown (mkdp)
g.mkdp_echo_preview_url = 1
g.mkdp_browser = 'Chrome'
g.mkdp_filetypes = {'markdown', 'pandoc'}

-- Maximize
g.maximizer_set_default_mapping = 0
map('n', '<leader>az', ':MaximizerToggle<CR>')
map('v', '<leader>az', ':MaximizerToggle<CR>gv')

-- Neomake
g.neomake_place_signs = 0
g.neomake_open_list = 2

-- Neovim-peekup
-- g.peekup_open = '<leader>"'
-- require('nvim-peekup.config').on_keystroke["delay"] = ''

-- Pandoc
g['pandoc#speel#enabled'] = 1
g['pandoc#spell#default_langs'] = {'en_us', 'es'}
g['pandoc#syntax#conceal#use'] = 0
g['pandoc#filetypes#handled'] = {"pandoc", "markdown"}
g['pandoc#filetypes#pandoc_markdown'] = 0

-- Rust
g.rustfmt_autosave = 1

-- Slime
g.slime_target = "tmux"
g.slime_paste_file = "/tmp/slime_paste"
g.slime_default_config = {socket_name="default", target_pane="{last}"}
g.slime_python_ipython = 1
g.slime_dont_ask_default = 1
g.slime_no_mappings = 1
map('x', '<localleader>s', '<Plug>SlimeRegionSend')
map('n', '<localleader>s', '<Plug>SlimeParagraphSend')
map('n', '<localleader>l', ':SlimeSend0 "<C-l>"<CR>')
map('n', '<localleader>c', ':SlimeSend0 "<C-c>"<CR>')
map('n', '<localleader>q', ':SlimeSend0 "<C-d>"<CR>')

-- Tabularize
map('n', '<localleader>e', ':Tabularize /=<CR>')
map('v', '<localleader>e' ,':Tabularize /=<CR>')
map('n', '<localleader><space>', ':Tabularize /<space>\zs<CR>')
map('v', '<localleader><space>', ':Tabularize /<space>\zs<CR>')
map('n', '<localleader>|', ':Tabularize /|<CR>')
map('v', '<localleader>|', ':Tabularize /|<CR>')
map('n', '<localleader>:', ':Tabularize /:\zs<CR>')
map('v', '<localleader>:', ':Tabularize /:\zs<CR>')
map('n', '<localleader>,', ':Tabularize /,\zs<CR>')
map('v', '<localleader>,', ':Tabularize /,\zs<CR>')

-- Tcomment
g['tcomment#filetype#guess_typescript'] = 1
g['tcomment#filetype#guess_javascript'] = 1

-- Telescope
require('telescope').setup {
    defaults = {
        file_sorter = require('telescope.sorters').get_fzf_sorter,
        prompt_prefix = '> ',
        color_devicons = true,
        file_previewer = require('telescope.previewers').vim_buffer_cat.new,
        grep_previewer = require('telescope.previewers').vim_buffer_vimgrep.new,
        qflist_previewer = require('telescope.previewers').vim_buffer_qflist.new,
        mappings = {
            i = {
                ["<C-x>"] = false,
                ["<C-q>"] = require('telescope.actions').send_to_qflist,
            },
        },
    },
    extensions = {
        fzf = {
            fuzzy = true,
            override_generic_sorter = false,
            override_file_sorter = true,
            case_mode = 'smart_case',
        },
    }
}
require('telescope').load_extension('fzf')
map('n', '<leader>ff', ":Telescope find_files<CR>")
map('n', '<leader>fg', ":lua require('my.telescope').project_files()<CR>")
map('n', '<leader>fG', ":Telescope live_grep<CR>")
map('n', '<leader>vh', ":Telescope help_tags<CR>")
map('n', '<leader>fr', ":Telescope oldfiles<CR>")
map('n', '<leader>b', ":Telescope buffers<CR>")
map('n', '<leader>fv', ":lua require('my.telescope').search_dotfiles()<CR>")
map('n', '<leader>fF', ":lua require('my.telescope').search_home()<CR>")
map('n', '<leader>f/', ':Telescope search_history<CR>')
map('n', '<leader>f:', ':Telescope command_history<CR>')
map('n', '<leader>ft', ":lua require('telescope.builtin').tags({ ctags_file = \".tags\" })<CR>")
map('n', '<leader>fs', ":lua require('telescope.builtin').grep_string({ search = vim.fn.input(\"Grep for: \") })<CR>")
map('n', '<leader>fw', ":lua require('telescope.builtin').grep_string({ search = vim.fn.expand(\"<cword>\") })<CR>")

map('n', '<localleader>r', ':Telescope registers<CR>')
map('n', '<localleader>x', ':Telescope commands<CR>')
map('n', '<localleader>n', ":lua require('my.telescope').find_notes()<CR>")

map('n', '<leader>gb', ':Telescope git_branches<CR>')
map('n', '<leader>gc', ':Telescope git_commits<CR>')
map('n', '<leader>gC', ':Telescope git_bcommits<CR>')
map('n', '<leader>fz', ':Telescope current_buffer_fuzzy_find<CR>')
map('n', '<leader>fi', ':Telescope treesitter<CR>')
-- map('n', '<leader>fs', ':<C-u>Snippets<CR>')

-- Terraform
g.terraform_align = 1
g.terraform_fold_sections = 1
g.terraform_fmt_on_save = 1

-- Treesitter
require'nvim-treesitter.configs'.setup { highlight = { enable = true } }

-- Undotree
g.undotree_WindowLayout=3
map('n', '<leader>U', ':UndotreeToggle<CR>')

-- Vim-tmux-navigator
g.tmux_navigator_no_mapping = 1
g.tmux_navigator_save_no_switch = 1
map('n', '<M-k>', ':TmuxNavigateUp<CR>')
map('n', '<M-j>', ':TmuxNavigateDown<CR>')
map('n', '<M-h>', ':TmuxNavigateLeft<CR>')
map('n', '<M-l>', ':TmuxNavigateRight<CR>')
map('n', '<M-#>', ':TmuxNavigatePrevious<CR>')

-- VimWiki
g.vimwiki_global_ext = 0
g.vimwiki_list = {
    {
        path = '~/vimwiki/',
        syntax = 'markdown',
        ext = '.wiki',
    }
}
g.vimwiki_filetypes = {'markdown', 'pandoc'}

-- Other
augroup('typescript_tsx', {
    'BufNewFile,BufRead *.tsx,*.jsx set filetype=typescript.tsx',
})
g.tex_flavor = "latex"
