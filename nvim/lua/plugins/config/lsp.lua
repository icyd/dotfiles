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

local lspconfig = require("lspconfig")

require('nvim-lsp-installer').setup({
    automatic_installation = false,
})

local common_on_attach = function()
    vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "lsp:hover", buffer = 0 })
    vim.keymap.set("n", "gd", vim.lsp.buf.declaration, { desc = "lsp:declaration" })
    vim.keymap.set("n", "gD", vim.lsp.buf.definition, { desc = "lsp:definition" })
    vim.keymap.set("n", "gT", vim.lsp.buf.type_definition, { desc = "lsp:type_definition" })
    vim.keymap.set("n", "gR", vim.lsp.buf.references, { desc = "lsp:references" })
    vim.keymap.set("n", "<leader>lr", vim.lsp.buf.rename, { desc = "lsp:rename" })
    vim.keymap.set("n", "<leader>la", vim.lsp.buf.code_action, { desc = "lsp:code_action" })
    vim.keymap.set("n", "<leader>lD", vim.lsp.buf.document_symbol, { desc = "lsp:document_symbol" })
    vim.keymap.set("n", "<leader>lW", vim.lsp.buf.workspace_symbol, { desc = "lsp:workspace_symbol" })
    vim.keymap.set("n", "<leader>lR", "<cmd>LspRestart<cr>", { desc = "lsp:lsp_restart" })
    vim.keymap.set("n", "<leader>lF", function() vim.lsp.buf.format({async=true}) end, { desc = "lsp:formatting" })
    vim.keymap.set("n", "gI", vim.lsp.buf.implementation, { desc = "lsp:implementation" })
    vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "diag:goto_prev" })
    vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "diag:goto_next" })
    vim.keymap.set("n", "<leader>fd", "<cmd>Telescope diagnostics<cr>", { desc = "diag:telescope" })
    vim.keymap.set("n", "<leader>lq", vim.diagnostic.setqflist, { desc = "diag:set_to_quicklist" })
    vim.keymap.set("n", "<leader>ll", vim.diagnostic.setloclist, { desc = "diag:set_to_loclist" })
    vim.keymap.set("n", "<leader>lg", vim.diagnostic.open_float, { desc = "diag:open_float" })
    vim.api.nvim_create_autocmd("CursorHold", {
    buffer = bufnr,
    callback = function()
        local opts = {
          focusable = false,
          close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
          border = 'rounded',
          source = 'always',
          prefix = ' ',
          scope = 'cursor',
        }
        vim.diagnostic.open_float(nil, opts)
    end
    })
end

local capabilities = vim.lsp.protocol.make_client_capabilities()

local ok_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if ok_cmp then
    capabilities = cmp_nvim_lsp.update_capabilities(capabilities)
end

for _, name in pairs(servers) do
    local common_server_opts = {
        on_attach = common_on_attach,
    }

    if name == "yamlls" then
        lspconfig[name].setup({
            on_attach = function(client, bufnr)
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
        lspconfig[name].setup({
            on_attach = common_on_attach,
            settings = {
                Lua = {
                    runtime = {
                        version = 'LuaJIT',
                    },
                    diagnostics = {
                        globals = { 'vim' },
                    },
                    workspace = {
                        library = vim.api.nvim_get_runtime_file("", true),
                    },
                    telemetry = {
                        enable = false,
                    }
                },
            },
        })
        goto continue
    elseif name == "rust_analyzer" then
        local ok, rust_tools = pcall(require, "rust-tools")
        if not ok then
            print("Failed to load rust_tools, setting up rust_analyzer instead")
            goto continue
        else
            rust_tools.setup({
                server = {
                    on_attach = common_on_attach,
                    settings = {
                        ["rust-analyzer"] = {
                            checkOnSave = {
                                command = "clippy",
                                allFeatures = true,
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

require('utils').augroup('lsp_augroup', {
    'BufWritePre *.rs lua vim.lsp.buf.formatting_sync(nil, 2000)',
    'BufWritePre *.go lua vim.lsp.buf.formatting_sync(nil, 2000)',
})
