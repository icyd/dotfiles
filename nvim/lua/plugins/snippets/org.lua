local extras = require("luasnip.extras")

return {
    s("code", fmt([[
#+BEGIN_SRC {}
    {}
#+END_SRC
]], {
        i(1),
        i(0),
    })),
    s("metadata", fmt([[
#+TITLE: {}
#+AUTHOR: {}
#+DATE: {}
#+EMAIL: {}
]], {
        i(0),
        t('Alberto Vázquez'),
        extras.partial(os.date, "%Y-%m-%d"),
        c(1, { t 'beto.v25@gmail.com' }),
    })),
}
