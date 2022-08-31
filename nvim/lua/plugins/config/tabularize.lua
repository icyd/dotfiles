local M = {}

function M.setup()
    local map = vim.keymap.set

    map({ 'n', 'v' }, '<localleader>e', '<cmd>Tabularize /=<CR>', { desc = 'Tabularize with space' })
    map({ 'n', 'v' }, '<localleader><space>', '<cmd>Tabularize /<space>\zs<CR>', { desc = 'Tabularize with slash' })
    map({ 'n', 'v' }, '<localleader>|', '<cmd>Tabularize /|<CR>', { desc = 'Tabularize with bars' })
    map({ 'n', 'v' }, '<localleader>:', '<cmd>Tabularize /:\zs<CR>', { desc = 'Tabularize with colon' })
    map({ 'n', 'v' }, '<localleader>,', '<cmd>Tabularize /,\zs<CR>', { desc = 'Tabularize with comma' })
end

return M
