-- local fn, map = vim.fn, require('utils').map
-- local has_words_before = function()
--     local line, col = unpack(vim.api.nvim_win_get_cursor(0))
--     return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
-- end
--
-- local feedkey = function(key, mode)
--     vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
-- end
--
local cmp = require('cmp')
local lspkind = require("lspkind")
local ls = require('luasnip')
local types = require('luasnip.util.types')

ls.config.setup({
    hystory = true,
    update_events = 'TextChanged,TextChangedI',
    enable_autosnippets = false,
    ext_opts = {
        [types.choiceNode] = {
            active = {
                virt_text = { { "⭅", "DiagnosticWarn" } },
            }
        }
    }
})

local snippets_dir = vim.fn.stdpath('config') .. '/lua/plugins/config/snippets/'
require('luasnip.loaders.from_lua').lazy_load { paths = snippets_dir }
-- require('luasnip.loaders.from_snipmate').lazy_load()
-- require('luasnip.loaders.from_vscode').lazy_load()
vim.cmd [[ command! LuaSnipEdit :lua require('luasnip.loaders.from_lua').edit_snippet_files() ]]

local t = function(str)
    return vim.api.nvim_replace_termcodes(str, true, true, true)
end

cmp.setup({
    formatting = {
        format = lspkind.cmp_format({
            mode = "symbol_text",
            menu = ({
                buffer = "[buf]",
                nvim_lsp = "[LSP]",
                nvim_lua = "[api]",
                path = "[path]",
                luasnip = "[snip]",
            }),
        }),
    },
    sources = cmp.config.sources({
        { name = 'nvim_lua' },
        { name = 'luasnip' },
        { name = 'nvim_lsp' },
    }, {
        { name = 'tags' },
        { name = 'path' },
        { name = 'buffer', keyword_length = 5 },
        { name = 'orgmode' },
        }),
    snippet = {
        expand = function(args)
            ls.lsp_expand(args.body)
        end,
    },
    mapping = {
        ['<C-y>'] = cmp.mapping(cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Insert, select = true }), {'i', 'c'}),
        ['<CR>']  = cmp.mapping({
            i = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true }),
            c = function(fallback)
                if cmp.visible() then
                    cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false })
                else
                   fallback()
                end
            end,
        }),
        ['<C-e>'] = cmp.mapping(cmp.mapping.close(), {'i', 'c'}),
        ['<C-d>'] = cmp.mapping.scroll_docs(-4),
        ['<C-u>'] = cmp.mapping.scroll_docs(4),
        ['<C-n>'] = cmp.mapping({
            c = function()
                if cmp.visible() then
                    cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
                else
                    vim.api.nvim_feedkeys(t('<Down>'), 'n', true)
                end
            end,
            i = function(fallback)
                if cmp.visible() then
                    cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
                else
                    fallback()
                end
            end
        }),
        ['<C-p>'] = cmp.mapping({
            c = function()
                if cmp.visible() then
                    cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
                else
                    vim.api.nvim_feedkeys(t('<Up>'), 'n', true)
                end
            end,
            i = function(fallback)
                if cmp.visible() then
                    cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
                else
                    fallback()
                end
            end
        }),
        ['<C-l>'] = cmp.mapping({
            c = cmp.mapping.complete(),
            s = function()
                if ls.choice_active() then
                    require('luasnip.extras.select_choice')()
                elseif ls.expand_or_jumpable() then
                    ls.expand_or_jump()
                elseif cmp.visible() then
                    cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false })
                else
                    cmp.complete()
                end
            end,
            i = function()
                if ls.choice_active() then
                    require('luasnip.extras.select_choice')()
                elseif ls.expand_or_jumpable() then
                    ls.expand_or_jump()
                elseif cmp.visible() then
                    cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false })
                else
                    cmp.complete()
                end
            end
        }),
        ['<Tab>'] = cmp.mapping(function(fallback)
            if ls.jumpable() then
                ls.jump(1)
            else
                fallback()
            end
        end, {'i', 's'}),
        ['<S-Tab>'] = cmp.mapping(function(fallback)
            if ls.jumpable(-1) then
                ls.jump()
            else
                fallback()
            end
        end, {'i', 's'}),
    },


    experimental = {
        ghost_text = true,
    },
})

cmp.setup.cmdline(':', {
    completion = { autocomplete = false },
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
        { name = 'buffer', keyword_length = 5 },
        { name = 'cmdline_history' },
    }),
})

for _, cmd_type in ipairs({'?', '@'}) do
    cmp.setup.cmdline(cmd_type, {
        completion = { autocomplete = false },
        sources = {
            { name = 'cmdline_history' },
        },
    })
end
