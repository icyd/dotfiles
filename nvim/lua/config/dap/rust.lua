local M = {}

function M.setup()

    local dap = require "dap"
    local nix_codelldb = '/nix/store/v0x5l0r5jkh4ljzbi05j4v30ky7nqmg0-vscode-extension-vadimcn-vscode-lldb-1.6.10/share/vscode'
    -- local install_root_dir = vim.fn.stdpath "data" .. "/mason"
    -- local extension_path = nix_codelldb .. "/packages/codelldb/extension/"
    local extension_path = nix_codelldb .. '/extensions/vadimcn.vscode-lldb/'
    local codelldb_path = extension_path .. 'adapter/codelldb'

    dap.adapters.codelldb = {
        type = "server",
        port = "${port}",
        executable = {
            command = codelldb_path,
            args = { "--port", "${port}" },
        },
    }
    dap.configurations.cpp = {
        {
            name = "Launch file",
            type = "codelldb",
            request = "launch",
            program = function()
                return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
            end,
            cwd = "${workspaceFolder}",
            stopOnEntry = true,
        },
        {
            name = "Remote attach",
            type = "codelldb",
            request = "custom",
            targetCreateCommands = function()
                local input = vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
                return { "target create " .. input }
            end,
            processCreateCommands = function()
                local host = vim.fn.input("Host [127.0.0.1]: ", "127.0.0.1")
                local port = vim.fn.input("Port [3333]: ", "3333")
                return { string.format("gdb remote %s:%s", host, port) }
            end,
            cwd = "${workspaceFolder}",
            stopOnEntry = true,
        },
    }

    dap.configurations.c = dap.configurations.cpp
    dap.configurations.rust = dap.configurations.cpp
end

return M
