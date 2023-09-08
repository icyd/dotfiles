local M = {}

function M.setup()

    local dap = require('dap')
    local mason_root_dir = vim.fn.stdpath('data') .. '/mason'
    local extension_path = mason_root_dir .. "/packages/node-debug2-adapter"

    dap.adapters.node2 = {
        type = "executable",
        command = "node",
        args = {extension_path .. "/out/src/nodeDebug.js"},
    }

    local common_config = {
            name = 'Launch',
            type = 'node2',
            request = 'launch',
            program = '${file}',
            cwd = vim.fn.getcwd(),
            sourceMaps = true,
            protocol = 'inspector',
            console = 'integratedTerminal',
    }

    dap.configurations.javascript = {
        {
            name = "Jest current file",
            type = "node2",
            request = "launch",
            program = "${workspaceFolder}/node_modules/.bin/jest",
            args = {
                "${fileBasenameNoExtension}",
                "--config",
                "jest.config.js"
            },
            cwd = "${workspaceFolder}",
            console = "integratedTerminal",
            internalConsoleOptions = "neverOpen",
            disableOptimisticBPs = true,
        },
        {
            name = "Jest integration config current file",
            type = "node2",
            request = "launch",
            program = "${workspaceFolder}/node_modules/.bin/jest",
            args = {
                "${fileBasenameNoExtension}",
                "--config",
                "jest-integration.config.js"
            },
            cwd = "${workspaceFolder}",
            console = "integratedTerminal",
            internalConsoleOptions = "neverOpen",
            disableOptimisticBPs = true,
        },
    }

    dap.configurations.typescript = {
        {
            name = "Jest current file",
            type = "node2",
            request = "launch",
            program = "${workspaceFolder}/node_modules/.bin/jest",
            args = {
                "${fileBasenameNoExtension}",
                "--config",
                "jest.config.ts"
            },
            cwd = "${workspaceFolder}",
            console = "integratedTerminal",
            internalConsoleOptions = "neverOpen",
            disableOptimisticBPs = true,
        },
        {
            name = "Jest integration config current file",
            type = "node2",
            request = "launch",
            program = "${workspaceFolder}/node_modules/.bin/jest",
            args = {
                "${fileBasenameNoExtension}",
                "--config",
                "jest-integration.config.ts"
            },
            cwd = "${workspaceFolder}",
            console = "integratedTerminal",
            internalConsoleOptions = "neverOpen",
            disableOptimisticBPs = true,
        },
    }

    table.insert(dap.configurations.javascript, common_config)
    table.insert(dap.configurations.typescript, common_config)
end

return M
