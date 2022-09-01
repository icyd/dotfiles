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

local map = vim.keymap.set


function M.setup()
    map('n', '<leader>dR', require('dap').run_to_cursor, { desc = 'Run to cursor' })
    map('n', '<leader>dE', function()
        require('dapui').eval(vim.fn.input '[Expression] > ')
    end, { desc = 'Evaluate input' })
    map('n', '<leader>dC', function()
        require('dap').set_breakpoint(vim.fn.input '[Condition] > ')
    end, { desc = 'Conditional breakpoint' })
    map('n', '<leader>dU', require('dapui').toggle, { desc = 'Toggle ui' })
    map('n', '<leader>db', require('dap').step_back, { desc = 'Step back' })
    map('n', '<leader>dc', require('dap').continue, { desc = 'Continue' })
    map('n', '<leader>dd', require('dap').disconnect, { desc = 'Disconnect' })
    map('n', '<leader>de', require('dapui').eval, { desc = 'Evaluate' })
    map('n', '<leader>dg', require('dap').session, { desc = 'Get session' })
    map('n', '<leader>dh', require('dap.ui.widgets').hover, { desc = 'Hover variable' })
    map('n', '<leader>dS', require('dap.ui.widgets').scopes, { desc = 'Scopes' })
    map('n', '<leader>di', require('dap').step_into, { desc = 'Step into' })
    map('n', '<leader>do', require('dap').step_over, { desc = 'Step ove' })
    map('n', '<leader>dp', require('dap').pause.toggle, { desc = 'Pause' })
    map('n', '<leader>dq', require('dap').close, { desc = 'Quit' })
    map('n', '<leader>dr', require('dap').repl.toggle, { desc = 'Toggle Repl' })
    map('n', '<leader>ds', require('dap').continue, { desc = 'Start' })
    map('n', '<leader>dt', require('dap').toggle_breakpoint, { desc = 'Toggle breakpoint' })
    map('n', '<leader>dx', require('dap').terminate, { desc = 'Terminate' })
end

return M
