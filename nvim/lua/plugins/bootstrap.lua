local M = {}
local fn = vim.fn

function M.setup()
    local install_path = vim.fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
    local bootstrap = false

    if fn.empty(fn.glob(install_path)) > 0 then
        bootstrap = true
        print "Bootstrapping packer"
        vim.fn.system({
            'git',
            'clone',
            '--depth',
            '1',
            'https://github.com/wbthomason/packer.nvim',
            install_path
        })
        vim.cmd[[packadd packer.nvim]]
    end

    local ok, packer = pcall(require, 'packer')

    if not ok then
        error("Couldn't bootstrap packer! \nPath: " .. install_path)
    end

    if bootstrap then print("Packer bootstrap completed") end

    local packer_au = vim.api.nvim_create_augroup('packer_au', { clear = true })
    vim.api.nvim_create_autocmd('BufWritePost', {
        pattern = '$MYVIMRC',
        group = packer_au,
        command = 'source $MYVIMRC | PackerCompile',
    })

    return bootstrap, packer
end

return M
