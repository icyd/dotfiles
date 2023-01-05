return {
    'goolord/alpha-nvim',
    event = 'VimEnter',
    config = function()
        local dashboard = require("alpha.themes.dashboard")
        local logo = [[
            ███╗   ██╗ ███████╗ ██████╗  ██╗   ██╗ ██╗ ███╗   ███╗
            ████╗  ██║ ██╔════╝██╔═══██╗ ██║   ██║ ██║ ████╗ ████║
            ██╔██╗ ██║ █████╗  ██║   ██║ ██║   ██║ ██║ ██╔████╔██║
            ██║╚██╗██║ ██╔══╝  ██║   ██║ ╚██╗ ██╔╝ ██║ ██║╚██╔╝██║
            ██║ ╚████║ ███████╗╚██████╔╝  ╚████╔╝  ██║ ██║ ╚═╝ ██║
            ╚═╝  ╚═══╝ ╚══════╝ ╚═════╝    ╚═══╝   ╚═╝ ╚═╝     ╚═╝
        ]]
        dashboard.section.header.val = vim.split(logo, '\n')
        dashboard.section.buttons.val = {
            dashboard.button('p', '  Find Project      SPC f p', '<cmd>Telescope project<CR>'),
            dashboard.button('f', '  Find File         SPC f f', '<cmd>Telescope find_files<CR>'),
            dashboard.button('r', '  Recents           SPC f r', '<cmd>Telescope oldfiles<CR>'),
            dashboard.button('G', '  Find Word         SPC f G', '<cmd>Telescope live_grep<CR>'),
            dashboard.button('t', '  Terminal          SPC \'', '<cmd>terminal<CR>'),
            dashboard.button('n', '  New File          \\ f n', '<cmd>enew <BAR> startinsert<CR>'),
            dashboard.button('l', '鈴 Lazy                    ', '<cmd>Lazy<CR>'),
            dashboard.button('c', '  Config            SPC f v',
                '<cmd>lua require("utils.telescope").seah_dotfiles()<CR>'),
            dashboard.button('m', '  Bookmarks         \\ f m', '<cmd>Telescope marks<CR>'),
            dashboard.button('s', '  Load Session      \\ f S', '<cmd>SessionManager load_session<CR>'),
        }


        -- for _, button in ipairs(dashboard.section.buttons.val) do
        --     button.opts.hl = 'AlphaButtons'
        --     button.opts.hl_shortcut = 'AlphaShortcut'
        -- end
        --
        -- dashboard.section.footer.opts.hl = 'Type'
        -- dashboard.section.header.opts.hl = 'AlphaHeader'
        -- dashboard.section.buttons.opts.hl = 'AlphaButtons'
        -- dashboard.opts.layout[1].val = 8

        local alpha = require("alpha")
        -- close and re-open Lazy after showing alpha
        if vim.o.filetype == 'lazy' then
            vim.cmd.close()
            alpha.setup(dashboard.opts)
            require('lazy').show()
        else
            alpha.setup(dashboard.opts)
        end

        vim.api.nvim_create_autocmd('User', {
            pattern = 'LazyVimStarted',
            callback = function()
                local stats = require('lazy').stats()
                local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
                dashboard.section.footer.val = '⚡ Neovim loaded ' .. stats.count .. ' plugins in ' .. ms .. 'ms'
                pcall(vim.cmd.AlphaRedraw)
            end,
        })
    end,
}
