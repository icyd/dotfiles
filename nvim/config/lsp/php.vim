au User lsp_setup call lsp#register_server({
    \ 'name': 'intelephense',
    \ 'cmd': {server_info->['node', expand('PATH_TO_GLOBAL_NODE_MODULES/intelephense/lib/intelephense.js'), '--stdio']},
    \ 'initialization_options': {"storagePath": "PATH_TO_TEMP_FOLDER/intelephense"},
    \ 'whitelist': ['php'],
    \ 'workspace_config': { 'intelephense': {
    \   'files.associations': ['*.php'],
    \ }},
    \ })
