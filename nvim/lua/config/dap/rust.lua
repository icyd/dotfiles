local M = {}

function M.setup()
    local dap = require "dap"
local install_root_dir = os.getenv("HOME") .. "/.nix-profile/share/vscode/extensions/vadimcn.vscode-lldb/"
local codelldb_path = install_root_dir .. 'adapter/codelldb'

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
