local nvim_lsp = require('lspconfig')
local ncm2 = require('ncm2')
nvim_lsp.bashls.setup{on_init = ncm2.register_lsp_source}
nvim_lsp.ccls.setup{on_init = ncm2.register_lsp_source}
nvim_lsp.cssls.setup{on_init = ncm2.register_lsp_source}
nvim_lsp.dockerls.setup{on_init = ncm2.register_lsp_source}
nvim_lsp.gopls.setup{on_init = ncm2.register_lsp_source}
nvim_lsp.html.setup{on_init = ncm2.register_lsp_source}
nvim_lsp.jsonls.setup{on_init = ncm2.register_lsp_source}
nvim_lsp.pyls.setup{on_init = ncm2.register_lsp_source}
nvim_lsp.rust_analyzer.setup{on_init = ncm2.register_lsp_source}
nvim_lsp.terraformls.setup{on_init = ncm2.register_lsp_source}
nvim_lsp.tsserver.setup{on_init = ncm2.register_lsp_source}
nvim_lsp.yamlls.setup{on_init = ncm2.register_lsp_source}
