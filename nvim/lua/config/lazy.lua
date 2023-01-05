local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        'git',
        'clone',
        '--filter=blob:none',
        'https://github.com/folke/lazy.nvim.git',
        '--branch=stable',
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)


local ok, lazy = pcall(require, 'lazy')
if not ok then
   error('Error while sourcing lazy.nvim')
end

lazy.setup('plugins', {
    defaults = { lazy = true },
    diff = { cmd = 'terminal_git' },
    lockfile = vim.fn.stdpath('data') .. '/lazy-lock.json',
    performance = {
        cache = {
            enabled = true,
        },
        rtp = {
            disabled_plugins = {
                '2html_plugin',
                'getscript',
                'getscriptPlugin',
                'gzip',
                'logipat',
                'man',
                'matchit',
                'matchparen',
                'netrw',
                'netrwPlugin',
                'netrwSettings',
                'netrwFileHandlers',
                'rrhelper',
                'shada_plugin',
                'tar',
                'tarPlugin',
                'tohtml',
                'tutor',
                'zip',
                'zipPlugin',
            },
        },
    },
})
