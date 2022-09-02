require 'nvim-treesitter.configs'.setup {
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
        'org',
        'python',
        -- 'query',
        'regex',
        'ruby',
        'rust',
        'toml',
        'yaml',
    },
    indent = {
        enable = true,
    },
    highlight = {
        enable = true,
        additional_vim_regex_highlighting = { 'org' },
    },
    rainbow = {
        enable = true,
        extended_mode = true,
        max_file_lines = 1000
    },
    textsubjects = {
        enable = true,
        prev_selection = ',', -- (Optional) keymap to select the previous selection
        keymaps = {
            ['.'] = 'textsubjects-smart',
            [';'] = 'textsubjects-container-outer',
            ['i;'] = 'textsubjects-container-inner',
        },
    },
}
