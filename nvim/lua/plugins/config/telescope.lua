local telescope = require('telescope')
local builtin = require('telescope.builtin')
local my_telescope = require('my.telescope')
local api, map = vim.api, vim.keymap.set

local extensions = {}
if pcall(require, 'aerial') then
    telescope.load_extension('aerial')
    extensions['aerial'] = {
        show_nesting = {
            ['_'] = false, -- This key will be the default
            json = true,   -- You can set the option for specific filetypes
            yaml = true,
        }
    }
end

pcall(telescope.load_extension, 'notify')

if pcall(require, 'harpoon') then
    telescope.load_extension('harpoon')

    local function harpoon_goto()
        if (vim.v.count > 0) then
            return require('harpoon.ui').nav_file(vim.v.count)
        end

        return require('harpoon.ui').nav_next()
    end

    map('n', '<leader>hu', require('harpoon.ui').toggle_quick_menu, { desc = 'Harpoon quick menu' })
    map('n', '<leader>hU', require('telescope').extensions.harpoon.marks, { desc = 'Harpoon telescope menu' })
    map('n', '<leader>hm', require('harpoon.mark').add_file, { desc = 'Harpoon add mark' })
    map('n', '<leader>hg', harpoon_goto, { desc = 'Harpoon go to file' })
    map('n', '<leader>ht', function() require('harpoon.term').gotoTerminal(vim.v.count1) end, { desc = 'Harpoon go to terminal' })
end

local gwt_ok = pcall(require, 'git-worktree')
if gwt_ok then
    telescope.load_extension('git_worktree')
    map('n', '<leader>gw',
        telescope.extensions.git_worktree.git_worktrees,
        { desc = 'Git worktree' })
    map('n', '<leader>gW',
        telescope.extensions.git_worktree.create_git_worktree,
        { desc = 'Create worktree' })
end

if pcall(require, 'telescope._extensions.fzf') then
    telescope.load_extension('fzf')
    extensions['fzf'] = {
        fuzzy = true,
        override_generic_sorter = true,
        override_file_sorter = true,
        case_mode = 'smart_case',
    }
end

if pcall(require, 'telescope._extensions.project') then
    telescope.load_extension('project')
    map('n', '<leader>fp', function()
        telescope.extensions.project.project { display_type = 'full' }
    end, { desc = 'Projects' })
    extensions['project'] = {
        base_dirs = {
            { path = '~/Projects', max_depth = 5 },
        },
        hidden_files = false
    }
end

if pcall(require, 'telescope._extensions.file_browser') then
    telescope.load_extension('file_browser')
    map('n', '<leader>fb', function()
        telescope.extensions.file_browser.file_browser()
    end, { desc = 'Browse files' })
    extensions['file_browser'] = {
        hijack_netrw = true,
    }
end

if pcall(require, 'telescope._extensions.dap') then
 telescope.load_extension('dap')
end

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
    extensions = extensions,
}

map('n', '<leader>ff', builtin.find_files, { desc = 'Find files' })
map('n', '<leader>fl',
    function() builtin.find_files({ cwd = vim.fn.expand('%:p:h') }) end,
    { desc = 'Find files relative current file' })
map('n', '<leader>fg', builtin.current_buffer_fuzzy_find,
    { desc = 'Find in current buffer' })
map('n', '<leader>fG', builtin.live_grep,
    { desc = 'Live grep' })
map('n', '<leader>fh', builtin.help_tags,
    { desc = 'Help tags' })
map('n', '<leader>fR', builtin.oldfiles,
    { desc = 'Oldfiles' })
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

local telescope_au = api.nvim_create_augroup('telescope_au', { clear = true })
api.nvim_create_autocmd('FileType', {
    group = telescope_au,
    pattern = 'TelescopePrompt',
    command = 'setlocal nocursorline nonumber norelativenumber signcolumn=no',
})
