return {
    s("std", { t([[const std = @import("std");]]) }),
    s("main", fmt([[pub fn main() {} {{
    {}
}}]] , {
        c(1, { t("void"), t("!void") }),
        i(0)
    })),
    s("debug", fmt([[std.debug.print("{}\n", .{{{}}});]], {
        i(1),
        i(0)
    })),
    s("test", fmt([[test "{}" {{
    {}
}}]] , {
        i(1),
        i(0)
    })),
}
