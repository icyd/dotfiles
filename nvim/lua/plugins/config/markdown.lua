local g, cmd = vim.g, vim.cmd

g.mkdp_echo_preview_url = 1
g.mkdp_browser = 'Firefox'
g.mkdp_filetypes = {'markdown', 'pandoc'}
-- cmd[[
-- let $NVIM_MKDP_LOG_FILE = expand('~/mkdp-log.log')
-- let $NVIM_MKDP_LOG_LEVEL = 'debug'
-- ]]

