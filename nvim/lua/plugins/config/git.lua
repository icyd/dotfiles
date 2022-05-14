local utils = require('utils')
local augroup, map = utils.augroup, utils.map

vim.cmd[[command! -bang -nargs=* -complete=file Make NeomakeProject <args>]]

map('n', '<leader>gs', ':Git<CR>')
map('n', '<leader>gd', ':Gvdiffsplit!<CR>')
map('n', '<leader>gph', ':Git -c push.default=current push <CR>')
map('n', '<leader>gpl', ':Git pull<CR>')
map('n', '<leader>gh', ':diffget //2<CR>')
map('n', '<leader>gl', ':diffget //3<CR>')

local fugitive_autocmd =  [[User fugitive if fugitive#buffer().type() =~# '^\%(tree\|blob\)$' ]]..
    [[nnoremap <buffer> .. :edit %:h<CR> | endif]]
augroup('fugitive', {
    fugitive_autocmd,
    'BufReadPost fugitive://* set bufhidden=delete',
})

-- -- git-worktree
-- require("git-worktree").setup({
--     change_directory_command = "tcd",
--     update_on_change = true,
--     update_on_change_command = "e .",
--     clearjumps_on_change = true,
--     autopush = false,
-- })


