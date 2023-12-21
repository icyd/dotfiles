local linters_by_ft = {
    dockerfile = { "hadolint" },
    go = { "golangcilint" },
    haskell = { "hlint" },
    json = { "jsonlint" },
    -- lua = { 'luacheck', },
    markdown = { "vale" },
    nix = { "nix" },
    python = { "mypy", "flake8", "pylint" },
    sh = { "shellcheck" },
    yaml = { "yamllint" },
}

local formatters_by_ft = {
    go = { "gofmt", "goimports" },
    haskell = { "fourmolu" },
    json = { "jq" },
    lua = { "stylua" },
    nix = { "nixfmt" },
    python = { "black", "isort" },
    -- rust = { 'rustfmt', },
    sh = { "shellcheck" },
    terraform = { "terraform_fmt" },
    ["*"] = { "codespell" },
    ["_"] = { "trim_whitespace", "trim_newlines", "squeeze_blanks" },
}

---@param tools_by_ft object[]
---@param tools string[]
---@param excluded string[]
---@return string[] tools
local function tools_to_autoinstall(tools_by_ft, tools, excluded)
    local tools1 = vim.tbl_flatten(vim.tbl_values(tools_by_ft))
    local result = vim.fn.uniq(vim.list_extend(tools, tools1))
    ---@diagnostic disable-next-line: param-type-mismatch
    result = vim.tbl_filter(function(tool)
        return not vim.tbl_contains(excluded, tool)
    end, result)
    table.sort(result)

    return result
end

local function lsp_keymaps(client, bufnr)
    local function rename()
        if pcall(require, "inc_rename") then
            return ":IncRename " .. vim.fn.expand("<cword>")
        end

        vim.lsp.buf.rename()
    end

    local map = vim.keymap.set
    map("n", "K", function()
        local ok, ufo = pcall(require, "ufo")
        if ok and not ufo.peekFoldedLinesUnderCursor() then
            vim.lsp.buf.hover()
        end
    end, { desc = "lsp:hover" })
    map("n", "gd", vim.lsp.buf.declaration, { desc = "lsp:declaration", buffer = bufnr })
    map("n", "gD", vim.lsp.buf.definition, { desc = "lsp:definition", buffer = bufnr })
    map("n", "gT", vim.lsp.buf.type_definition, { desc = "lsp:type_definition", buffer = bufnr })
    map("n", "gR", vim.lsp.buf.references, { desc = "lsp:references", buffer = bufnr })
    map("n", "<leader>lr", rename, { desc = "lsp:rename", buffer = bufnr, expr = true })
    map("n", "<leader>la", vim.lsp.buf.code_action, { desc = "lsp:code_action", buffer = bufnr })
    map("n", "<leader>lD", vim.lsp.buf.document_symbol, { desc = "lsp:document_symbol", buffer = bufnr })
    map("n", "<leader>lW", vim.lsp.buf.workspace_symbol, { desc = "lsp:workspace_symbol", buffer = bufnr })
    map("n", "<leader>lR", "<cmd>LspRestart<cr>", { desc = "lsp:lsp_restart", buffer = bufnr })
    map("n", "<leader>lF", function()
        vim.lsp.buf.format({ async = true })
    end, { desc = "lsp:formatting", buffer = bufnr })
    map("n", "gI", vim.lsp.buf.implementation, { desc = "lsp:implementation", buffer = bufnr })
    map("n", "[d", vim.diagnostic.goto_prev, { desc = "diag:goto_prev", buffer = bufnr })
    map("n", "]d", vim.diagnostic.goto_next, { desc = "diag:goto_next", buffer = bufnr })
    map("n", "<leader>fd", "<cmd>Telescope diagnostics<cr>", { desc = "diag:telescope", buffer = bufnr })
    map("n", "<leader>lq", vim.diagnostic.setqflist, { desc = "diag:set_to_quicklist", buffer = bufnr })
    map("n", "<leader>ll", vim.diagnostic.setloclist, { desc = "diag:set_to_loclist", buffer = bufnr })
    map("n", "<leader>lg", vim.diagnostic.open_float, { desc = "diag:open_float", buffer = bufnr })

    if client.name == "rust_analyzer" then
        map("n", "gK", function()
            require("rust-tools").hover_actions.hover_actions()
        end, { desc = "rt:hover_actions", buffer = bufnr })
    end
end

local common_flags = {
    debounce_text_changes = 150,
}

local servers = {
    bashls = {},
    clangd = {},
    cssls = {},
    -- dotls = {},
    dockerls = {},
    gopls = {},
    -- hls = {},
    -- graphql = {},
    jdtls = {},
    jsonls = {
        on_new_config = function(new_config)
            new_config.settings.json.schemas = new_config.settings.json.schemas or {}
            vim.list_extend(new_config.settings.json.schemas, require("schemastore").json.schemas())
        end,
        settings = {
            json = {
                format = {
                    enable = true,
                },
                validate = { enable = true },
            },
        },
    },
    html = {},
    pyright = {},
    rust_analyzer = {
        tools = {
            -- executor = require("rust-tools.executors").toggleterm,
            hover_actions = {
                auto_focus = true,
            },
        },
        -- dap = {
        -- adapter = require('rust-tools.dap').get_codelldb_adapter(codelldb_path, liblldb_path),
        -- },
        server = {
            standalone = true,
            settings = {
                ["rust-analyzer"] = {
                    checkOnSave = {
                        command = "clippy",
                        allFeatures = true,
                    },
                    diagnostics = {
                        disabled = {
                            "unresolved-proc-macro",
                        },
                    },
                },
            },
        },
    },
    -- solargraph = {},
    lua_ls = {
        settings = {
            Lua = {
                completion = {
                    callSnippet = "Replace",
                },
            },
        },
    },
    terraformls = {},
    -- vimls = {},
    tsserver = {},
    yamlls = {
        on_attach = function(_, bufnr)
            if vim.bo[bufnr].buftype ~= "" or vim.bo[bufnr].filetype == "helm" then
                vim.diagnostic.disable(bufnr)
                vim.defer_fn(function()
                    vim.diagnostic.reset(nil, bufnr)
                end, 1000)
            end
        end,
        on_new_config = function(new_config)
            new_config.settings.yaml.schemas = new_config.settings.yaml.schemas or {}
            vim.list_extend(new_config.settings.yaml.schemas, require("schemastore").yaml.schemas())
        end,
        settings = {
            yaml = {
                schemaStore = {
                    enable = false,
                    url = "",
                },
                --         schemas = require('schemastore').yaml.schemas(),
            },
        },
    },
    zls = {},
}

local to_install = { "golangci-lint" }
local to_exclude = vim.list_extend(
    { "golangcilint", "hlint", "nix", "nixfmt", "gofmt", "terraform_fmt" },
    vim.tbl_get(formatters_by_ft, "_")
)
local by_ft = {}
by_ft = require("utils").table_of_array_merge(by_ft, linters_by_ft)
by_ft = require("utils").table_of_array_merge(by_ft, formatters_by_ft)
local tools_to_install = tools_to_autoinstall(by_ft, to_install, to_exclude)

return {
    -- {
    --     'ojroques/nvim-lspfuzzy',
    --     event = 'VeryLazy',
    --     config = true,
    --     dependencies = {
    --         'junegunn/fzf.vim',
    --     },
    -- },
    {
        "williamboman/mason.nvim",
        cmd = "Mason",
        keys = {
            { "<localleader>cm", "<cmd>Mason<CR>", desc = "Mason" },
        },
        dependencies = {
            {
                "WhoIsSethDaniel/mason-tool-installer.nvim",
                opts = {
                    ensure_installed = tools_to_install,
                },
            },
        },
        config = true,
        --     require('mason').setup()
        --     local mr = require('mason-registry')
        --     for _, tool in ipairs(plugin.ensure_installed) do
        --         local p = mr.get_package(tool)
        --         if not p:is_installed() then
        --             p:install()
        --         end
        --     end
        -- end,
    },
    -- {
    --     'jose-elias-alvarez/null-ls.nvim',
    --     enabled = false,
    --     event = 'BufReadPre',
    --     dependencies = { 'mason.nvim' },
    --     config = function()
    --         local nls = require('null-ls')
    --         local builtins = nls.builtins
    --         local nls_au = vim.api.nvim_create_augroup('LspFormatting', {})
    --         nls.setup({
    --             sources = {
    --                 builtins.code_actions.eslint,
    --                 -- builtins.code_actions.gitsigns,
    --                 builtins.code_actions.shellcheck,
    --
    --                 builtins.diagnostics.commitlint.with({
    --                     filetypes = { 'gitcommit', 'NeogitCommitMessage' },
    --                     extra_args = { '--config', vim.fn.expand('~/.commitlintrc.js') }
    --                 }),
    --                 builtins.diagnostics.eslint,
    --                 builtins.diagnostics.flake8,
    --                 builtins.diagnostics.mypy.with({
    --                     prefer_local = '.venv/bin',
    --                 }),
    --                 -- builtins.diagnostics.golangci_lint,
    --                 -- builtins.diagnostics.jsonlint,
    --                 -- builtins.diagnostics.luacheck,
    --                 builtins.diagnostics.shellcheck,
    --                 -- builtins.diagnostics.yamllint,
    --                 -- openapi
    --                 builtins.diagnostics.vacuum,
    --                 builtins.formatting.eslint,
    --                 builtins.formatting.clang_format,
    --                 builtins.formatting.black,
    --                 builtins.formatting.isort,
    --                 builtins.formatting.gofmt,
    --                 builtins.formatting.goimports,
    --                 builtins.formatting.rustfmt,
    --                 builtins.formatting.terraform_fmt,
    --             },
    --         })
    --     end,
    -- },
    {
        "mfussenegger/nvim-lint",
        event = "BufReadPre",
        dependencies = { "mason.nvim" },
        config = function()
            require("lint").linters_by_ft = linters_by_ft
            vim.api.nvim_create_autocmd({ "BufWritePost" }, {
                callback = function()
                    require("lint").try_lint()
                end,
            })
        end,
    },
    {
        "stevearc/conform.nvim",
        event = "BufReadPost",
        dependencies = { "mason.nvim" },
        opts = {
            formatters_by_ft = formatters_by_ft,
            format_on_save = {
                timeout_ms = 500,
                lsp_fallback = true,
            },
        },
    },
    {
        "neovim/nvim-lspconfig",
        event = "BufReadPost",
        config = function()
            require("utils.lsp").on_attach(function(client, buffer)
                lsp_keymaps(client, buffer)
                -- require('utils.lsp').format_on_attach(client, buffer)
            end)

            local ok_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
            local capabilities = vim.lsp.protocol.make_client_capabilities()
            local cmp_capabilities = {}
            if ok_cmp then
                cmp_capabilities = cmp_nvim_lsp.default_capabilities()
            end
            capabilities.textDocument.foldingRange = {
                dynamicRegistration = false,
                lineFoldingOnly = true,
            }
            capabilities = require("utils").table_merge(capabilities, cmp_capabilities)

            for server, opts in pairs(servers) do
                local server_opts = opts
                server_opts.flags = common_flags
                server_opts.capabilities = capabilities
                if server == "rust_analyzer" then
                    require("rust-tools").setup(server_opts)
                else
                    require("lspconfig")[server].setup(server_opts)
                end
            end
        end,
        dependencies = {
            { "folke/neodev.nvim", opts = {} },
            { "j-hui/fidget.nvim", opts = {} },
            { "smjonas/inc-rename.nvim", opts = {} },
            { "b0o/SchemaStore.nvim" },
            {
                "simrat39/rust-tools.nvim",
                dependencies = {
                    "saecki/crates.nvim",
                    tag = "stable",
                    dependencies = { "nvim-lua/plenary.nvim" },
                    event = { "BufRead Cargo.toml" },
                    opts = {},
                },
            },
            {
                "mrcjkb/haskell-tools.nvim",
                version = "^3", -- Recommended
                ft = { "haskell", "lhaskell", "cabal", "cabalproject" },
                config = function()
                    vim.g.haskell_tools = {
                        tools = {
                            repl = {
                                handler = "toggleterm",
                            },
                        },
                    }
                end,
            },
            "mason.nvim",
            {
                "SmiteshP/nvim-navic",
                init = function()
                    vim.g.navic_silence = true
                    require("utils.lsp").on_attach(function(client, buffer)
                        require("nvim-navic").attach(client, buffer)
                    end)
                end,
                opts = { depth_limit = 3 },
            },
            {
                "williamboman/mason-lspconfig.nvim",
                opts = { Eautomatic_installation = false },
            },
        },
        "hrsh7th/cmp-nvim-lsp",
    },
}
