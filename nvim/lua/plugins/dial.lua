local M = {
    'monaqa/dial.nvim',
    keys = {
        { "<M-a>", function()
            return require('dial.map').inc_normal()
          end, expr = true, desc = 'Increment number' },
        { "<M-x>", function()
            return require("dial.map").dec_normal()
          end, expr = true, desc = 'Decrement number' },
    },
}

function M.config()
  local augend = require('dial.augend')
  require('dial.config').augends:register_group({
    default = {
      augend.integer.alias.decimal,
      augend.integer.alias.hex,
      augend.date.alias['%Y/%m/%d'],
      augend.constant.alias.bool,
      augend.semver.alias.semver,
    },
  })
end

return M
