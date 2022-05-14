require'nvim-treesitter.configs'.setup {
    ensure_installed = {
        'bash',
        'c',
        'cpp',
        'go',
        'hcl',
        'java',
        'json',
        'latex',
        'lua',
        'make',
        'markdown',
        'python',
        'regex',
        'ruby',
        'rust',
        'toml',
        'yaml',
    },
    highlight = {
        enable = true
    },
    rainbow = {
        enable = true,
        extended_mode = true,
        max_file_lines = 1000
    }
}
