local fn, map = vim.fn, require('utils').map
local t = function(str)
    return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local has_words_before = function()
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local feedkey = function(key, mode)
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
end

local cmp = require('cmp')
local luasnip = require('luasnip')
local snippets_dir = vim.fn.stdpath('config') .. '/lua/plugins/config/snippets/'
require('luasnip.loaders.from_lua').lazy_load { paths = snippets_dir }
require('luasnip.loaders.from_snipmate').lazy_load()
require('luasnip.loaders.from_vscode').lazy_load()
vim.cmd [[ command! LuaSnipEdit :lua require('luasnip.loaders.from_lua').edit_snippet_files() ]]

cmp.setup({
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end,
    },
    -- completion = {
    --     completeopt = 'menu,menuone,noinsert',
    -- },
    mapping = {
        ['<C-d>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.close(),
        ['<C-y>'] = cmp.mapping.confirm({ select = true }),
        ['<CR>'] = cmp.mapping.confirm({ select = true }),
        ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
            elseif has_words_before() then
                cmp.complete()
            else
                fallback()
            end
        end, { "i", "s" }),
        ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
                luasnip.jump(-1)
            end
        end, { "i", "s" }),
        ['<C-n>'] = cmp.mapping({
            c = function()
                vim.api.nvim_feedkeys(t('<Down>'), 'n', true)
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
                vim.api.nvim_feedkeys(t('<Up>'), 'n', true)
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
            i = function(fallback)
                if luasnip.choice_active() then
                    require('luasnip.extras.select_choice')()
                elseif luasnip.expand_or_jumpable() then
                    luasnip.expand_or_jump()
                elseif cmp.visible() then
                    cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false })
                else
                    fallback()
                end
            end,
            -- c = function(fallback)
            --     if cmp.visible() then
            --         cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false })
            --     else
            --         fallback()
            --     end
            -- end
        }),
    },
    sources = cmp.config.sources({
        { name = 'luasnip' },
        { name = 'nvim_lsp' },
    }, {
            { name = 'orgmode' },
            { name = 'tags' },
            { name = 'buffer' },
            { name = 'path' },
        }),
    experimental = {
        ghost_text = true,
    },
})

for _, cmd_type in ipairs({':', '/', '?', '@'}) do
    if cmd_type == '/' then
        local srcs = {
            { name = 'buffer' },
            { name = 'cmdline_history' },
        }
    elseif cmd_type == ':' then
        local srcs = cmp.config.sources({
            { name = 'cmdline' },
            { name = 'cmdline_history' },
        }, {
            { name = 'path' },
        })
    else
        local srcs = {
            { name = 'cmdline_history' },
        }
    end

    cmp.setup.cmdline(cmd_type, {
        sources = srcs
    })
end
