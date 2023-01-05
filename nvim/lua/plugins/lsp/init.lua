local nix_codelldb = '/nix/store/v0x5l0r5jkh4ljzbi05j4v30ky7nqmg0-vscode-extension-vadimcn-vscode-lldb-1.6.10/share/vscode'
local extension_path = nix_codelldb .. '/extensions/vadimcn.vscode-lldb/'
local codelldb_path = extension_path .. "adapter/codelldb"
local liblldb_path = extension_path .. 'lldb/lib/liblldb.so'

local function lsp_keymaps(client, bufnr)
    local function rename()
        if pcall(require, 'inc_rename') then
            return ':IncRename ' .. vim.fn.expand('<cword>')
        end

        vim.lsp.buf.rename()
    end

    local map = vim.keymap.set
    map("n", "K", function()
        local ok, ufo = pcall(require, 'ufo')
        if ok and not ufo.peekFoldedLinesUnderCursor() then
            vim.lsp.buf.hover()
        end
    end, { desc = "lsp:hover" })
    map("n", "gd", vim.lsp.buf.declaration,
        { desc = "lsp:declaration", buffer = bufnr })
    map("n", "gD", vim.lsp.buf.definition,
        { desc = "lsp:definition", buffer = bufnr })
    map("n", "gT", vim.lsp.buf.type_definition,
        { desc = "lsp:type_definition", buffer = bufnr })
    map("n", "gR", vim.lsp.buf.references,
        { desc = "lsp:references", buffer = bufnr })
    map("n", "<leader>lr", rename,
        { desc = "lsp:rename", buffer = bufnr, expr = true })
    map("n", "<leader>la", vim.lsp.buf.code_action,
        { desc = "lsp:code_action", buffer = bufnr })
    map("n", "<leader>lD", vim.lsp.buf.document_symbol,
        { desc = "lsp:document_symbol", buffer = bufnr })
    map("n", "<leader>lW", vim.lsp.buf.workspace_symbol,
        { desc = "lsp:workspace_symbol", buffer = bufnr })
    map("n", "<leader>lR", "<cmd>LspRestart<cr>",
        { desc = "lsp:lsp_restart", buffer = bufnr })
    map("n", "<leader>lF", function() vim.lsp.buf.format({ async = true }) end,
        { desc = "lsp:formatting", buffer = bufnr })
    map("n", "gI", vim.lsp.buf.implementation,
        { desc = "lsp:implementation", buffer = bufnr })
    map("n", "[d", vim.diagnostic.goto_prev,
        { desc = "diag:goto_prev", buffer = bufnr })
    map("n", "]d", vim.diagnostic.goto_next,
        { desc = "diag:goto_next", buffer = bufnr })
    map("n", "<leader>fd", "<cmd>Telescope diagnostics<cr>",
        { desc = "diag:telescope", buffer = bufnr })
    map("n", "<leader>lq", vim.diagnostic.setqflist,
        { desc = "diag:set_to_quicklist", buffer = bufnr })
    map("n", "<leader>ll", vim.diagnostic.setloclist,
        { desc = "diag:set_to_loclist", buffer = bufnr })
    map("n", "<leader>lg", vim.diagnostic.open_float,
        { desc = "diag:open_float", buffer = bufnr })

    if client.name == 'rust_analyzer' then
        map('n', 'gK', function()
            require('rust-tools').hover_actions.hover_actions()
        end, { desc = 'rt:hover_actions', buffer = bufnr })
    end
end

return {
    {
        'ojroques/nvim-lspfuzzy',
        event = 'VeryLazy',
        config = {},
        dependencies = {
            'junegunn/fzf.vim',
        },
    },
    {
        'williamboman/mason.nvim',
        cmd = 'Mason',
        keys = {
            { '<localleader>cm', '<cmd>Mason<CR>', desc = 'Mason' },
        },
        ensure_installed = {
            'codelldb',
            'luacheck',
            'shellcheck',
            'black',
            'isort',
            'flake8',
            'pylint',
            'mypy',
            'eslint_d',
        },
        config = function(plugin)
            require('mason').setup()
            local mr = require('mason-registry')
            for _, tool in ipairs(plugin.ensure_installed) do
                local p = mr.get_package(tool)
                if not p:is_installed() then
                    p:install()
                end
            end
        end,
    },
    {
        'jose-elias-alvarez/null-ls.nvim',
        event = 'BufReadPre',
        dependencies = { 'mason.nvim' },
        config = function()
            local nls = require('null-ls')
            local builtins = nls.builtins
            local nls_au = vim.api.nvim_create_augroup('LspFormatting', {})
            nls.setup({
                sources = {
                    builtins.code_actions.eslint_d,
                    -- builtins.code_actions.gitsigns,
                    builtins.code_actions.shellcheck,

                    builtins.diagnostics.commitlint.with({
                        filetypes = { 'gitcommit', 'NeogitCommitMessage' },
                        extra_args = { '--config', vim.fn.expand('~/.commitlintrc.js') }
                    }),
                    builtins.diagnostics.eslint_d,
                    builtins.diagnostics.pylint,
                    builtins.diagnostics.mypy,
                    -- builtins.diagnostics.golangci_lint,
                    -- builtins.diagnostics.jsonlint,
                    -- builtins.diagnostics.luacheck,
                    builtins.diagnostics.shellcheck,
                    -- builtins.diagnostics.yamllint,

                    builtins.formatting.eslint_d,
                    builtins.formatting.clang_format,
                    builtins.formatting.black,
                    builtins.formatting.isort,
                    builtins.formatting.gofmt,
                    builtins.formatting.rustfmt,
                    builtins.formatting.terraform_fmt,
                },
            })
        end,
    },
    {
        'neovim/nvim-lspconfig',
        event = 'BufReadPost',
        common_flags = {
            debounce_text_changes = 150,
        },
        servers = {
            bashls = {},
            clangd = {},
            cssls = {},
            -- dotls = {},
            dockerls = {},
            gopls = {},
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
            pylsp = {},
            rust_analyzer = {
                tools = {
                    hover_actions = {
                        auto_focus = true,
                    }
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
                                    "unresolved-proc-macro"
                                },
                            },
                        }
                    }
                },
            },
            -- solargraph = {},
            sumneko_lua = {
                settings = {
                    Lua = {
                        completion = {
                            callSnippet = 'Replace',
                        }
                    }
                },
            },
            terraformls = {},
            -- vimls = {},
            tsserver = {},
            yamlls = {
                on_attach = function(client, bufnr)
                    if vim.bo[bufnr].buftype ~= "" or vim.bo[bufnr].filetype == "helm" then
                        vim.diagnostic.disable(bufnr)
                        vim.defer_fn(function()
                            vim.diagnostic.reset(nil, bufnr)
                        end, 1000)
                    end
                end,
            },
        },
        config = function(plugin)
            require('utils.lsp').on_attach(function(client, buffer)
                lsp_keymaps(client, buffer)
                require('utils.lsp').format_on_attach(client, buffer)
            end)

            local ok_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
            local capabilities = vim.lsp.protocol.make_client_capabilities()
            local cmp_capabilities = {}
            if ok_cmp then
                cmp_capabilities = cmp_nvim_lsp.default_capabilities()
            end
            capabilities.textDocument.foldingRange = {
                dynamicRegistration = false,
                lineFoldingOnly = true
            }
            capabilities = require('utils').table_merge(capabilities, cmp_capabilities)

            local servers = plugin.servers
            for server, opts in pairs(servers) do
                local server_opts = opts
                server_opts.flags = plugin.common_flags
                server_opts.capabilities = capabilities
                require('lspconfig')[server].setup(server_opts)
            end
        end,
        dependencies = {
            { 'folke/neodev.nvim', config = {} },
            { 'j-hui/fidget.nvim', config = {} },
            { 'smjonas/inc-rename.nvim', config = {} },
            { 'b0o/SchemaStore.nvim' },
            { 'simrat39/rust-tools.nvim' },
            'mason.nvim',
            {
                'SmiteshP/nvim-navic',
                init = function()
                    vim.g.navic_silence = true
                    require('utils.lsp').on_attach(function(client, buffer)
                        require('nvim-navic').attach(client, buffer)
                    end)
                end,
                config = { depth_limit = 3 },
            },
            {
                'williamboman/mason-lspconfig.nvim',
                config = { automatic_installation = true },
            },
            'hrsh7th/cmp-nvim-lsp',
        },
    },
}
