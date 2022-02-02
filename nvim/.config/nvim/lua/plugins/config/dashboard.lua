local utils = require('utils')
local g, map, augroup = vim.g, utils.map, utils.augroup

g.dashboard_disable_at_vimenter = 0
g.dashboard_default_executive = "telescope"
g.dashboard_custom_header = {
   ' ███╗   ██╗ ███████╗ ██████╗  ██╗   ██╗ ██╗ ███╗   ███╗',
   ' ████╗  ██║ ██╔════╝██╔═══██╗ ██║   ██║ ██║ ████╗ ████║',
   ' ██╔██╗ ██║ █████╗  ██║   ██║ ██║   ██║ ██║ ██╔████╔██║',
   ' ██║╚██╗██║ ██╔══╝  ██║   ██║ ╚██╗ ██╔╝ ██║ ██║╚██╔╝██║',
   ' ██║ ╚████║ ███████╗╚██████╔╝  ╚████╔╝  ██║ ██║ ╚═╝ ██║',
   ' ╚═╝  ╚═══╝ ╚══════╝ ╚═════╝    ╚═══╝   ╚═╝ ╚═╝     ╚═╝',
}
map('n', '<localleader>fn', ":DashboardNewFile<CR>")
map('n', '<localleader>fS', ":SessionLoad<CR>")
map('n', '<localleader>fs', ":SessionSave<CR>")

g.dashboard_custom_section = {
   a = { description = { "  Find Project              SPC f p" }, command = "Telescope project" },
   b = { description = { "  Find File                 SPC f f" }, command = "Telescope find_files" },
   c = { description = { "  Recents                   SPC f r" }, command = "Telescope oldfiles" },
   d = { description = { "  Find Word                 SPC f G" }, command = "Telescope live_grep" },
   e = { description = { "  Terminal                  SPC '" }, command = "terminal" },
   f = { description = { "  New File                  \\ f n" }, command = "DashboardNewFile" },
   g = { description = { "  Bookmarks                 \\ f m" }, command = "Telescope marks" },
   h = { description = { "  Load Last Session         \\ f S" }, command = "SessionLoad" },
}

g.dashboard_custom_footer = {
   "   ",
}
