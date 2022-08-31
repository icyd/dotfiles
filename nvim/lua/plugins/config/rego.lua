local M = {}

function M.setup()
    vim.g.neoformat_rego_opa = {
          exe = 'opa',
          args = {'fmt'},
          stdin = 1,
    }
    vim.g.neoformat_enabled_rego = { 'opa' }

    local rego_fmt = vim.api.nvim_create_augroup('rego_fmt', { clear = true })
    vim.api.nvim_create_autocmd('BufWritePre', {
        pattern = '*.rego',
	group = rego_fmt,
        command = 'undojoin | Neoformat',
    })
end

return M
