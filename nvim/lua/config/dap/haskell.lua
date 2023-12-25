local M = {}

function M.setup()
    local dap = require("dap")
    dap.adapters.haskell = {
        type = "executable",
        command = "haskell-debug-adapter",
        args = {},
    }

    dap.configurations.haskell = {
        {
            type = "haskell",
            request = "launch",
            name = "Debug",
            workspace = "${workspaceFolder}",
            startup = "${file}",
            stopOnEntry = true,
            logFile = vim.fn.stdpath('data') .. '/haskell-dap.log',
            logLevel = 'WARNING',
            ghciEnv = vim.empty_dict(),
            ghciPrompt = "ghci> ",
            ghciInitialPrompt = "ghci> ",
            ghciCmd = "ghci-dap --interactive -i -i${workspaceFolder}",
        },
    }
end

return M
