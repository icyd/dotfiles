local M = {}
local nls = require('null-ls')
local builtins = nls.builtins

local lsp_formatting = function(bufnr)
    vim.lsp.buf.format({
        filter = function(client)
            return client.name == 'null-ls'
        end,
        bufnr = bufnr,
    })
end

local nls_au = vim.api.nvim_create_augroup("LspFormatting", {})
local on_attach = function(client, bufnr)
    if client.supports_method('textDocument/formatting') then
        vim.api.nvim_clear_autocmds({ group = nls_au, buffer = bufnr })
        vim.api.nvim_create_autocmd('BufWritePre', {
            group = nls_au,
            buffer = bufnr,
            callback = function()
                -- lsp_formatting(bufnr)
                vim.lsp.buf.format({ bufnr = bufnr })
            end,
        })
    end
end

function M.setup()
    nls.setup({
        sources = {
            builtins.code_actions.eslint_d,
            -- builtins.code_actions.gitsigns,
            builtins.code_actions.shellcheck,

            builtins.diagnostics.commitlint.with({
                filetypes = { 'gitcommit', 'NeogitCommitMessage' },
                extra_args = { '--config', vim.fn.expand('~/.commitlintrc.js')}
            }),
            builtins.diagnostics.eslint_d,
            -- builtins.diagnostics.pylint,
            -- builtins.diagnostics.mypy,
            -- builtins.diagnostics.golangci_lint,
            -- builtins.diagnostics.jsonlint,
            -- builtins.diagnostics.luacheck,
            builtins.diagnostics.shellcheck,
            -- builtins.diagnostics.yamllint,

            builtins.formatting.eslint_d,
            builtins.formatting.clang_format,
            -- builtins.formatting.black,
            -- builtins.formatting.isort,
            builtins.formatting.gofmt,
            builtins.formatting.rustfmt,
            builtins.formatting.terraform_fmt,
        },
        on_attach = on_attach,
    })
end

return M
