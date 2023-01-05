return {
    'godlygeek/tabular',
    cmd = 'Tabularize',
    keys = {
        { '<localleader>e', '<cmd>Tabularize /=<CR>', desc = 'Tabularize with space', mode = { 'n', 'v' } },
        { '<localleader><space>', '<cmd>Tabularize /<space>\zs<CR>', desc = 'Tabularize with slash', mode = { 'n', 'v' } },
        { '<localleader>|', '<cmd>Tabularize /|<CR>', desc = 'Tabularize with bars', mode = { 'n', 'v' } },
        { '<localleader>:', '<cmd>Tabularize /:\zs<CR>', desc = 'Tabularize with colon', mode = { 'n', 'v' } },
        { '<localleader>,', '<cmd>Tabularize /,\zs<CR>', desc = 'Tabularize with comma', mode = { 'n', 'v' } },
    },
}
