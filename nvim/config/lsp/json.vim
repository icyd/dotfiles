if executable('json-languageserver')
  au User lsp_setup call lsp#register_server({
      \ 'name': 'json-languageserver',
      \ 'cmd': {server_info->[&shell, &shellcmdflag, 'json-languageserver --stdio']},
      \ 'whitelist': ['json'],
      \ })
endif
