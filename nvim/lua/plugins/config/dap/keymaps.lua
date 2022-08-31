-- map('n', '<leader>dct', '<cmd>lua require"dap".continue()<CR>')
-- map('n', '<leader>dsv', '<cmd>lua require"dap".step_over()<CR>')
-- map('n', '<leader>dsi', '<cmd>lua require"dap".step_into()<CR>')
-- map('n', '<leader>dso', '<cmd>lua require"dap".step_out()<CR>')
-- map('n', '<leader>dtb', '<cmd>lua require"dap".toggle_breakpoint()<CR>')
--
-- map('n', '<leader>dsc', '<cmd>lua require"dap.ui.variables".scopes()<CR>')
-- map('n', '<leader>dhh', '<cmd>lua require"dap.ui.variables".hover()<CR>')
-- map('v', '<leader>dhv',
--     '<cmd>lua require"dap.ui.variables".visual_hover()<CR>')
--
-- map('n', '<leader>duh', '<cmd>lua require"dap.ui.widgets".hover()<CR>')
-- map('n', '<leader>duf',
--     "<cmd>lua local widgets=require'dap.ui.widgets';widgets.centered_float(widgets.scopes)<CR>")
--
-- map('n', '<leader>dsbr',
--     '<cmd>lua require"dap".set_breakpoint(vim.fn.input("Breakpoint condition: "))<CR>')
-- map('n', '<leader>dsbm',
--     '<cmd>lua require"dap".set_breakpoint(nil, nil, vim.fn.input("Log point message: "))<CR>')
-- map('n', '<leader>dro', '<cmd>lua require"dap".repl.open()<CR>')
-- map('n', '<leader>drl', '<cmd>lua require"dap".repl.run_last()<CR>')

local M = {}

local which_key = require("which-key")


function M.setup()
    local keymap = {
        d = {
            name = "Debug",
            R = { "<cmd>lua require'dap'.run_to_cursor()<cr>", "Run to Cursor" },
            E = { "<cmd>lua require'dapui'.eval(vim.fn.input '[Expression] > ')<cr>", "Evaluate Input" },
            C = { "<cmd>lua require'dap'.set_breakpoint(vim.fn.input '[Condition] > ')<cr>", "Conditional Breakpoint" },
            U = { "<cmd>lua require'dapui'.toggle()<cr>", "Toggle UI" },
            b = { "<cmd>lua require'dap'.step_back()<cr>", "Step Back" },
            c = { "<cmd>lua require'dap'.continue()<cr>", "Continue" },
            d = { "<cmd>lua require'dap'.disconnect()<cr>", "Disconnect" },
            e = { "<cmd>lua require'dapui'.eval()<cr>", "Evaluate" },
            g = { "<cmd>lua require'dap'.session()<cr>", "Get Session" },
            h = { "<cmd>lua require'dap.ui.widgets'.hover()<cr>", "Hover Variables" },
            S = { "<cmd>lua require'dap.ui.widgets'.scopes()<cr>", "Scopes" },
            i = { "<cmd>lua require'dap'.step_into()<cr>", "Step Into" },
            o = { "<cmd>lua require'dap'.step_over()<cr>", "Step Over" },
            p = { "<cmd>lua require'dap'.pause.toggle()<cr>", "Pause" },
            q = { "<cmd>lua require'dap'.close()<cr>", "Quit" },
            r = { "<cmd>lua require'dap'.repl.toggle()<cr>", "Toggle Repl" },
            s = { "<cmd>lua require'dap'.continue()<cr>", "Start" },
            t = { "<cmd>lua require'dap'.toggle_breakpoint()<cr>", "Toggle Breakpoint" },
            x = { "<cmd>lua require'dap'.terminate()<cr>", "Terminate" },
            u = { "<cmd>lua require'dap'.step_out()<cr>", "Step Out" },
        },
    }

    which_key.register(keymap, {
        mode = "n",
        prefix = "<leader>",
        buffer = nil,
        silent = true,
        noremap = true,
        nowait = false,
    })

    local keymap_v = {
        name = "Debug",
        e = { "<cmd>lua require'dapui'.eval()<cr>", "Evaluate" },
    }
    which_key.register(keymap_v, {
        mode = "v",
        prefix = "<leader>",
        buffer = nil,
        silent = true,
        noremap = true,
        nowait = false,
    })
end

return M
