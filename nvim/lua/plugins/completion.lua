local function cmp_config()
    local cmp = require('cmp')
    local lspkind = require('lspkind')
    local ls = require('luasnip')
    local types = require('luasnip.util.types')

    ls.config.setup({
        hystory = true,
        update_events = 'TextChanged,TextChangedI',
        enable_autosnippets = false,
        ext_opts = {
            [types.choiceNode] = {
                active = {
                    virt_text = { { "●", "DiagnosticWarn" } },
                }
            },
            [types.insertNode] = {
                active = {
                    virt_text = { { "●", "DiagnosticSignInfo" } },
                }
            }
        }
    })

    local function ctr_l_func()
        if ls.expand_or_locally_jumpable() then
            ls.expand_or_jump()
        elseif cmp.visible() then
            cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false })
        else
            cmp.complete()
        end
    end

    local function tab_func(dir)
        return function(fallback)
            if ls.locally_jumpable(dir) then
                ls.jump(dir)
            else
                fallback()
            end
        end
    end

    local function next_prev_func(is_next, select_opts)
        local select_func
        local dir
        local key

        if is_next then
            key = '<Down>'
            dir = 1
            select_func = cmp.select_next_item
        else
            key = '<Up>'
            dir = -1
            select_func = cmp.select_prev_item
        end

        if select_func == nil then return end

        return {
            c = function()
                if cmp.visible() then
                    select_func(select_opts)
                else
                    vim.api.nvim_feedkeys(
                        vim.api.nvim_replace_termcodes(key, true, true, true),
                        'n',
                        true
                    )
                end
            end,
            i = function(fallback)
                if cmp.visible()  then
                    select_func(select_opts)
                else
                    fallback()
                end
            end,
            s = function(fallback)
                if ls.choice_active() then
                    ls.change_choice(dir)
                else
                    fallback()
                end
            end,
        }
    end

    cmp.setup({
        formatting = {
            format = lspkind.cmp_format({
                mode = "symbol_text",
                -- menu = ({
                --     buffer = "[buf]",
                --     nvim_lsp = "[LSP]",
                --     nvim_lua = "[api]",
                --     path = "[path]",
                --     luasnip = "[snip]",
                -- }),
            }),
        },
        sources = cmp.config.sources({
            { name = 'nvim_lsp_signature_help' },
            { name = 'nvim_lua' },
            { name = 'luasnip' },
            { name = 'nvim_lsp' },
            { name = 'crates' },
        }, {
            { name = 'path' },
            { name = 'buffer', keyword_length = 5 },
        }, {
            { name = 'neorg' },
            { name = 'orgmode' },
        }),
        snippet = {
            expand = function(args)
                ls.lsp_expand(args.body)
            end,
        },
        mapping = {
            ['<C-y>']   = cmp.mapping(function()
                if cmp.visible() then
                    cmp.confirm({
                        behavior = cmp.ConfirmBehavior.Insert,
                        select = true
                    })
                elseif ls.choice_active() then
                    require('luasnip.extras.select_choice')()
                else
                    cmp.complete()
                end
            end, { 'i', 'c', 's' }),
            ['<CR>']    = cmp.mapping({
                i = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true }),
                c = function(fallback)
                    if cmp.visible() then
                        cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true })
                    else
                        fallback()
                    end
                end,
            }),
            ['<C-e>']   = cmp.mapping(cmp.mapping.close(), { 'i', 'c' }),
            ['<C-d>']   = cmp.mapping.scroll_docs(-4),
            ['<C-u>']   = cmp.mapping.scroll_docs(4),
            ['<C-n>']   = cmp.mapping(next_prev_func(true, { behavior = cmp.SelectBehavior.Select })),
            ['<C-p>']   = cmp.mapping(next_prev_func(false, { behavior = cmp.SelectBehavior.Select })),
            ['<C-l>']   = cmp.mapping({
                c = cmp.mapping.complete(),
                s = ctr_l_func,
                i = ctr_l_func,
            }),
            ['<Tab>']   = cmp.mapping(tab_func(1), { 'i', 's' }),
            ['<S-Tab>'] = cmp.mapping(tab_func(-1), { 'i', 's' }),
        },


        experimental = {
            ghost_text = true,
        },
    })

    cmp.setup.cmdline(':', {
        completion = { autocomplete = false },
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
            { name = 'path' },
            { name = 'cmdline' },
        }, {
            { name = 'cmdline_history' },
        }),
    })

    cmp.setup.cmdline('/', {
        completion = { autocomplete = false },
        sources = cmp.config.sources({
            { name = 'nvim_lsp_document_symbol' },
        }, {
            { name = 'buffer',         keyword_length = 5 },
            { name = 'cmdline_history' },
        }),
    })

    for _, cmd_type in ipairs({ '?', '@' }) do
        cmp.setup.cmdline(cmd_type, {
            completion = { autocomplete = false },
            mapping = cmp.mapping.preset.cmdline(),
            sources = {
                { name = 'cmdline_history' },
            },
        })
    end

    cmp.event:on(
        'confirm_done',
        require('nvim-autopairs.completion.cmp').on_confirm_done()
    )
end

return {
    {
        'L3MON4D3/LuaSnip',
        version = 'v2.*',
        build = 'make install_jsregexp',
        dependencies = {
            { 'rafamadriz/friendly-snippets' },
            { 'saadparwaiz1/cmp_luasnip' },
            { 'mrcjkb/haskell-snippets.nvim', ft = 'haskell' },
        },
        config = function()
            local snippets_dir = vim.fn.stdpath('config') .. '/lua/plugins/snippets/'
            local ls = require("luasnip")
            local haskell_snippets = require("haskell-snippets").all
            ls.filetype_extend('typescriptreact', { 'typescript' })
            ls.add_snippets('haskell', haskell_snippets, { key = 'haskell' })
            require('luasnip.loaders.from_lua').lazy_load({ paths = { snippets_dir } })
            require('luasnip.loaders.from_vscode').lazy_load()
            vim.api.nvim_create_user_command('LuaSnipEdit',
                require('luasnip.loaders').edit_snippet_files, {}
            )
        end,
    },
    {
        'hrsh7th/nvim-cmp',
        -- event = { 'CmdLineEnter', 'InsertEnter' },
        dependencies = {
            { 'hrsh7th/cmp-buffer' },
            { 'hrsh7th/cmp-path' },
            { 'hrsh7th/cmp-cmdline' },
            { 'dmitmel/cmp-cmdline-history' },
            { 'hrsh7th/cmp-nvim-lsp' },
            { 'hrsh7th/cmp-nvim-lsp-document-symbol' },
            { 'hrsh7th/cmp-nvim-lsp-signature-help' },
            { 'hrsh7th/cmp-nvim-lua' },
            { 'onsails/lspkind.nvim' },
        },
        config = cmp_config,
    },
}
