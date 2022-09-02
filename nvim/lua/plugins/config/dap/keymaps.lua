local M = {}

local map = vim.keymap.set
local widgets = require('dap.ui.widgets')

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
    map('n', '<leader>dS', widgets.sidebar(widgets.scopes).open, { desc = 'Scopes' })
    map('n', '<leader>dF', widgets.sidebar(widgets.frames).open, { desc = 'Frames' })
    map('n', '<leader>dE', widgets.sidebar(widgets.expression).open, { desc = 'Expression' })
    map('n', '<leader>dT', widgets.sidebar(widgets.threads).open, { desc = 'Threads' })
    map('n', '<leader>di', require('dap').step_into, { desc = 'Step into' })
    map('n', '<leader>do', require('dap').step_over, { desc = 'Step over' })
    map('n', '<leader>dp', require('dap').pause, { desc = 'Pause' })
    map('n', '<leader>dq', require('dap').close, { desc = 'Quit' })
    map('n', '<leader>dr', require('dap').repl.toggle, { desc = 'Toggle Repl' })
    map('n', '<leader>ds', require('dap').continue, { desc = 'Start' })
    map('n', '<leader>dt', require('dap').toggle_breakpoint, { desc = 'Toggle breakpoint' })
    map('n', '<leader>dx', require('dap').terminate, { desc = 'Terminate' })
    map('n', '<leader>du', require('dap').step_out, { desc = 'Step out' })
end

return M
