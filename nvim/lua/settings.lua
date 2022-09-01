local api, g, opt = vim.api, vim.g, vim.opt

local disabled_built_ins = {
    'gzip',
    'man',
    -- 'matchit',
    -- 'matchparen',
    'shada_plugin',
    'tarPlugin',
    'tar',
    'zipPlugin',
    'zip',
    -- 'netrwPlugin',
}

for _, name in ipairs(disabled_built_ins) do
    vim.g['loaded_' .. name] = 1
end

local indent = 4
opt.autoindent = true
opt.expandtab = true
opt.fileencoding = 'utf-8'
opt.fileformat = 'unix'
opt.infercase = true
opt.shiftwidth = indent
opt.softtabstop = indent

opt.autochdir = false
opt.autoread = true
opt.background = 'dark'
opt.clipboard = 'unnamedplus'
opt.cmdheight = 2
opt.completeopt = 'menu,menuone,noselect'
opt.conceallevel = 1
opt.concealcursor = 'nc'
opt.diffopt = vim.o.diffopt .. ',vertical'
opt.grepprg = 'rg --vimgrep --smart-case --follow'
opt.hidden = true
opt.history = 200
opt.hlsearch = true
opt.icm = 'nosplit'
opt.ignorecase = true
opt.incsearch = true
opt.laststatus = 3
opt.mouse = 'n'
opt.scrolloff = 4
opt.shell = 'zsh'
opt.shortmess = vim.o.shortmess .. 'atTAIc'
opt.showmatch = true
opt.showmode = false
opt.smartcase = true
opt.splitbelow = true
opt.splitright = true
opt.termguicolors = true
opt.lazyredraw = true
opt.splitbelow = true
opt.wildignorecase = true
opt.undofile = true
opt.winbar = [[%=%m %f]]
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
opt.foldlevel = 4
opt.foldmethod = 'indent'
opt.foldnestmax = 8
opt.linebreak = true
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
g.netrw_liststyle = 3
g.netrw_browse_split = 4
g.netrw_winsize = 20

api.nvim_create_autocmd('BufWritePre', {
    pattern = '/tmp/*',
    command = 'setlocal noundofile',
    desc = 'Disable undofile for tmp files',
})

local cursor_line = api.nvim_create_augroup('cursor_line', { clear = true })
api.nvim_create_autocmd({ 'VimEnter', 'WinEnter', 'BufWinEnter' }, {
    pattern = '*',
    group = cursor_line,
    command = 'setlocal cursorline',
    desc = 'Set cursor line',
})

local auto_spell = api.nvim_create_augroup('auto_spell', { clear = true })
api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
    pattern = { '*.md', '*.txt', '*.pandoc' },
    group = auto_spell,
    command = 'setlocal spell spelllang=en_us',
    desc = 'Enable spell on pattern',
})
api.nvim_create_autocmd('FileType', {
    pattern = 'gitcommit',
    group = auto_spell,
    command = 'setlocal spell spelllang=en_us',
    desc = 'Enable spell on gitcommit filetype',
})

local nvim_term_conf = api.nvim_create_augroup('nvim_term_conf', { clear = true })
api.nvim_create_autocmd({ 'TermOpen', 'TermEnter' }, {
    pattern = '*',
    group = nvim_term_conf,
    command = 'setlocal nonumber norelativenumber nocursorline signcolumn=no',
    desc = 'Set terminal without numbers, cursorline or sign column',
})
api.nvim_create_autocmd('TermOpen', {
    pattern = '*',
    group = nvim_term_conf,
    command = 'startinsert',
    desc = 'Start terminal in insert mode',
})

local gitcommit_au = api.nvim_create_augroup('gitcommit_au', { clear = true })
api.nvim_create_autocmd('FileType', {
    pattern = 'gitcommit',
    group = gitcommit_au,
    command = 'setlocal textwidth=100',
    desc = 'Set text width on gitcommit files',
})

api.nvim_create_user_command('GrabServer', require "utils".grab_server, {})

api.nvim_create_user_command('Vbuffer', function(args)
    vim.cmd('vert belowright sb ' .. args.args)
end, { nargs = 1 })

-- Neovim-remote inside nvim when installed inside pyenv
local pyenv = os.getenv("PY_ENV")
local nvr = pyenv and pyenv .. "/nvr/bin/nvr" or nil
if nvr and vim.fn.has('nvim') and vim.fn.executable(nvr) then
    vim.env.VISUAL = nvr .. " -cc split --remote-wait-silent"
end
