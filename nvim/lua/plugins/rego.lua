return {
    'tsandall/vim-rego',
    dependencies = { 'sbdchd/neoformat' },
    ft = 'rego',
    config = function()
        vim.g.neoformat_rego_opa = {
            exe = 'opa',
            args = { 'fmt' },
            stdin = 1,
        }
        vim.g.neoformat_enabled_rego = { 'opa' }

        vim.api.nvim_create_autocmd('BufWritePre', {
            pattern = '*.rego',
            group = vim.api.nvim_create_augroup('rego_fmt', { clear = true }),
            command = 'undojoin | Neoformat',
        })
    end,
}
