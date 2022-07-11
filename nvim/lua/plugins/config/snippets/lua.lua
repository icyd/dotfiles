return {
    s("localreq",
        fmt('local {} = require("{}")', {
            l(l._1:match("[^.]*$"):gsub("[^%a]+", "_"), 1),
            i(1, "module"),
        })
    ),
}, nil
