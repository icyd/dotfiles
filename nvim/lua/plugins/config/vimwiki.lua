local vimwiki_dir = os.getenv('VIMWIKI_HOME')

vim.g.vimwiki_global_ext = 0
vim.g.vimwiki_list = {
    {
        path = vimwiki_dir .. "/vimwiki",
        syntax = 'markdown',
        ext = '.md',
    }
}
vim.g.vimwiki_filetypes = {'markdown'}
vim.g.vimwiki_map_prefix = '<leader>W'
