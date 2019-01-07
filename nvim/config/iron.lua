local iron = require("iron")

iron.core.add_repl_definitions{
  pandoc = { -- This should be the file type
    pandoc_repl = {
      command = "ipython" -- This should be the command you want to run.
    }
  }
}

-- Optionally, if you have more than one definition for the `pandoc` filetype, you can:
iron.core.set_config{
  preferred = {
    pandoc = "pandoc_repl"
  }
}
