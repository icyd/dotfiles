return {
    s(
        { trig = "cl" },
        fmt([[
console.log({});
]]       , { i(0) }
        )),
    s(
        { trig = "tdesc" },
        fmt([[
describe('{}', () => {{
    {}
}});
]]       , {
            i(1, "suitename"),
            i(0),
        })),
    s(
        { trig = "test" },
        fmt([[
test('{}', {}() => {{
    {}
}});
]]       , {
            i(1, "testname"),
            c(2, { t "", t "async " }),
            i(0),
        })),
    s(
        { trig = "teach" },
        fmt([[
{}Each(() => {{
    {}
}});
]]       , {
            c(1, { t "before", t "after" }),
            i(0),
        })),
    s(
        { trig = "tall" },
        fmt([[
{}All(() => {{
    {}
}});
]]       , {
            c(1, { t "before", t "after" }),
            i(0),
        })),
}
