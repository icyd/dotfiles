local map = vim.keymap.set

map('n', '<leader>gs', '<cmd>Git<CR>', { desc = 'Git status' })
map('n', '<leader>gd', '<cmd>Gvdiffsplit!<CR>', { desc = 'Git diff split' })
map('n', '<leader>gph', '<cmd>Git -c push.default=current push <CR>', { desc = 'Git push to upstream' })
map('n', '<leader>gpl', '<cmd>Git pull<CR>', { desc = 'Git pull from upstream' })
map('n', '<leader>gh', '<cmd>diffget //2<CR>', { desc = 'Git diff get left' })
map('n', '<leader>gl', '<cmd>diffget //3<CR>', { desc = 'Git diff get right' })


local fugitive_au = vim.api.nvim_create_augroup('fugitive_au', { clear = true })
vim.api.nvim_create_autocmd('BufReadPost', {
    pattern = 'fugitive://*',
    group = fugitive_au,
    command = 'set bufhidden=delete',
})
vim.api.nvim_create_autocmd('User', {
    pattern = 'fugitive',
    group = fugitive_au,
    command = [[if fugitive#buffer().type() =~# '^\%(tree\|blob\)$' ]]..
        [[nnoremap <buffer> .. :edit %:h<CR> | endif]]
})

-- -- git-worktree
-- require("git-worktree").setup({
--     change_directory_command = "tcd",
--     update_on_change = true,
--     update_on_change_command = "e .",
--     clearjumps_on_change = true,
--     autopush = false,
-- })
