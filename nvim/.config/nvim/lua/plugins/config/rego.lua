vim.g.neoformat_rego_opa = {
      exe = 'opa',
      args = {'fmt'},
      stdin = 1,
}
vim.g.neoformat_enabled_rego = {'opa'}

require('utils').augroup('rego_fmt', {
    'BufWritePre *.rego undojoin | Neoformat'
})
