local orgmode_dir = os.getenv('ORGMODE_HOME')
if orgmode_dir == nil or orgmode_dir == '' then
    orgmode_dir = os.getenv('HOME') .. '/.org'
end

local orgmode = require('orgmode')

orgmode.setup_ts_grammar()

orgmode.setup({
    org_agenda_files = {
        orgmode_dir .. '/org/**/*',
    },
    org_default_notes_file = orgmode_dir .. '/org/refile.org',
    -- org_capture_templates = {
    --     t = {
    --         description = 'Todo',
    --         template = '* TODO %?\n %u',
    --         target = orgmode_dir .. '/org/refile.org',
    --     },
    --     l = {
    --         description = 'Ledger entry',
    --         template = '\n%<%m-%d> %^{Description}\n    %?',
    --         target = string.format(orgmode_dir .. '/ledger/journals/%s.ledger', vim.fn.strftime('%Y-%m')),
    --         filetype = 'ledger',
    --     }
    -- },
})

vim.keymap.set('n', '<leader>ww', function() vim.cmd('e ' .. orgmode_dir .. '/org/orgwiki/Index.org') end, { desc = 'Open orgwiki index' })

pcall(require, 'org-capture-filetype')
