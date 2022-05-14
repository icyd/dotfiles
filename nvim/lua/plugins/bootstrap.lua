vim.cmd "packadd packer.nvim"
local ok, packer = pcall(require, "packer")

if not ok then
    local install_path = vim.fn.stdpath('data')..'/site/pack/packer/opt/packer.nvim'

    print "Bootstrapping packer"
    vim.fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})

    vim.cmd "packadd packer.nvim"
    ok, packer = pcall(require, "packer")

    if ok then
        print("Packer bootstrap completed")
    else
        error("Couldn't bootstrap packer! \nPath: " .. install_path)
    end
end

packer.init {
    compile_path = vim.fn.stdpath('data')..'/site/pack/loader/start/packer.nvim/plugin/packer_compiled.lua',
    compile_on_sync = true,
    profile = {
        enable = false,
        threshold = 1
    },
    git = {
        clone_timeout = 120,
    },
    display = {
        open_fn = function()
            return require('packer.util').float({ border = 'single' })
        end,
    }
}

return packer
