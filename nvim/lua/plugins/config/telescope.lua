local telescope = require('telescope')
local builtin = require('telescope.builtin')
local my_telescope = require('my.telescope')
local api, map = vim.api, vim.keymap.set

pcall(require, 'git-worktree')
pcall(telescope.load_extension, 'aerial')
pcall(telescope.load_extension, 'notify')
pcall(telescope.load_extension, 'harpoon')
pcall(telescope.load_extension, 'git_worktree')

local telescope_mappings = {
    i = {
        ["<C-x>"] = false,
        ["<C-q>"] = require('telescope.actions').send_to_qflist,
    },
}

local ok_tr, trouble = pcall(require, "trouble.providers.telescope")
if ok_tr then
    telescope_mappings.i['<C-t>'] = trouble.open_with_trouble
    telescope_mappings.n = {}
    telescope_mappings.n['<C-t>'] = trouble.open_with_trouble
end

telescope.setup {
    defaults = {
        file_sorter = require('telescope.sorters').get_fzf_sorter,
        prompt_prefix = '> ',
        color_devicons = true,
        file_previewer = require('telescope.previewers').vim_buffer_cat.new,
        grep_previewer = require('telescope.previewers').vim_buffer_vimgrep.new,
        qflist_previewer = require('telescope.previewers').vim_buffer_qflist.new,
        mappings = telescope_mappings,
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
                { path = '~/Projects', max_depth = 5 },
            },
            hidden_files = false
        },
        file_browser = {
            hijack_netrw = true,
        },
        aerial = {
            show_nesting = {
                ['_'] = false, -- This key will be the default
                json = true,   -- You can set the option for specific filetypes
                yaml = true,
            }
        }
    }
}

map('n', '<leader>ff', builtin.find_files, { desc = 'Find files' })
map('n', '<leader>fl',
    function() builtin.find_files({ cwd = vim.fn.expand('%:p:h') }) end,
    { desc = 'Find files relative current file' })
map('n', '<leader>fb', function()
    telescope.extensions.file_browser.file_browser()
end, { desc = 'Browse files' })
map('n', '<leader>fg', builtin.current_buffer_fuzzy_find,
    { desc = 'Find in current buffer' })
map('n', '<leader>fG', builtin.live_grep,
    { desc = 'Live grep' })
map('n', '<leader>fh', builtin.help_tags,
    { desc = 'Help tags' })
map('n', '<leader>fR', builtin.oldfiles,
    { desc = 'Oldfiles' })
-- map('n', '<leader>lA', builtin.lsp_code_actions,
--     { desc = 'Lsp code actions' })
-- map('n', '<leader>lG', builtin.lsp_document_diagnostics,
--     { desc = 'Lsp document diagnostics' })
map('n', '<leader>b', function()
    builtin.buffers({
        show_all_buffers = true,
        sort_lastused = true,
        ignore_current_buffer = true,
        sort_mru = true
    })
end, { desc = 'Buffers' })
map('n', '<leader>fv', my_telescope.search_dotfiles,
    { desc = 'Search in dotfiles' })
map('n', '<leader>fF', my_telescope.search_home,
    { desc = 'Search in home' })
map('n', '<leader>fB', my_telescope.browse_home,
    { desc = 'Browse home' })
map('n', '<leader>f/', builtin.search_history,
    { desc = 'Search history' })
map('n', '<leader>f:', builtin.command_history,
    { desc = 'Command history' })
map('n', '<leader>fs', function()
    builtin.grep_string({ search = vim.fn.expand([[<cword>]]) })
end, { desc = 'Grep current string' })
map('n', '<leader>fS', function()
    builtin.grep_string({ search = vim.fn.input('Grep for: ') })
end, { desc = 'Grep string' })
-- map('n', '<leader>fw', telescope.extensions.git_worktree.git_worktrees,
-- { desc = 'Git worktrees' })
-- map('n', '<leader>fW', telescope.extensions.git_worktree.create_git_worktree,
-- { desc = 'Create git worktree' })
map('n', '<leader>fp', function()
    telescope.extensions.project.project { display_type = 'full' }
end, { desc = 'Projects' })
--
map('n', '<localleader>fR', builtin.registers,
    { desc = 'Registers' })
map('n', '<localleader>fm', builtin.marks,
    { desc = 'Marks' })
map('n', '<localleader>fj', builtin.jumplist,
    { desc = 'Jumplint' })
map('n', '<localleader>fx', builtin.commands,
    { desc = 'Commands' })
map('n', '<localleader>fn', my_telescope.find_notes,
    { desc = 'Find notes' })
map('n', '<localleader>fk', builtin.keymaps,
    { desc = 'Keymaps' })

map('n', '<leader>gb', builtin.git_branches,
    { desc = 'Git branches' })
map('n', '<leader>gc', builtin.git_commits,
    { desc = 'Git commits' })
map('n', '<leader>gC', builtin.git_bcommits,
    { desc = 'Git current buffer commits' })
map('n', '<leader>fi', builtin.treesitter,
    { desc = 'Treesitter' })
map('n', '<leader>gw',
    telescope.extensions.git_worktree.git_worktrees,
    { desc = 'Git worktree' })
map('n', '<leader>gW',
    telescope.extensions.git_worktree.create_git_worktree,
    { desc = 'Create worktree' })

local telescope_au = api.nvim_create_augroup('telescope_au', { clear = true })
api.nvim_create_autocmd('FileType', {
    group = telescope_au,
    pattern = 'TelescopePrompt',
    command = 'setlocal nocursorline nonumber norelativenumber signcolumn=no',
})
