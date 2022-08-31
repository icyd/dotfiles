local M = {}


function M.reload()
    local function get_module_name(file_name)
        local module_name;
        local config_dir = vim.fn.stdpath('config') .. '/lua/'
        local dotfiles_dir = os.getenv('DOTFILES') .. '/nvim/lua/'

        if string.match(file_name, 'lua/[^/]+/init.lua') then
            module_name = file_name:gsub('/init.lua', '')
        else
            module_name = file_name:gsub("%.lua", "")
        end

        if string.match(file_name, config_dir) then
            module_name = module_name:gsub(config_dir, "")
        elseif string.match(file_name, dotfiles_dir) then
            module_name = module_name:gsub(dotfiles_dir, "")
        else
            return nil
        end

        return module_name
    end

    local path = vim.api.nvim_buf_get_name(0)
    local name = get_module_name(path)
    if name == "" or name == nil then
        return
    end

    require('plenary').reload.reload_module(name)
    -- require('packer').compile()
    print(vim.inspect(name .. " RELOADED!!!"))
end

function M.grab_server()
    if string.len(vim.api.nvim_get_vvar('servername')) > 1 then
        print("Setting servername to this nvim")
        local server = io.open('/tmp/nvim-server', 'w')
        server:write(vim.api.nvim_get_vvar('servername'))
        server:close()
    end
end

local function string_product(keys)
    if #keys == 1 then
        return keys[1]
    end
    local keys_copy = {}
    for _, key in ipairs(keys) do
        table.insert(keys_copy, key)
    end
    local product = {}
    local first = table.remove(keys_copy, 1)
    for _, a in ipairs(first) do
        if type(a) ~= 'string' then
            vim.cmd('echoerr "Not a valid keys table"')
        end
        for _, b in ipairs(string_product(keys_copy)) do
            table.insert(product, a .. b)
        end
    end
    return product
end

local function expand_keys(keys)
    if type(keys) == 'string' then
        return {keys}
    elseif type(keys[1]) == 'string' then
        return keys
    else
        return string_product(keys)
    end
end

function M.get_keys(modes, keys)
    if type(modes) == 'string' then
        modes = {modes}
    end
    local combinations = {}
    for _, mode in ipairs(modes) do
        for _, v in ipairs(expand_keys(keys)) do
            table.insert(combinations, {mode, v})
        end
    end
    return combinations
end

function M.P(v)
    print(vim.inspect(v))
    return(v)
end

if pcall(require, "plenary") then
    local reload = require("plenary.reload").reload_module

    function M.RELOAD(name)
        reload(name)
        return require(name)
    end
end

return M
