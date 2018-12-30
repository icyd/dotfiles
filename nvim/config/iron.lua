local iron = require("iron")

iron.core.set_config{
  preferred = { python = "ipython"}
}

-- REPL for ipython, open a pyenv where it's installed
iron.core.add_repl_definitions{
  pandoc = { -- This should be the file type
    pandoc_repl = {
      command = "ipython" -- This should be the command you want to run.
    }
  }
}
