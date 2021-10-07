local map = require('utils').map
require('diagnostics')

-- Bindings
map('n', '<leader>ld', '<cmd>lua vim.lsp.buf.definition()<CR>')
map('n', '<leader>lk', '<cmd>lua vim.lsp.buf.declaration()<CR>')
map('n', '<leader>lf', '<cmd>lua vim.lsp.buf.references()<CR>')
map('n', '<leader>lt', '<cmd>lua vim.lsp.buf.type_definition()<CR>')
map('n', '<leader>li', '<cmd>lua vim.lsp.buf.implementation()<CR>')
map('n', '<leader>ls', '<cmd>lua vim.lsp.buf.signature_help()<CR>')
map('n', '<leader>lh', '<cmd>lua vim.lsp.buf.hover()<CR>')
map('n', '<leader>lr', '<cmd>lua vim.lsp.buf.rename()<CR>')
map('n', '<leader>la', '<cmd>lua vim.lsp.buf.code_action()<CR>')
map('n', '<leader>lW', '<cmd>lua vim.lsp.buf.workspace_symbol()<CR>')
map('n', '<leader>lD', '<cmd>lua vim.lsp.buf.document_symbol()<CR>')
map('n', '<leader>lg', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>')
map('n', '<leader>lq', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>')
map('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>')
map('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>')
map('n', '<leader>lq', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>')

local lspinstall = require('lspinstall')
local nvim_lsp = require('lspconfig')

local function setup_servers()
    lspinstall.setup()
    local servers = lspinstall.installed_servers()
    for _, server in pairs(servers) do
        nvim_lsp[server].setup{
            capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
        }
    end
end

setup_servers()
lspinstall.post_install_hook = function()
    setup_servers()
    vim.cmd("bufdo e")
end
