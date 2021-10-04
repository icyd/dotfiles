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
paq {'kyazdani42/nvim-web-devicons', opt=true}
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
-- paq 'christoomey/vim-tmux-navigator'
-- paq 'nikvdp/neomux'
paq 'hkupty/nvimux'
-- Session management
paq 'tpope/vim-obsession'
-- Polyglot
paq 'sheerun/vim-polyglot'
-- Git
paq 'tpope/vim-fugitive'
-- Window maximizer
paq 'szw/vim-maximizer'
-- Treesitter
paq {'nvim-treesitter/nvim-treesitter', run=':TSUpdate'}
-- Mark indentation column
paq 'Yggdroot/indentLine'
-- Autopairing by brackets
-- paq 'jiangmiao/auto-pairs'
paq 'windwp/nvim-autopairs'
-- Substitution, coersion, abbreviation
paq 'tpope/vim-abolish'
-- Star search in visual mode
paq 'bronson/vim-visual-star-search'
-- Surrond brackets
-- paq 'tpope/vim-surround'
paq 'blackCauldron7/surround.nvim'
-- Comment plugin
paq 'tomtom/tcomment_vim'
-- Tabularize
paq 'godlygeek/tabular'
-- Undo tree
paq 'mbbill/undotree'
-- Async make
paq 'neomake/neomake'
--- Rainbow parenthesis
paq 'p00f/nvim-ts-rainbow'
-- Snips
paq 'hrsh7th/vim-vsnip'
paq 'hrsh7th/vim-vsnip-integ'
paq 'rafamadriz/friendly-snippets'
-- Fuzzy finder
paq 'junegunn/fzf'
paq 'junegunn/fzf.vim'
paq 'ojroques/nvim-lspfuzzy'
paq 'nvim-lua/popup.nvim'
paq 'nvim-lua/plenary.nvim'
paq 'nvim-telescope/telescope.nvim'
paq {'nvim-telescope/telescope-fzy-native.nvim', run='git submodule update --init --recursive'}
paq {'nvim-telescope/telescope-fzf-native.nvim', run='make'}
paq {'nvim-telescope/telescope-project.nvim'}
-- Completion
paq 'hrsh7th/nvim-compe'
--paq 'andersevenrud/compe-tmux'
-- Syntax
paq 'hashivim/vim-terraform'
paq 'ekalinin/Dockerfile.vim'
paq 'rust-lang/rust.vim'
paq {'sirtaj/vim-openscad', opt=true}
paq 'andrewstuart/vim-kubernetes'
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
paq 'nvim-telescope/telescope-dap.nvim'
paq 'Pocco81/DAPInstall.nvim'
paq 'theHamsta/nvim-dap-virtual-text'
paq 'rcarriga/nvim-dap-ui'
-- Easy motion
paq 'phaazon/hop.nvim'
-- Quickfix
paq 'kevinhwang91/nvim-bqf'
-- Other
paq 'moll/vim-bbye'
paq 'rhysd/vim-grammarous'
paq 'airblade/vim-rooter'

--[[
Configurations
--]]
-- cmd [[colorscheme gruvbox8_soft]]
cmd [[colorscheme gruvbox]]
cmd [[autocmd Filetype openscad packadd! vim-openscad]]

-- Autopair
g.AutoPairsFlyMode = 0
require('nvim-autopairs').setup{}

-- Completion-nvim
-- Enable selection with Tab
map('i', '<Tab>', "pumvisible() ? '<C-n>' : vsnip#jumpable(1)  ? '<Plug>(vsnip-jump-next)' : '<Tab>'", { noremap = false, expr = true })
map('i', '<S-Tab>', "pumvisible() ? '<C-p>' : vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)' : '<S-Tab>'", { noremap = false, expr = true })

-- Expand or jump
map('i', '<C-l>', "vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>'", { noremap = false, expr = true })
map('s', '<C-l>', "vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>'", { noremap = false, expr = true })

-- Jump forward or backward
map('s', '<Tab>', "vsnip#jumpable(1) ? '<Plug>(vsnip-jump-next)' : '<Tab>'", { noremap = false, expr = true })
map('s', '<S-Tab>', "vsnip#jumpable(-1) ? '<Plug>(vsnip-jump-prev)' : '<S-Tab>'", { noremap = false, expr = true })

require('compe').setup {
    enabled = true,
    autocomplete = true,
    debug = false,
    min_length = 1,
    preselect = 'enable',
    throttle_time = 80,
    source_timeout = 200,
    resolve_timeout = 800,
    incomplete_delay = 400,
    max_abbr_width = 1000,
    max_kind_width = 1000,
    max_menu_width = 1000000,
    documentation = {
        border = { '', '' ,'', ' ', '', '', '', ' ' },
        winhighlight = "NormalFloat:CompeDocumentation,FloatBorder:CompeDocumentationBorder",
        max_width = 120,
        min_width = 60,
        max_height = math.floor(vim.o.lines * 0.3),
        min_height = 1,
    },
    source = {
        path = true,
        buffer = true,
        calc = true,
        nvim_lsp = true,
        nvim_lua = true,
        vsnip = true,
        tags = true,
        -- tmux = true,
    }
}

require('nvim-autopairs.completion.compe').setup({
  map_cr = true, --  map <CR> on insert mode
  map_complete = true, -- it will auto insert `(` after select function or method item
  auto_select = false,  -- auto select first item
})

map('i', '<C-Space>', 'compe#complete()', { expr = true })
map('i', '<C-y>', "compe#confirm('<CR>')", { expr = true })
map('i', '<C-e>', "compe#close('<C-e>')", { expr = true })
map('i', '<C-f>', "compe#scroll({ 'delta': +4 })", { expr = true })
map('i', '<C-d>', "compe#scroll({ 'delta': -4 })", { expr = true })

-- Select or cut text to use as $TM_SELECTED_TEXT in the next snippet.
map('n', 's', '<Plug>(vsnip-select-text)')
map('x', 's', '<Plug>(vsnip-select-text)')
map('n', 'S', '<Plug>(vsnip-cut-text)')
map('x', 'S', '<Plug>(vsnip-cut-text)')

-- EditorConfig
g.EditorConfig_exclude_patterns = {
   'fugitive://.*',
   'scp://.*',
   'fzf://.*',
}

-- Fugitive
cmd[[command! -bang -nargs=* -complete=file Make NeomakeProject <args>]]
map('n', '<leader>gs', ':Git<CR>')
map('n', '<leader>gd', ':Gvdiffsplit!<CR>')
map('n', '<leader>gph', ':Git push<CR>')
map('n', '<leader>gpl', ':Git pull<CR>')
map('n', '<leader>gh', ':diffget //2<CR>')
map('n', '<leader>gl', ':diffget //3<CR>')

local fugitive_autocmd =  [[User fugitive if fugitive#buffer().type() =~# '^\%(tree\|blob\)$' ]]..
    [[nnoremap <buffer> .. :edit %:h<CR> | endif]]
augroup('fugitive', {
    fugitive_autocmd,
    'BufReadPost fugitive://* set bufhidden=delete',
})

require('lspfuzzy').setup {}

cmd([[command! -bang -nargs=* Rg call ]]..
    [[fzf#vim#grep('rg --column --line-number --no-heading --color=always ]]..
    [[--smart-case -- '.shellescape(<q-args>), 1, fzf#vim#with_preview(), <bang>0)]])

-- Gutentags
local home = os.getenv('HOME')
g.gutentags_cache_dir = home..'/.cache/guten_tags'
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

-- LanguageTool

-- Markdown (mkdp)
g.mkdp_echo_preview_url = 1
g.mkdp_browser = 'Chrome'
g.mkdp_filetypes = {'markdown', 'pandoc'}
-- cmd[[
-- let $NVIM_MKDP_LOG_FILE = expand('~/mkdp-log.log')
-- let $NVIM_MKDP_LOG_LEVEL = 'debug'
-- ]]

-- Maximize
g.maximizer_set_default_mapping = 0
map('n', '<C-a>z', ':MaximizerToggle<CR>')
map('v', '<C-a>z', ':MaximizerToggle<CR>gv')

-- Neomake
g.neomake_place_signs = 0
g.neomake_open_list = 2

-- Pandoc
g['pandoc#speel#enabled'] = 1
g['pandoc#spell#default_langs'] = {'en_us', 'es'}
g['pandoc#syntax#conceal#use'] = 0
g['pandoc#filetypes#handled'] = {"pandoc", "markdown"}
g['pandoc#filetypes#pandoc_markdown'] = 0

-- Rust
g.rustfmt_autosave = 1

-- Slime
g.slime_target = "neovim"
g.slime_paste_file = "/tmp/slime_paste"
g.slime_default_config = {socket_name="default", target_pane="{last}"}
g.slime_python_ipython = 1
g.slime_dont_ask_default = 1
g.slime_no_mappings = 1
map('x', '<localleader>ss', '<Plug>SlimeRegionSend')
map('n', '<localleader>ss', '<Plug>SlimeParagraphSend')
map('n', '<localleader>sl', ':SlimeSend0 "<C-l>"<CR>')
map('n', '<localleader>sc', ':SlimeSend0 "<C-c>"<CR>')
map('n', '<localleader>sq', ':SlimeSend0 "<C-d>"<CR>')

-- Surround
require('surround').setup{
    mappings_style = 'surround',
}

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
        project = {
            base_dirs = {
                {path = '~/.dotfiles'},
                {path = '~/Projects', max_depth = 2},
            },
            hidden_files = true,
        },
    }
}

require('dap-install').setup({
	installation_path = vim.fn.stdpath("data") .. "/dapinstall/",
	verbosely_call_debuggers = false,
})
g.dap_virtual_text = true
require("dapui").setup()
require('telescope').load_extension('fzf')
require('telescope').load_extension('project')
require('telescope').load_extension('dap')
map('n', '<leader>ff', ":Telescope find_files<CR>")
map('n', '<leader>fb', ":Telescope file_browser<CR>")
map('n', '<leader>fg', ":lua require('my.telescope').project_files()<CR>")
map('n', '<leader>fG', ":Telescope live_grep<CR>")
map('n', '<leader>fh', ":Telescope help_tags<CR>")
map('n', '<leader>fr', ":Telescope oldfiles<CR>")
map('n', '<leader>b', ":lua require('telescope.builtin').buffers({ show_all_buffers = true, sort_lastused = true, ignore_current_buffer = true })<CR>")
map('n', '<leader>fv', ":lua require('my.telescope').search_dotfiles()<CR>")
map('n', '<leader>fF', ":lua require('my.telescope').search_home()<CR>")
map('n', '<leader>fB', ":lua require('my.telescope').browse_home()<CR>")
map('n', '<leader>f/', ':Telescope search_history<CR>')
map('n', '<leader>f:', ':Telescope command_history<CR>')
map('n', '<leader>ft', ":lua require('telescope.builtin').tags({ ctags_file = \".tags\" })<CR>")
map('n', '<leader>fs', ":lua require('telescope.builtin').grep_string({ search = vim.fn.input(\"Grep for: \") })<CR>")
map('n', '<leader>fw', ":lua require('telescope.builtin').grep_string({ search = vim.fn.expand(\"<cword>\") })<CR>")
map('n', '<leader>fp', ":lua require('telescope').extensions.project.project{ display_type = 'full' }<CR>")

map('n', '<localleader>fR', ':Telescope registers<CR>')
map('n', '<localleader>fm', ':Telescope marks<CR>')
map('n', '<localleader>fj', ':Telescope jumplist<CR>')
map('n', '<localleader>fx', ':Telescope commands<CR>')
map('n', '<localleader>fn', ":lua require('my.telescope').find_notes()<CR>")

map('n', '<leader>gb', ':Telescope git_branches<CR>')
map('n', '<leader>gc', ':Telescope git_commits<CR>')
map('n', '<leader>gC', ':Telescope git_bcommits<CR>')
map('n', '<leader>fz', ':Telescope current_buffer_fuzzy_find<CR>')
map('n', '<leader>fi', ':Telescope treesitter<CR>')
-- map('n', '<leader>fs', ':<C-u>Snippets<CR>')

-- dap
map('n', '<leader>dq', '<cmd>lua require"dap".quit()<CR>')
map('n', '<leader>dct', '<cmd>lua require"dap".continue()<CR>')
map('n', '<leader>dsv', '<cmd>lua require"dap".step_over()<CR>')
map('n', '<leader>dsi', '<cmd>lua require"dap".step_into()<CR>')
map('n', '<leader>dso', '<cmd>lua require"dap".step_out()<CR>')
map('n', '<leader>dtb', '<cmd>lua require"dap".toggle_breakpoint()<CR>')

map('n', '<leader>dsc', '<cmd>lua require"dap.ui.variables".scopes()<CR>')
map('n', '<leader>dhh', '<cmd>lua require"dap.ui.variables".hover()<CR>')
map('v', '<leader>dhv',
    '<cmd>lua require"dap.ui.variables".visual_hover()<CR>')

map('n', '<leader>duh', '<cmd>lua require"dap.ui.widgets".hover()<CR>')
map('n', '<leader>duf',
    "<cmd>lua local widgets=require'dap.ui.widgets';widgets.centered_float(widgets.scopes)<CR>")

map('n', '<leader>dsbr',
    '<cmd>lua require"dap".set_breakpoint(vim.fn.input("Breakpoint condition: "))<CR>')
map('n', '<leader>dsbm',
    '<cmd>lua require"dap".set_breakpoint(nil, nil, vim.fn.input("Log point message: "))<CR>')
map('n', '<leader>dro', '<cmd>lua require"dap".repl.open()<CR>')
map('n', '<leader>drl', '<cmd>lua require"dap".repl.run_last()<CR>')

-- telescope-dap
map('n', '<leader>dcc',
    '<cmd>lua require"telescope".extensions.dap.commands{}<CR>')
map('n', '<leader>dco',
    '<cmd>lua require"telescope".extensions.dap.configurations{}<CR>')
map('n', '<leader>dlb',
    '<cmd>lua require"telescope".extensions.dap.list_breakpoints{}<CR>')
map('n', '<leader>dv',
    '<cmd>lua require"telescope".extensions.dap.variables{}<CR>')
map('n', '<leader>df',
          '<cmd>lua require"telescope".extensions.dap.frames{}<CR>')
map('n', '<leader>dui', '<cmd>lua require"dapui".toggle()<CR>')

-- Terraform
g.terraform_align = 1
g.terraform_fold_sections = 1
g.terraform_fmt_on_save = 1

-- Treesitter
require'nvim-treesitter.configs'.setup {
    highlight = {
        enable = true
    },
    rainbow = {
        enable = true,
        extended_mode = true,
        max_file_lines = 1000
    }
}

-- Undotree
g.undotree_WindowLayout=3
map('n', '<leader>U', ':UndotreeToggle<CR>')

-- Vim-tmux-navigator
-- g.tmux_navigator_no_mapping = 1
-- g.tmux_navigator_save_no_switch = 1
-- map('n', '<M-k>', ':TmuxNavigateUp<CR>')
-- map('n', '<M-j>', ':TmuxNavigateDown<CR>')
-- map('n', '<M-h>', ':TmuxNavigateLeft<CR>')
-- map('n', '<M-l>', ':TmuxNavigateRight<CR>')
-- map('n', '<M-#>', ':TmuxNavigatePrevious<CR>')

-- Nvimux
local nvimux = require('nvimux')
nvimux.config.set_all{
  prefix = '<C-a>',
  new_window = 'term', -- Use 'term' if you want to open a new term for every new window
  new_tab = nil, -- Defaults to new_window. Set to 'term' if you want a new term for every new tab
  new_window_buffer = 'single',
  quickterm_direction = 'botright',
  quickterm_orientation = '',
  quickterm_scope = 't', -- Use 'g' for global quickterm
  quickterm_size = '15',
}
nvimux.bindings.bind_all{
  {'s', ':NvimuxHorizontalSplit', {'n', 'v', 'i', 't'}},
  {'v', ':NvimuxVerticalSplit', {'n', 'v', 'i', 't'}},
}
nvimux.bootstrap()

-- VimWiki
g.vimwiki_global_ext = 0
g.vimwiki_list = {
    {
        path = '~/Nextcloud/vimwiki/',
        syntax = 'markdown',
        ext = '.md',
    }
}
g.vimwiki_filetypes = {'markdown', 'pandoc'}

-- Other
augroup('typescript_tsx', {
    'BufNewFile,BufRead *.tsx,*.jsx set filetype=typescript.tsx',
})
g.tex_flavor = "latex"
map('n', '<localleader>q', ':Bdelete<CR>')
map('n', '<localleader>Q', ':Bdelete!<CR>')

g.rooter_cd_cmd = 'lcd'
g.rooter_resolve_links = 1
