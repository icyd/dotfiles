local vimwiki_dir = os.getenv('VIMWIKI')

vim.g.vimwiki_global_ext = 0
vim.g.vimwiki_list = {
    {
        path = vimwiki_dir,
        syntax = 'markdown',
        ext = '.md',
    }
}
vim.g.vimwiki_filetypes = {'markdown', 'pandoc'}
vim.g.vimwiki_map_prefix = '<leader>W'
