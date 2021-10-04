local dap = require('dap')
local home = os.getenv('HOME')
local dap_dir = home .. '/.local/share/nvim/dap/'

dap.adapters.cppdbg = {
  type = 'executable',
  command = dap_dir .. 'extension/debugAdapters/OpenDebugAD7',
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
    name = 'Attach to gdbserver :3333',
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
