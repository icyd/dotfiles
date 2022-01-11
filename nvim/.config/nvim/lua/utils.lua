local utils = {}

local scopes = {o = vim.o, b = vim.bo, w = vim.wo, g = vim.g}

function utils.opt(scope, key, value)
    scopes[scope][key] = value
    if scope ~= 'o' then scopes['o'][key] = value end
end

function utils.map(mode, lhs, rhs, opts)
    local options = {noremap = true; silent = true}
    if opts then options = vim.tbl_extend('force', options, opts) end
    vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

function utils.augroup(name, definitions)
    vim.cmd('augroup '..name..' | autocmd!')
    vim.tbl_map(function(c) vim.cmd('autocmd '..c) end, definitions)
    vim.cmd'augroup END'
end

function utils.reload()
  local function get_module_name(s)
    local module_name;
    local dir = os.getenv("DOTFILES") .. "/nvim/.config/nvim/lua/"

    module_name = s:gsub("%.lua", "")
    module_name = module_name:gsub(dir, "")

    return module_name
  end

  local path = vim.api.nvim_buf_get_name(0)
  local name = get_module_name(path)
  --
  require('plenary.reload').reload_module(name)
  require(name)
  print(vim.inspect(name .. " RELOADED!!!"))
end


function utils.grab_server()
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

function utils.get_keys(modes, keys)
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

return utils
