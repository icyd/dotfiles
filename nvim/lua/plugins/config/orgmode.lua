local orgmode_dir = os.getenv('ORGMODE_HOME')
local orgmode = require('orgmode')

orgmode.setup_ts_grammar()

orgmode.setup({
    org_agenda_files = {
        orgmode_dir .. "/org/**/*",
    },
    org_default_notes_file = orgmode_dir .. '/org/refile.org',
})
