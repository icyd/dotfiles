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
    ["bui"] = "build",
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

return mapmake(types)
