local M = {
    'mfussenegger/nvim-dap',
    keys = {
        { '<leader>dR', function()
                require('dap').run_to_cursor()
            end, desc = 'Run to cursor' },
        { '<leader>dE', function()
                require('dapui').eval(vim.fn.input '[Expression] > ')
            end, desc = 'Evaluate input' },
        { '<leader>dC', function()
                require('dap').set_breakpoint(vim.fn.input '[Condition] > ')
            end, desc = 'Conditional breakpoint' },
        { '<leader>dU', function()
                require('dapui').toggle()
            end, desc = 'Toggle ui' },
        { '<leader>db', function()
                require('dap').step_back()
            end, desc = 'Step back' },
        { '<leader>dc', function()
                require('dap').continue()
            end, desc = 'Continue' },
        { '<leader>dd', function()
                require('dap').disconnect()
            end, desc = 'Disconnect' },
        { '<leader>de', function()
                require('dapui').eval()
            end, desc = 'Evaluate' },
        { '<leader>dg', function()
                require('dap').session()
            end, desc = 'Get session' },
        { '<leader>dh', function()
                require('dap.ui.widgets').hover()
            end, desc = 'Hover variable' },
        { '<leader>dS', function()
                local widgets = require('dap.ui.widgets')
                widgets.sidebar(widgets.scopes).open()
            end, desc = 'Scopes' },
        { '<leader>dF', function()
                local widgets = require('dap.ui.widgets')
                widgets.sidebar(widgets.frames).open()
            end, desc = 'Frames' },
        { '<leader>dE', function()
                local widgets = require('dap.ui.widgets')
                widgets.sidebar(widgets.expression).open()
            end, desc = 'Expression' },
        { '<leader>dT', function()
                local widgets = require('dap.ui.widgets')
                widgets.sidebar(widgets.threads).open()
            end, desc = 'Threads' },
        { '<leader>di', function()
                require('dap').step_into()
            end, desc = 'Step into' },
        { '<leader>do', function()
                require('dap').step_over()
            end, desc = 'Step over' },
        { '<leader>dp', function()
                require('dap').pause()
            end, desc = 'Pause' },
        { '<leader>dq', function()
                require('dap').close()
            end, desc = 'Quit' },
        { '<leader>dr', function()
                require('dap').repl.toggle()
            end, desc = 'Toggle Repl' },
        { '<leader>ds', function()
                require('dap').continue()
            end, desc = 'Start' },
        { '<leader>dt', function()
                require('dap').toggle_breakpoint()
            end, desc = 'Toggle breakpoint' },
        { '<leader>dx', function()
                require('dap').terminate()
            end, desc = 'Terminate' },
        { '<leader>du', function()
                require('dap').step_out()
            end, desc = 'Step out' },
    },
    dependencies = {
        { 'theHamsta/nvim-dap-virtual-text' },
        { 'rcarriga/nvim-dap-ui' },
        { 'mfussenegger/nvim-dap-python' },
        { 'leoluz/nvim-dap-go', },
        { 'jbyuki/one-small-step-for-vimkind', },
    },
}

local function configure()
    local dap_breakpoints = {
        error = {
            text = "",
            texthl = "LspDiagnosticsSignError",
            linehl = "",
            numhl = "",
        },
        rejected = {
            text = "",
            texthl = "LspDiagnosticsSignHint",
            linehl = "",
            numhl = "",
        },
        stopped = {
            text = "",
            texthl = "LspDiagnosticsSignInformation",
            linehl = "DiagnosticUnderlineInfo",
            numhl = "LspDiagnosticsSignInformation",
        },
    }

    vim.fn.sign_define("DapBreakpoint", dap_breakpoints.error)
    vim.fn.sign_define("DapStopped", dap_breakpoints.stopped)
    vim.fn.sign_define("DapBreakpointRejected", dap_breakpoints.rejected)
end

local function configure_exts()
    require("nvim-dap-virtual-text").setup {
        commented = true,
    }

    local dap, dapui = require('dap'), require('dapui')
    dapui.setup() -- use default

    dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
    end
    dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
    end
    dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
    end
end

local function configure_debuggers()
    require('config.dap.lua').setup()
    require('config.dap.python').setup()
    require('config.dap.go').setup()
    require('config.dap.rust').setup()
    require('config.dap.javascript').setup()
end

function M.config()
    configure() -- Configuration
    configure_exts() -- Extensions
    configure_debuggers() -- Debugger
end

return M
