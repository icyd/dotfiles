local g, map = vim.g, require('utils').map

g.dashboard_disable_at_vimenter = 0
g.dashboard_disable_statusline = 1
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
   a = { description = { "  Find File                 SPC f f" }, command = "Telescope find_files" },
   b = { description = { "  Recents                   SPC f r" }, command = "Telescope oldfiles" },
   c = { description = { "  Find Word                 SPC f G" }, command = "Telescope live_grep" },
   d = { description = { "  New File                  \\ f n" }, command = "DashboardNewFile" },
   e = { description = { "  Bookmarks                 \\ f m" }, command = "Telescope marks" },
   f = { description = { "  Load Last Session         \\ f S" }, command = "SessionLoad" },
}

g.dashboard_custom_footer = {
   "   ",
}
