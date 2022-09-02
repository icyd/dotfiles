local M = {}

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
    require('plugins.config.dap.lua').setup()
    require('plugins.config.dap.python').setup()
    require('plugins.config.dap.go').setup()
    require('plugins.config.dap.rust').setup()
end

function M.setup()
    configure() -- Configuration
    configure_exts() -- Extensions
    configure_debuggers() -- Debugger
    require('plugins.config.dap.keymaps').setup() -- Keymaps
end

return M
