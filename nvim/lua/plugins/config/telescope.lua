local utils, telescope = require('utils'), require('telescope')
local map, augroup = utils.map, utils.augroup
local api = vim.api

telescope.setup {
    defaults = {
        file_sorter = require('telescope.sorters').get_fzf_sorter,
        prompt_prefix = '> ',
        color_devicons = true,
        file_previewer = require('telescope.previewers').vim_buffer_cat.new,
        grep_previewer = require('telescope.previewers').vim_buffer_vimgrep.new,
        qflist_previewer = require('telescope.previewers').vim_buffer_qflist.new,
        mappings = {
            i = {
                ["<C-x>"] = false,
                ["<C-q>"] = require('telescope.actions').send_to_qflist,
            },
        },
    },
    pickers = {
        find_files = {
            find_command = { "fd", "--hidden", "--exclude=.git" },
        },
    },
    extensions = {
        fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = 'smart_case',
        },
        project = {
           base_dirs = {
               {path = '~/Projects', max_depth = 5},
           },
           hidden_files = false
        },
    }
}

map('n', '<leader>ff', ":Telescope find_files<CR>")
map('n', '<leader>fl', ":lua require('telescope.builtin').find_files( { cwd = vim.fn.expand('%:p:h') })<CR>")
map('n', '<leader>fb', ":Telescope file_browser<CR>")
map('n', '<leader>fG', ":Telescope live_grep<CR>")
map('n', '<leader>fh', ":Telescope help_tags<CR>")
map('n', '<leader>fR', ":Telescope oldfiles<CR>")
map('n', '<leader>lA', ":Telescope lsp_code_actions<CR>")
map('n', '<leader>lG', ":Telescope lsp_document_diagnostics<CR>")
map('n', '<leader>ft', ":lua require('telescope.builtin').tags()<CR>")
map('n', '<leader>b', ":lua require('telescope.builtin').buffers({ show_all_buffers = true, sort_lastused = true, ignore_current_buffer = true, sort_mru = true })<CR>")
map('n', '<leader>fv', ":lua require('my.telescope').search_dotfiles()<CR>")
map('n', '<leader>fF', ":lua require('my.telescope').search_home()<CR>")
map('n', '<leader>fB', ":lua require('my.telescope').browse_home()<CR>")
map('n', '<leader>f/', ':Telescope search_history<CR>')
map('n', '<leader>f:', ':Telescope command_history<CR>')
map('n', '<leader>fs', ":lua require('telescope.builtin').grep_string({ search = vim.fn.expand(\"<cword>\") })<CR>")
map('n', '<leader>fS', ":lua require('telescope.builtin').grep_string({ search = vim.fn.input(\"Grep for: \") })<CR>")
-- map('n', '<leader>fw', ":lua telescope.extensions.git_worktree.git_worktrees()<CR>")
-- map('n', '<leader>fW', ":lua telescope.extensions.git_worktree.create_git_worktree()<CR>")
map('n', '<leader>fp', ":lua require('telescope').extensions.project.project{ display_type = 'full' }<CR>")

map('n', '<localleader>fR', ':Telescope registers<CR>')
map('n', '<localleader>fm', ':Telescope marks<CR>')
map('n', '<localleader>fj', ':Telescope jumplist<CR>')
map('n', '<localleader>fx', ':Telescope commands<CR>')
map('n', '<localleader>fn', ":lua require('my.telescope').find_notes()<CR>")

map('n', '<leader>gb', ':Telescope git_branches<CR>')
map('n', '<leader>gc', ':Telescope git_commits<CR>')
map('n', '<leader>gC', ':Telescope git_bcommits<CR>')
map('n', '<leader>fz', ':Telescope current_buffer_fuzzy_find<CR>')
map('n', '<leader>fi', ':Telescope treesitter<CR>')

map('n', '<leader>dcc',
    '<cmd>lua require"telescope".extensions.dap.commands{}<CR>')
map('n', '<leader>dco',
    '<cmd>lua require"telescope".extensions.dap.configurations{}<CR>')
map('n', '<leader>dlb',
    '<cmd>lua require"telescope".extensions.dap.list_breakpoints{}<CR>')
map('n', '<leader>dv',
    '<cmd>lua require"telescope".extensions.dap.variables{}<CR>')
map('n', '<leader>df',
          '<cmd>lua require"telescope".extensions.dap.frames{}<CR>')
map('n', '<leader>dui', '<cmd>lua require"dapui".toggle()<CR>')

-- augroup('Telescope', {
--     'FileType TelescopePrompt setlocal nocursorline nonumber norelativenumber signcolumn=no'
-- })
api.nvim_create_augroup('Telescope', { clear = true })
api.nvim_create_autocmd('FileType', { group = 'Telescope', pattern = 'TelescopePrompt', command = 'setlocal nocursorline nonumber norelativenumber signcolumn=no' })
