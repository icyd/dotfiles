-- Requires {{{
local utils = require("plugins.config.snippets.utils")
local rep = require('luasnip.extras').rep
--}}}
--

local result_choices = function(args)
    local nodes = { t(" "), fmt(" -> Result<{}, {}> ", { i(1), i(2) }) }
    local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
    for _, line in ipairs(lines) do
        if line:match("anyhow::Result") then
            table.insert(nodes, fmt(" -> Result<{}> ", i(1)))
            break
        end
    end
    return sn(nil, c(1, nodes))
end

return {
    s("pd", fmt([[println!("{}: {}", {});{}]], {
        rep(1),
        c(2, { t("{{:?}}"), t("{{:#?}}") }),
        i(1),
        i(0)
    })),
    s(
        "modtest",
        fmt(
            [[
      #[cfg(test)]
      mod test {{
          use super::*;
          {}
      }}
    ]],
            i(0)
        )
    ),
    s(
        { trig = "test" },
        fmt(
            [[
  #[test]
  fn {}(){}{{
    {}
  }}
  ]],
            {
                i(1, "testname"),
                d(2, result_choices, {}),
                i(0),
            }
        )
    ),
    s("fn", fmt([[
fn {}(){}{{
    {}
}}
]],
            {
                i(1, "name"),
                d(2, result_choices, {}),
                i(0),
            }
        )
    ),
    s("eq", fmt("assert_eq!({}, {});{}", { i(1), i(2), i(0) })),
    s("sfn", fmt(
[[
{}struct {} {{
    {}
}}

impl {} {{
    {}fn new({}) -> Self {{
        Self {{
        {}
        }}
    }}
}}
]],
        {
            c(1, { t"", t"pub " }),
            i(2, "Name"),
            i(3, "Fields"),
            rep(2),
            rep(1),
            i(4, "args"),
            i(0),
        }
    )),
}
