local api, map = vim.api, vim.keymap.set

local servers = {
    "bashls",
    "clangd",
    "cssls",
    -- "dotls",
    "dockerls",
    "gopls",
    -- "graphql",
    "jdtls",
    "jsonls",
    "html",
    "pylsp",
    "rust_analyzer",
    -- "solargraph",
    "sumneko_lua",
    "terraformls",
    -- "vimls",
    "tsserver",
    "yamlls",
}

local lspconfig = require('lspconfig')

require('mason-lspconfig').setup({
    ensure_installed = servers,
    automatic_installation = true,
})

require('plugins.config.lsp.null-ls').setup()

-- local mason_root_dir = vim.fn.stdpath('data') .. '/mason'
local nix_codelldb = '/nix/store/v0x5l0r5jkh4ljzbi05j4v30ky7nqmg0-vscode-extension-vadimcn-vscode-lldb-1.6.10/share/vscode'

local common_on_attach = function(client)
    map("n", "K", vim.lsp.buf.hover, { desc = "lsp:hover", buffer = 0 })
    map("n", "gd", vim.lsp.buf.declaration, { desc = "lsp:declaration" })
    map("n", "gD", vim.lsp.buf.definition, { desc = "lsp:definition" })
    map("n", "gT", vim.lsp.buf.type_definition, { desc = "lsp:type_definition" })
    map("n", "gR", vim.lsp.buf.references, { desc = "lsp:references" })
    map("n", "<leader>lr", vim.lsp.buf.rename, { desc = "lsp:rename" })
    map("n", "<leader>la", vim.lsp.buf.code_action, { desc = "lsp:code_action" })
    map("n", "<leader>lD", vim.lsp.buf.document_symbol, { desc = "lsp:document_symbol" })
    map("n", "<leader>lW", vim.lsp.buf.workspace_symbol, { desc = "lsp:workspace_symbol" })
    map("n", "<leader>lR", "<cmd>LspRestart<cr>", { desc = "lsp:lsp_restart" })
    map("n", "<leader>lF", function() vim.lsp.buf.format({ async = true }) end,
        { desc = "lsp:formatting" })
    map("n", "gI", vim.lsp.buf.implementation, { desc = "lsp:implementation" })
    map("n", "[d", vim.diagnostic.goto_prev, { desc = "diag:goto_prev" })
    map("n", "]d", vim.diagnostic.goto_next, { desc = "diag:goto_next" })
    map("n", "<leader>fd", "<cmd>Telescope diagnostics<cr>", { desc = "diag:telescope" })
    map("n", "<leader>lq", vim.diagnostic.setqflist, { desc = "diag:set_to_quicklist" })
    map("n", "<leader>ll", vim.diagnostic.setloclist, { desc = "diag:set_to_loclist" })
    map("n", "<leader>lg", vim.diagnostic.open_float, { desc = "diag:open_float" })

    print(vim.inspect(client.resolved_capabilities))
    if client.resolved_capabilities.document_formatting then
        api.nvim_create_autocmd('BufWritePre', {
            buffer = 0,
            group = api.nvim_create_augroup('lsp_au', { clear = true }),
            callback = function() vim.lsp.buf.format({ async = false }) end,
        })
    end
end

local common_flags = {
    debounce_text_changes = 150,
}

local ok_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if ok_cmp then
    cmp_nvim_lsp.update_capabilities(vim.lsp.protocol.make_client_capabilities())
end

for _, name in pairs(servers) do
    local common_server_opts = {
        on_attach = common_on_attach,
        flags = common_flags,
    }

    if name == "yamlls" then
        lspconfig[name].setup({
            on_attach = function(_, bufnr)
                if vim.bo[bufnr].buftype ~= "" or vim.bo[bufnr].filetype == "helm" then
                    vim.diagnostic.disable(bufnr)
                    vim.defer_fn(function()
                        vim.diagnostic.reset(nil, bufnr)
                    end, 1000)
                end
                common_on_attach()
            end,
        })
        goto continue
    elseif name == "sumneko_lua" then
        lspconfig[name].setup(require('lua-dev').setup({
            lspconfig = {
                on_attach = common_server_opts,
            }
        }))
        --     lspconfig[name].setup({
        --         on_attach = common_on_attach,
        --         settings = {
        --             Lua = {
        --                 runtime = {
        --                     version = 'LuaJIT',
        --                 },
        --                 diagnostics = {
        --                     globals = { 'vim' },
        --                 },
        --                 workspace = {
        --                     library = vim.api.nvim_get_runtime_file("", true),
        --                 },
        --                 telemetry = {
        --                     enable = false,
        --                 }
        --             },
        --         },
        --     })
        goto continue
    elseif name == "rust_analyzer" then
        local ok, rust_tools = pcall(require, "rust-tools")
        if not ok then
            print("Failed to load rust_tools, setting up rust_analyzer instead")
            goto continue
        else
            -- local extension_path = mason_root_dir .. "/packages/codelldb/extension/"
            local extension_path = nix_codelldb .. '/extensions/vadimcn.vscode-lldb/'
            local codelldb_path = extension_path .. "adapter/codelldb"
            local liblldb_path = extension_path .. "lldb/lib/liblldb.so"
            rust_tools.setup({
                tools = {
                    hover_actions = {
                        auto_focus = true,
                    }
                },
                dap = {
                    adapter = require('rust-tools.dap').get_codelldb_adapter(codelldb_path, liblldb_path),
                },
                server = {
                    on_attach = function(client)
                        common_on_attach(client)
                        map('n', 'gK', require('rust-tools').hover_actions.hover_actions, { desc = 'rt:hover_actions' })
                    end,
                    flags = common_flags,
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
            })
            goto continue
        end
    end

    lspconfig[name].setup(common_server_opts)
    ::continue::
end
