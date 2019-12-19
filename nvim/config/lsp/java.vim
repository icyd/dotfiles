if executable('java') && filereadable(expand('/usr/share/java/jdtls/plugins/org.eclipse.equinox.launcher_1.5.500.v20190715-1310.jar'))
    au User lsp_setup call lsp#register_server({
        \ 'name': 'eclipse.jdt.ls',
        \ 'cmd': {server_info->[
        \     'java',
        \     '-Declipse.application=org.eclipse.jdt.ls.core.id1',
        \     '-Dosgi.bundles.defaultStartLevel=4',
        \     '-Declipse.product=org.eclipse.jdt.ls.core.product',
        \     '-Dlog.level=ALL',
        \     '-noverify',
        \     '-Dfile.encoding=UTF-8',
        \     '-Xmx1G',
        \     '-jar',
        \     expand('/usr/share/java/jdtls/plugins/org.eclipse.equinox.launcher_1.5.500.v20190715-1310.jar'),
        \     '-configuration',
        \     expand('/usr/share/java/jdtls/config_linux'),
        \     '-data',
        \     getcwd()
        \ ]},
        \ 'whitelist': ['java'],
        \ })
endif
