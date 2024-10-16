local api = vim.api

api.nvim_create_autocmd('BufWritePre', {
    pattern = '/tmp/*',
    command = 'setlocal noundofile',
    desc = 'Disable undofile for tmp files',
})

local cursor_line = api.nvim_create_augroup('cursor_line', { clear = true })
api.nvim_create_autocmd({ 'InsertLeave', 'WinEnter' }, {
    group = cursor_line,
    command = 'set cursorline',
})
api.nvim_create_autocmd({ 'InsertEnter', 'WinLeave' }, {
    group = cursor_line,
    command = 'set nocursorline',
})

local auto_spell = api.nvim_create_augroup('auto_spell', { clear = true })
api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
    pattern = { '*.md', '*.txt', '*.pandoc', '*.org', '*.norg', '*.neorg' },
    group = auto_spell,
    command = 'setlocal spell spelllang=en tw=80',
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

api.nvim_create_autocmd('TextYankPost', {
    callback = function()
        vim.highlight.on_yank()
    end,
})

api.nvim_create_autocmd('BufReadPost', {
    command = [[
if line("'\"") > 1 && line("'\"") <= line("$")
    execute "normal! g`\""
endif
    ]],
})

local confluencewiki = api.nvim_create_augroup('ConfluenceWiki', { clear = true })
api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
    pattern = '*.jira',
    command = 'set filetype=confluencewiki',
    group = confluencewiki,
})

api.nvim_create_user_command('Vbuffer', function(args)
    vim.cmd('vert belowright sb ' .. args.args)
end, { nargs = 1 })

api.nvim_create_autocmd({ 'BufNewFile', 'BufRead' }, {
    pattern = '*.nu',
    command = 'set filetype=nu',
    group = vim.api.nvim_create_augroup('nu', { clear = true }),
})

-- Fix conceallevel for json files
vim.api.nvim_create_autocmd({ 'FileType' }, {
    pattern = 'json',
    callback = function()
        vim.wo.spell = false
        vim.wo.conceallevel = 0
    end,
})

-- create directories when needed, when saving a file
vim.api.nvim_create_autocmd("BufWritePre", {
    group = vim.api.nvim_create_augroup("auto_create_dir", { clear = true }),
    callback = function(event)
        local file = vim.loop.fs_realpath(event.match) or event.match

        vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
        local backup = vim.fn.fnamemodify(file, ":p:~:h")
        backup = backup:gsub("[/\\]", "%%")
        vim.go.backupext = backup
    end,
})

-- Function for ft=ledger
vim.api.nvim_create_autocmd({ 'FileType' }, {
    pattern = 'ledger',
    -- command = [[ %s/^\(\d\{4}[\/-]\d\{2}[\/-]\d\{2}\)\ze\s\+\w/\1 */c ]],
    command = [[
        function! CompleteTx()
            execute '%s/^\(\d\{4}[\/-]\d\{2}[\/-]\d\{2}\)\ze\s\+\w/\1 */c'
        endfunction

        command! -nargs=0 CompleteTx call CompleteTx()
    ]],
})

local pyenv = os.getenv("PY_ENV")
local nvr = pyenv and pyenv .. "/nvr/bin/nvr" or nil
if nvr and vim.fn.has('nvim') and vim.fn.executable(nvr) then
    vim.env.VISUAL = nvr .. " -cc split --remote-wait-silent"
end

if vim.fn.has('nvim') and vim.fn.executable('nvr') then
    vim.env.GIT_EDITOR = "nvr -cc split --remote-wait +'set bufhidden=wipe'"
end
