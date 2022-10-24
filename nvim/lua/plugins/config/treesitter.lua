local swap_next, swap_prev = (function()
  local swap_objects = {
    p = "@parameter.inner",
    f = "@function.outer",
    c = "@class.outer",
  }

  local n, p = {}, {}
  for key, obj in pairs(swap_objects) do
    n[string.format("<leader>x%s", key)] = obj
    p[string.format("<leader>x%s", string.upper(key))] = obj
  end

  return n, p
end)()

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
        disable = { 'org' },
    },
    highlight = {
        enable = true,
        additional_vim_regex_highlighting = { 'org' },
    },
    matchup = {
        enable = true,
        disable = {},
    },
    rainbow = {
        enable = true,
        extended_mode = true,
        max_file_lines = 1000
    },
    context_commentstring = {
        enable = true,
        enable_autocmd = false,
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
    textobjects = {
        select = {
            enable = true,
            lookahead = true,
            keymaps = {
                -- You can use the capture groups defined in textobjects.scm
                ["af"] = "@function.outer",
                ["if"] = "@function.inner",
                ["ac"] = "@class.outer",
                -- you can optionally set descriptions to the mappings (used in the desc parameter of nvim_buf_set_keymap
                ["ic"] = { query = "@class.inner", desc = "Select inner part of a class region" },
            },
        },
        selection_modes = {
            ['@parameter.outer'] = 'v', -- charwise
            ['@function.outer'] = 'V', -- linewise
            ['@class.outer'] = '<c-v>', -- blockwise
        },
        move = {
            enable = true,
            set_jumps = true,
            goto_next_start = {
                [']m'] = '@function.outer',
                [']]'] = '@class.outer'
            },
            goto_next_end = {
                [']M'] = '@function.outer',
                [']['] = '@class.outer'
            },
            goto_previous_start = {
                ['[m'] = '@function.outer',
                ['[['] = '@class.outer'
            },
            goto_previous_end = {
                ['[M'] = '@function.outer',
                ['[]'] = '@class.outer'
            }
        },
        swap = {
           enable = true,
           swap_next = swap_next,
           swap_previous = swap_prev,
        },
        include_surronding_whitespace = true,
    },
}
