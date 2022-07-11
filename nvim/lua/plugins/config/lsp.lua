local servers = {
  "bashls",
  "clangd",
  -- "dotls",
  "dockerls",
  "gopls",
  -- "graphql",
  "jdtls",
  "jsonls",
  "pylsp",
  "rust_analyzer",
  -- "solargraph",
  "sumneko_lua",
  "terraformls",
  -- "vimls",
  "yamlls",
}

require('nvim-lsp-installer').setup({
    automatic_installation = false,
})

for _, name in pairs(servers) do
    if name == "yamlls" then
        require('lspconfig')[name].setup({
            on_attach = function(client, bufnr)
                if vim.bo[bufnr].buftype ~= "" or vim.bo[bufnr].filetype == "helm" then
                    vim.diagnostic.disable(bufnr)
                    vim.defer_fn(function()
                        vim.diagnostic.reset(nil, bufnr)
                    end, 1000)
                end
            end,
        })
    else
        require('lspconfig')[name].setup({})
    end
end

-- lsp_installer.on_server_ready(function(server)
--     local opts = {}
--
--     if server.name == "rust_analyzer" then
--         -- Initialize the LSP via rust-tools instead
--         require("rust-tools").setup {
--             -- The "server" property provided in rust-tools setup function are the
--             -- settings rust-tools will provide to lspconfig during init.            --
--             -- We merge the necessary settings from nvim-lsp-installer (server:get_default_options())
--             -- with the user's own settings (opts).
--             server = vim.tbl_deep_extend("force", server:get_default_options(), opts),
--         }
--         server:attach_buffers()
--     else
--         server:setup(opts)
--     end
-- end)

local nvim_lsp = require('lspconfig')
local map = require('utils').map

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
