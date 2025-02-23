local function make(trig, name)
    return s(
        trig,
        fmt("{} {}\n\n{}", {
            c(1, {
                t(name .. ":"),
                sn(nil, fmt("{}({}):", { t(name), i(1, "scope") })),
            }),
            i(2, "title"),
            i(0),
        })
    )
end

local function mapmake(tbl)
    local t = {}
    for k, v in pairs(tbl) do
        table.insert(t, make(k, v))
    end
    return t
end

local types = {
    ["bui"] = "build", -- typos:disable-line
    ["chore"] = "chore",
    ["ci"] = "ci",
    ["docs"] = "docs",
    ["ft"] = "feat",
    ["fix"] = "fix",
    ["perf"] = "perf",
    ["refac"] = "refactor",
    ["rev"] = "revert",
    ["style"] = "style",
    ["test"] = "test",
}

local snippets = mapmake(types)
local all_snippets = {}

for _, v in pairs(snippets) do
    table.insert(all_snippets, v)
end

return all_snippets
