vim.g.gutentags_cache_dir = os.getenv('HOME') .. '/.cache/guten_tags/'
vim.g.gutentags_file_list_command = 'rg --files'
vim.g.gutentags_add_ctrlp_root_markers = 0
-- vim.g.gutentags_trace = 1
vim.g.gutentags_ctags_exclude={'*.css', '*.html', '*.js', '*.json', '*.xml',
    '*.phar', '*.ini', '*.rst', '*.md', '*/vendor/*', '*vendor/*/test*',
    '*vendor/*/Test*', '*vendor/*/fixture*', '*vendor/*/Fixture*',
    '*var/cache*', '*var/log*',
}
