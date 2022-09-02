local M = {}
local nls = require('null-ls')
local builtins = nls.builtins

function M.setup()
    nls.setup({
        sources = {
            builtins.code_actions.gitsigns,
            builtins.code_actions.shellcheck,

            -- builtins.diagnostics.commitlint,
            -- builtins.diagnostics.pylint,
            -- builtins.diagnostics.mypy,
            -- builtins.diagnostics.golangci_lint,
            -- builtins.diagnostics.jsonlint,
            -- builtins.diagnostics.luacheck,
            builtins.diagnostics.shellcheck,
            -- builtins.diagnostics.yamllint,

            -- builtins.formatting.black,
            -- builtins.formatting.isort,
            -- builtins.formatting.gofmt,
            -- builtins.formatting.rustfmt,
            builtins.formatting.terraform_fmt,
        }
    })
end

return M
