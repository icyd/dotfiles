local M = {
    -- 'vimwiki/vimwiki',
    'ranjithshegde/orgWiki.nvim',
    event = 'VeryLazy',
}

function M.config()
    local vimwiki_dir = os.getenv('VIMWIKI_HOME')

    -- vim.g.vimwiki_global_ext = 0
    -- vim.g.vimwiki_list = {
    --     {
    --         path = vimwiki_dir .. '/vimwiki',
    --         syntax = 'markdown',
    --         ext = '.md',
    --     }
    -- }
    -- vim.g.vimwiki_filetypes = { 'markdown', 'pandoc' }
    -- vim.g.vimwiki_map_prefix = '<leader>W'
    --
    require('orgWiki').setup {
        wiki_path = { vimwiki_dir .. '/vimwiki' },
        diary_path = vimwiki_dir .. '/vimwiki/diary',
    }
end

return M
