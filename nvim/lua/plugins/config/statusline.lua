local M = {}

function M.setup()
    require('lualine').setup {
      options = {
        icons_enabled = true,
        theme = 'gruvbox-material',
        component_separators = {'', ''},
        section_separators = {'', ''},
        disabled_filetypes = {}
      },
      sections = {
        lualine_a = {'mode'},
        lualine_b = {'branch', 'diff'},
        lualine_c = {
            {
                'filename',
                file_status = true,
                path = 3,
                shorting_target = 40,
            },
        },
        lualine_x = {
            {
                'diagnostics',
                sources={'nvim_diagnostic'}
            },
            'encoding',
            'fileformat',
            'filetype'
        },
        lualine_y = {'progress'},
        lualine_z = {'location'}
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {'filename'},
        lualine_x = {'location'},
        lualine_y = {},
        lualine_z = {}
      },
      tabline = {},
      extensions = {}
    }
end

return M
