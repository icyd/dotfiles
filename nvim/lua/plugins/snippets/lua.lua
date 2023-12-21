local function lines(args, parent, old_state, initial_text)
    local nodes = {}
    old_state = old_state or {}

    -- count is nil for invalid input.
    local count = tonumber(args[1][1])
    -- Make sure there's a number in args[1].
    if count then
        for j = 1, count do
            local iNode
            if old_state and old_state[j] then
                -- old_text is used internally to determine whether
                -- dependents should be updated. It is updated whenever the
                -- node is left, but remains valid when the node is no
                -- longer 'rendered', whereas node:get_text() grabs the text
                -- directly from the node.
                iNode = i(j, old_state[j].old_text)
            else
                iNode = i(j, initial_text)
            end
            nodes[2 * j - 1] = iNode

            -- linebreak
            nodes[2 * j] = t({ "", "" })
            -- Store insertNode in old_state, potentially overwriting older
            -- nodes.
            old_state[j] = iNode
        end
    else
        nodes[1] = t("Enter a number!")
    end

    local snip = sn(nil, nodes)
    snip.old_state = old_state
    return snip
end

return {
    s("localreq",
        fmt([[local {} = require('{}')]], {
            l(l._1:match("[^.]*$"):gsub("[^%a]+", "_"), 1),
            i(1, "module"),
        })
    ),
    s("trig", {
        t "text: ", i(1), t { "", "copy: " },
        d(2, function(args)
                -- the returned snippetNode doesn't need a position; it's inserted
                -- "inside" the dynamicNode.
                return sn(nil, {
                    -- jump-indices are local to each snippetNode, so restart at 1.
                    i(1, args[1])
                })
            end,
            { 1 })
    }),
    s("trig2", {
        i(1, "1"),
        -- pos, function, argnodes, opts (containing the user_arg).
        d(2, lines, { 1 }, { user_args = { "\\nSample Text" } })
    })
}, nil
