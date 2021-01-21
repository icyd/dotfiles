local nvim_lsp = require('lspconfig')
local servers = os.getenv("XDG_DATA_HOME") .. "/vim-lsp-settings/servers/"
nvim_lsp.bashls.setup{
    cmd = { servers .. "bash-language-server/bash-language-server", "start" }
}
nvim_lsp.ccls.setup{}
nvim_lsp.cssls.setup{
    cmd = { servers .. "css-languageserver/css-languageserver", "--stdio" }
}
nvim_lsp.dockerls.setup{
    cmd = { servers .. "docker-langserver/docker-langserver", "--stdio" }
}
nvim_lsp.gopls.setup{
    cmd = { servers .. "gopls/gopls" }
}
nvim_lsp.html.setup{
    cmd = { servers .. "html-languageserver/html-languageserver", "--stdio" }
}
nvim_lsp.sumneko_lua.setup{
    cmd = { servers .. "sumneko-lua-language-server/sumneko-lua-language-server" }
}
nvim_lsp.jsonls.setup{
    cmd = { servers .. "json-languageserver/vscode-json-languageserver"
, "--stdio" }
}
nvim_lsp.pyls.setup{
    cmd = { servers .. "pyls-all/pyls-all" }
}
nvim_lsp.rust_analyzer.setup{
    cmd = { servers .. "rust-analyzer/rust-analyzer" }
}
nvim_lsp.terraformls.setup{
    cmd = { servers .. "terraform-ls/terraform-ls", "serve" }
}
nvim_lsp.tsserver.setup{
    cmd = { servers .. "typescript-language-server/typescript-language-server" , "--stdio" }
}
nvim_lsp.vimls.setup{
    cmd = { servers .. "vim-language-server/vim-language-server" , "--stdio" }
}
nvim_lsp.yamlls.setup{
    cmd = { servers .. "yaml-language-server/yaml-language-server", "--stdio" }
}
