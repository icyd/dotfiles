"Force grab nvim server
function! Grab()
  if ! empty(v:servername)
    lua << EOF
      local server = io.open('/tmp/nvim-server', 'w')
      server:write(vim.api.nvim_get_vvar('servername'))
      server:close()
EOF
  endif
endfunction

"Vertical split function
function! VerticalSplitBuffer(buffer)
    execute "vert belowright sb" a:buffer
endfunction

"Function to remove trailing whitespaces
function! TrimTrailingSpaces()
        " Delete trailing spaces
        %s/\s*$//
        "Jump back to previous position
        ''
endfunction

"Change directory on tabenter
function! OnTabEnter(path)
  if isdirectory(a:path)
    let dirname = a:path
  else
    let dirname = fnamemodify(a:path, ":h")
  endif
  execute "tcd ". dirname
endfunction

"Function to check if file exist and source it
function! CheckandSource(file)
    if filereadable(expand(a:file))
        exec "source " . expand(a:file)
    endif
endfunction
