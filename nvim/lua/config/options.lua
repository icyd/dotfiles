local g, opt = vim.g, vim.opt

local indent = 4
opt.autoindent = true
opt.expandtab = true
--opt.fileencoding = 'utf-8'
opt.fileformat = 'unix'
opt.infercase = true
opt.shiftwidth = indent
opt.softtabstop = indent

opt.autochdir = false
opt.autoread = true
opt.background = 'dark'
opt.clipboard = 'unnamedplus'
opt.cmdheight = 1
opt.completeopt = 'menu,menuone,noselect'
opt.conceallevel = 2
opt.concealcursor = 'nc'
opt.diffopt = vim.o.diffopt .. ',vertical'
opt.grepprg = 'rg --vimgrep --smart-case --follow --hidden'
opt.hidden = true
opt.history = 2000
opt.hlsearch = true
opt.icm = 'nosplit'
opt.ignorecase = true
opt.incsearch = true
opt.laststatus = 3
opt.mouse = 'n'
opt.scrolloff = 4
opt.shell = 'nu'
opt.shortmess = vim.o.shortmess .. 'atTAWIcC'
opt.showmatch = true
opt.showmode = false
opt.smartcase = true
opt.splitbelow = true
opt.splitright = true
opt.termguicolors = true
opt.wildignorecase = true
opt.undofile = true
-- opt.winbar = [[%=%m %f]]
opt.writebackup = true
opt.wildmenu = true
opt.wildmode = 'longest,full'
opt.wildignore = {
    '*.pyc',
    '*_build/*',
    '**/coverage/*',
    '**/node_modules/*',
    '**/android/*',
    '**/ios/*',
    '**/.git/*'
}
opt.listchars = {
    nbsp = '~',
    extends = '»',
    precedes = '«',
    tab = '▷─',
    trail = '•',
    eol = '¬',
}
opt.colorcolumn = '79'
opt.cursorcolumn = false
opt.cursorline = false
opt.foldenable = true
opt.foldlevel = 99
opt.foldlevelstart = 99
opt.foldmethod = 'expr'
opt.foldexpr = 'nvim_treesitter#foldexpr()'
opt.foldnestmax = 8
-- opt.linebreak = true
opt.list = true
opt.number = true
opt.relativenumber = true
opt.signcolumn = 'auto'
opt.spell = false
opt.wrap = true

g.loaded_python_provider = 0
g.loaded_node_provider = 0
g.loaded_ruby_provider = 0
g.loaded_perl_provider = 0
g.loaded_python3_provider = 0

g.netrw_banner = 0
g.netrw_keepdir = 0
g.netrw_liststyle = 3
g.netrw_browse_split = 4
g.netrw_winsize = 30
g.netrw_localcopydircmd = 'cp -r'
