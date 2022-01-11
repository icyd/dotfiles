local dap = require('dap')
local map = require('utils').map
local home = os.getenv('HOME')
local dap_dir = home .. '/.local/share/nvim/dap/'

map('n', '<leader>dq', '<cmd>lua require"dap".quit()<CR>')
map('n', '<leader>dct', '<cmd>lua require"dap".continue()<CR>')
map('n', '<leader>dsv', '<cmd>lua require"dap".step_over()<CR>')
map('n', '<leader>dsi', '<cmd>lua require"dap".step_into()<CR>')
map('n', '<leader>dso', '<cmd>lua require"dap".step_out()<CR>')
map('n', '<leader>dtb', '<cmd>lua require"dap".toggle_breakpoint()<CR>')

map('n', '<leader>dsc', '<cmd>lua require"dap.ui.variables".scopes()<CR>')
map('n', '<leader>dhh', '<cmd>lua require"dap.ui.variables".hover()<CR>')
map('v', '<leader>dhv',
    '<cmd>lua require"dap.ui.variables".visual_hover()<CR>')

map('n', '<leader>duh', '<cmd>lua require"dap.ui.widgets".hover()<CR>')
map('n', '<leader>duf',
    "<cmd>lua local widgets=require'dap.ui.widgets';widgets.centered_float(widgets.scopes)<CR>")

map('n', '<leader>dsbr',
    '<cmd>lua require"dap".set_breakpoint(vim.fn.input("Breakpoint condition: "))<CR>')
map('n', '<leader>dsbm',
    '<cmd>lua require"dap".set_breakpoint(nil, nil, vim.fn.input("Log point message: "))<CR>')
map('n', '<leader>dro', '<cmd>lua require"dap".repl.open()<CR>')
map('n', '<leader>drl', '<cmd>lua require"dap".repl.run_last()<CR>')

dap.adapters.lldb = {
    type = 'executable',
    name = 'lldb',
    command = '/bin/lldb-vscode',
}

dap.adapters.go = function(callback, config)
local stdout = vim.loop.new_pipe(false)
local handle
local pid_or_err
local port = 38697
local opts = {
  stdio = {nil, stdout},
  args = {"dap", "-l", "127.0.0.1:" .. port},
  detached = true
}
handle, pid_or_err = vim.loop.spawn("dlv", opts, function(code)
  stdout:close()
  handle:close()
  if code ~= 0 then
    print('dlv exited with code', code)
  end
end)
assert(handle, 'Error running dlv: ' .. tostring(pid_or_err))
stdout:read_start(function(err, chunk)
  assert(not err, err)
  if chunk then
    vim.schedule(function()
      require('dap.repl').append(chunk)
    end)
  end
end)
-- Wait for delve to start
vim.defer_fn(
  function()
    callback({type = "server", host = "127.0.0.1", port = port})
  end,
  100)
end

dap.adapters.python = {
    type = 'executable',
    command = home .. '/.venv/debugpy/bin/python',
    args = { '-m', 'debugpy.adapter' },
}

dap.configurations.cpp = {
  {
    name = "Launch file",
    type = "cppdbg",
    request = "launch",
    program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    end,
    cwd = '${workspaceFolder}',
    stopOnEntry = true,
  },
  {
    name = "Attach to gdbserver :1234",
    type = 'cppdbg',
    request = 'launch',
    MIMode = 'gdb',
    miDebuggerServerAddress = 'localhost:1234',
    miDebuggerPath = "/bin/gdb",
    cwd = '${workspaceFolder}',
    program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    end,
  },
  {
    name = 'Attach to gdbserver :3333 (ARM)',
    type = 'cppdbg',
    request = 'launch',
    MIMode = 'gdb',
    miDebuggerServerAddress = 'localhost:3333',
    miDebuggerPath = '/bin/arm-none-eabi-gdb',
    cwd = '${workspaceFolder}',
    program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    end,
  },
  {
    name = "Launch LLDB",
    type = "lldb",
    request = "launch",
    program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    end,
    cwd = '${workspaceFolder}',
    stopOnEntry = true,
    args = {},

    -- if you change `runInTerminal` to true, you might need to change the yama/ptrace_scope setting:
    --
    --    echo 0 | sudo tee /proc/sys/kernel/yama/ptrace_scope
    --
    -- Otherwise you might get the following error:
    --
    --    Error on launch: Failed to attach to the target process
    --
    -- But you should be aware of the implications:
    -- https://www.kernel.org/doc/html/latest/admin-guide/LSM/Yama.html
    runInTerminal = false,
  },
}
dap.configurations.c = dap.configurations.cpp
dap.configurations.rust = dap.configurations.cpp

dap.configurations.go = {
    {
      type = "go",
      name = "Debug",
      request = "launch",
      program = "${file}"
    },
    {
      type = "go",
      name = "Debug test", -- configuration for debugging test files
      request = "launch",
      mode = "test",
      program = "${file}"
    },
    -- works with go.mod packages and sub packages
    {
      type = "go",
      name = "Debug test (go.mod)",
      request = "launch",
      mode = "test",
      program = "./${relativeFileDirname}"
    },
    {
        type = "server",
        name = "Manual",
        host = "127.0.0.1",
        port = 38697,
    }
}

dap.configurations.python = {
    {
        type = 'python',
        request = 'launch',
        name = "Launch file",
        stopOnEntry = true,

        program = "${file}", -- This configuration will launch the current file if used.
        pythonPath = function()
          local cwd = vim.fn.getcwd()
          if vim.fn.executable(cwd .. '/venv/bin/python') == 1 then
            return cwd .. '/venv/bin/python'
          elseif vim.fn.executable(cwd .. '/.venv/bin/python') == 1 then
            return cwd .. '/.venv/bin/python'
          else
            return '/usr/bin/python'
          end
        end,
    },
}
