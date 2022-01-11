local fn, map = vim.fn, require('utils').map

map('i', '<Tab>', "pumvisible() ? '<C-n>' : vsnip#jumpable(1)  ? '<Plug>(vsnip-jump-next)' : '<Tab>'", { noremap = false, expr = true })
map('i', '<S-Tab>', "pumvisible() ? '<C-p>' : vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)' : '<S-Tab>'", { noremap = false, expr = true })

-- Expand or jump
map('i', '<C-l>', "vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>'", { noremap = false, expr = true })
map('s', '<C-l>', "vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>'", { noremap = false, expr = true })

-- Jump forward or backward
map('s', '<Tab>', "vsnip#jumpable(1) ? '<Plug>(vsnip-jump-next)' : '<Tab>'", { noremap = false, expr = true })
map('s', '<S-Tab>', "vsnip#jumpable(-1) ? '<Plug>(vsnip-jump-prev)' : '<S-Tab>'", { noremap = false, expr = true })

local cmp = require('cmp')
cmp.setup({
    snippet = {
        expand = function(args)
            fn["vsnip#anonymous"](args.body)
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
    },
    sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'vsnip' },
    }, {
        { name = 'tags' },
        { name = 'buffer' },
        { name = 'path' },
    }),
    experimental = {
        ghost_text = true,
    },
})

cmp.setup.cmdline('/', {
    sources = {
      { name = 'buffer' }
    }
})

cmp.setup.cmdline(':', {
    sources = cmp.config.sources({
      { name = 'cmdline' }
    }, {
      { name = 'path' }
    })
})

-- Select or cut text to use as $TM_SELECTED_TEXT in the next snippet.
map('n', 's', '<Plug>(vsnip-select-text)')
map('x', 's', '<Plug>(vsnip-select-text)')
map('n', 'S', '<Plug>(vsnip-cut-text)')
map('x', 'S', '<Plug>(vsnip-cut-text)')
