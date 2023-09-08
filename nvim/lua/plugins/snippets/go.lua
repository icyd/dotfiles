-- Requires {{{
local fmta = require("luasnip.extras.fmt").fmta
local rep = require("luasnip.extras").rep
local utils = require("plugins.snippets.utils")
local partial = require("luasnip.extras").partial
--}}}

-- Conditions {{{
local function not_in_function()
    return not utils.is_in_function()
end

local in_test_func = {
    show_condition = utils.is_in_test_function,
    condition = utils.is_in_test_function,
}

local in_test_file = {
    show_condition = utils.is_in_test_file,
    condition = utils.is_in_test_file,
}

local in_func = {
    show_condition = utils.is_in_function,
    condition = utils.is_in_function,
}

local not_in_func = {
    show_condition = not_in_function,
    condition = not_in_function,
}
--}}}

return {
    -- Main {{{
    s(
        { trig = "main", name = "Main", dscr = "Create a main function" },
        fmta("func main() {\n\t<>\n}", i(0)),
        not_in_func
    ), --}}}

    -- If call error {{{
    s(
        { trig = "ifcall", name = "IF CALL", dscr = "Call a function and check the error" },
        fmt(
            [[
      {}, {} := {}({})
      if {} != nil {{
      	return {}
      }}
      {}
    ]]       ,
            {
                i(1, { "val" }),
                i(2, { "err" }),
                i(3, { "Func" }),
                i(4),
                rep(2),
                d(5, utils.make_return_nodes, { 2 }),
                i(0),
            }
        ),
        in_func
    ), --}}}

    -- Function {{{
    s(
        { trig = "fn", name = "Function", dscr = "Create a function or a method" },
        fmt(
            [[
        // {} {}
        func {}{}({}) {} {{
        	{}
        }}
      ]]     ,
            {
                rep(2),
                i(5, "description"),
                c(1, {
                    t(""),
                    sn(
                        nil,
                        fmt("({} {}) ", {
                            i(1, "r"),
                            i(2, "receiver"),
                        })
                    ),
                }),
                i(2, "Name"),
                i(3),
                c(4, {
                    i(1, "error"),
                    sn(
                        nil,
                        fmt("({}, {}) ", {
                            i(1, "ret"),
                            i(2, "error"),
                        })
                    ),
                }),
                i(0),
            }
        ),
        not_in_func
    ), --}}}

    -- If error {{{
    s(
        { trig = "ife", name = "If error", dscr = "If error, return wrapped" },
        fmt("if {} != nil {{\n\treturn {}\n}}\n{}", {
            i(1, "err"),
            d(2, utils.make_return_nodes, { 1 }),
            i(0),
        }),
        in_func
    ), --}}}

    -- gRPC Error{{{
    s(
        { trig = "gerr", dscr = "Return an instrumented gRPC error" },
        fmt('internal.GrpcError({},\n\tcodes.{}, "{}", "{}", {})', {
            i(1, "err"),
            i(2, "Internal"),
            i(3, "Description"),
            i(4, "Field"),
            i(5, "fields"),
        }),
        in_func
    ), --}}}

    -- Mockery {{{
    s(
        { trig = "mockery", name = "Mockery", dscr = "Create an interface for making mocks" },
        fmt(
            [[
        // {} mocks {} interface for testing purposes.
        //go:generate mockery --name {} --filename {}_mock.go
        type {} interface {{
          {}
        }}
      ]]     ,
            {
                rep(1),
                rep(2),
                rep(1),
                f(function(args)
                    return utils.snake_case(args[1][1])
                end, { 1 }),
                i(1, "Client"),
                i(2, "pkg.Interface"),
            }
        )
    ), --}}}

    -- Nolint {{{
    s(
        { trig = "nolint", dscr = "ignore linter" },
        fmt([[// nolint:{} // {}]], {
            i(1, "names"),
            i(2, "explaination"),
        })
    ), --}}}

    -- Allocate Slices and Maps {{{
    s(
        { trig = "make", name = "Make", dscr = "Allocate map or slice" },
        fmt("{} {}= make({})\n{}", {
            i(1, "name"),
            i(2),
            c(3, {
                fmt("[]{}, {}", { i(1, "type"), i(2, "len") }),
                fmt("[]{}, 0, {}", { i(1, "type"), i(2, "len") }),
                fmt("map[{}]{}, {}", { i(1, "keys"), i(2, "values"), i(3, "len") }),
            }),
            i(0),
        }),
        in_func
    ), --}}}

    -- Test Cases {{{
    s(
        { trig = "tcs", dscr = "create test cases for testing" },
        fmta(
            [[
        tcs := map[string]struct {
        	<>
        } {
        	// Test cases here
        }
        for name, tc := range tcs {
        	tc := tc
        	t.Run(name, func(t *testing.T) {
        		<>
        	})
        }
      ]]     ,
            { i(1), i(2) }
        ),
        in_test_func
    ), --}}}

    -- Go CMP {{{
    s(
        { trig = "gocmp", dscr = "cmp.Diff" },
        fmt(
            [[
        if diff := cmp.Diff({}, {}); diff != "" {{
        	t.Errorf("(-want +got):\\n%s", diff)
        }}
      ]]     ,
            {
                i(1, "want"),
                i(2, "got"),
            }
        ),
        in_test_func
    ), --}}}

    -- Create Mocks {{{
    s(
        { trig = "mock", name = "Mocks", dscr = "Create a mock with defering assertion" },
        fmt("{} := &mocks.{}{{}}\ndefer {}.AssertExpectations(t)\n{}", {
            i(1, "m"),
            i(2, "Mocked"),
            rep(1),
            i(0),
        }),
        in_test_func
    ), --}}}

    -- Require NoError {{{
    s(
        { trig = "noerr", name = "Require No Error", dscr = "Add a require.NoError call" },
        c(1, {
            sn(nil, fmt("require.NoError(t, {})", { i(1, "err") })),
            sn(nil, fmt('require.NoError(t, {}, "{}")', { i(1, "err"), i(2) })),
            sn(nil, fmt('require.NoErrorf(t, {}, "{}", {})', { i(1, "err"), i(2), i(3) })),
        }),
        in_test_func
    ), --}}}

    -- Subtests {{{
    s(
        { trig = "Test", name = "Test/Subtest", dscr = "Create subtests" },
        fmta("func <>(t *testing.T) {\n<>\n}\n\n <>", {
            i(1),
            d(2, utils.create_t_run, ai({ 1 })),
            d(3, utils.mirror_t_run_funcs, ai({ 2 })),
        }),
        in_test_file
    ), --}}}

    -- Stringer {{{
    s(
        { trig = "strigner", name = "Stringer", dscr = "Create a stringer go:generate" },
        fmt("//go:generate stringer -type={} -output={}_string.go", {
            i(1, "Type"),
            partial(vim.fn.expand, "%:t:r"),
        })
    ), --}}}

    -- Query Database {{{
    s(
        { trig = "queryrows", name = "Query Rows", dscr = "Query rows from database" },
        fmta(
            [[
      const <> = `<>`
      <> := make([]<>, 0, <>)

      <> := <>.Do(func() error {
      	<>, <> := <>.Query(<>, <>, <>)
      	if errors.Is(<>, pgx.ErrNoRows) {
      		return &retry.StopError{Err: <>}
      	}
      	if <> != nil {
      		return errors.Wrap(<>, "making query")
      	}
      	defer <>.Close()

      	<> = <>[:0]
      	for <>.Next() {
      		var <> <>
      		<> := <>.Scan(<>)
      		if <> != nil {
      			return errors.Wrap(<>, "scanning row")
      		}

      		<>
      		<> = append(<>, <>)
      	}

      	return errors.Wrap(<>.Err(), "iterating rows")
      })
      return <>, <>
      ]]     ,
            {
                i(1, "query"),
                i(2, "SELECT 1"),
                i(3, "ret"),
                i(4, "Type"),
                i(5, "cap"),
                i(6, "err"),
                i(7, "retrier"),
                i(8, "rows"),
                i(9, "err"),
                i(10, "db"),
                i(11, "ctx"),
                rep(1), --query
                i(12, "args"),
                rep(9), -- pgx.ErrNoRows
                rep(9), -- pgx.ErrNoRows
                rep(9), -- other errors
                rep(9), -- other errors
                rep(8), -- rows close
                rep(3), -- ret
                rep(3), -- ret
                rep(8), -- rows next
                i(13, "doc"),
                rep(4), -- type
                i(14, "err"),
                rep(8), -- rows
                i(15, "&val"),
                rep(14), -- err
                rep(14), -- err
                i(0),
                rep(3), -- ret
                rep(3), -- ret
                rep(13), -- doc
                rep(8), -- rows error
                rep(3), -- ret
                rep(6), -- error
            }
        )
    ),

    -- Constructor {{{
    s(
        { trig = "ctor", name = "Constructor", dscr = "Create new function for struct" },
        fmt([[
func new{}({}) *{} {{
    return &{}{{
        {}
    }}
}}
]]       , {
            i(1, "name"),
            i(2, "args"),
            rep(1),
            rep(1),
            i(0),
        })
    ),
    -- }}}

    -- {{{
    s("pln", fmt("fmt.Println({})", i(0))),
    s("plnf", fmt("fmt.Printf({}, {})", { i(1), i(0) })),
    s("tfl", fmt("t.Fatal({})", i(0))),
    s("tfle", fmt("t.Fatalf({}, err.Error())", i(0))),
    s("tff", fmt("t.Fatalf({}, {})", { i(1), i(0) })),
    -- }}}
}

-- vim: fdm=marker fdl=0
