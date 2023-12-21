local ht = require('haskell-tools')
-- Suggested keymaps that do not depend on haskell-language-server:
local bufnr = vim.api.nvim_get_current_buf()
-- set buffer = bufnr in ftplugin/haskell.lua
local opts = { noremap = true, silent = true, buffer = bufnr }
vim.keymap.set('n', '<localleader>hc', vim.lsp.codelens.run, opts)
vim.keymap.set('n', '<localleader>hs', ht.hoogle.hoogle_signature, opts)
vim.keymap.set('n', '<localleader>he', ht.lsp.buf_eval_all, opts)

-- Toggle a GHCi repl for the current package
vim.keymap.set('n', '<leader>rr', ht.repl.toggle, opts)
-- Toggle a GHCi repl for the current buffer
vim.keymap.set('n', '<leader>rf', function()
    ht.repl.toggle(vim.api.nvim_buf_get_name(0))
end, def_opts)
vim.keymap.set('n', '<leader>rq', ht.repl.quit, opts)

-- Detect nvim-dap launch configurations
-- (requires nvim-dap and haskell-debug-adapter)
-- ht.dap.discover_configurations(bufnr)
vim.g.haskell_tools = {
    tools = {
        repl = {
            prefer = 'cabal'
        }
    }
}
