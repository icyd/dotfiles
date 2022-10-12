local M = {}
local nls = require('null-ls')
local builtins = nls.builtins

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
            -- builtins.formatting.black,
            -- builtins.formatting.isort,
            -- builtins.formatting.gofmt,
            -- builtins.formatting.rustfmt,
            builtins.formatting.terraform_fmt,
        }
    })
end

return M
