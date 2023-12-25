local M = {}

local function get_host()
    local value = vim.fn.input "Host [127.0.0.1]: "
    if value ~= "" then
        return value
    end
    return "127.0.0.1"
end

local function get_port()
    local val = tonumber(vim.fn.input("Port: ", "8086"))
    assert(val, "Please provide a port number")
    return val
end

function M.setup()
    local dap = require("dap")
    dap.configurations.lua = {
        {
            type = "nlua",
            request = "attach",
            name = "Attach to running Neovim instance",
        },
    }

    dap.adapters.nlua = function(callback, config)
        callback({
            type = "server",
            host = config.host or get_host(),
            port = config.port or get_port(),
        })
    end

    local daplua_augroup = vim.api.nvim_create_augroup("DapLuaGroup", {clear = true})
    vim.api.nvim_create_autocmd("FileType", {
        pattern = "lua",
        group = daplua_augroup,
        callback = function()
            vim.keymap.set('n', '<leader>da',
                function() require("osv").run_this() end,
            { noremap = true, desc = "OSV run_this", buffer = true })
            vim.keymap.set('n', '<leader>dA',
                function() require("osv").launch({port = get_port()}) end,
            { noremap = true, desc = "Run OSV server", buffer = true })
        end,
    })
end

return M
