const std = @import("std");
const os = std.os;
const tests = @import("tests.zig");

// zig fmt: off
pub fn addCases(cases: *tests.StackTracesContext) void {
    const source_return =
        \\const std = @import("std");
        \\
        \\pub fn main() !void {
        \\    return error.TheSkyIsFalling;
        \\}
    ;
    const source_try_return =
        \\const std = @import("std");
        \\
        \\fn foo() !void {
        \\    return error.TheSkyIsFalling;
        \\}
        \\
        \\pub fn main() !void {
        \\    try foo();
        \\}
    ;
    const source_try_try_return_return =
        \\const std = @import("std");
        \\
        \\fn foo() !void {
        \\    try bar();
        \\}
        \\
        \\fn bar() !void {
        \\    return make_error();
        \\}
        \\
        \\fn make_error() !void {
        \\    return error.TheSkyIsFalling;
        \\}
        \\
        \\pub fn main() !void {
        \\    try foo();
        \\}
    ;

    switch (builtin.os.tag) {
        .freebsd => {
            cases.addCase(
                "return",
                source_return,
                [_][]const u8{
                // debug
                \\error: TheSkyIsFalling
                    \\source.zig:4:5: [address] in main (test)
                    \\    return error.TheSkyIsFalling;
                    \\    ^
                    \\
                ,
                // release-safe
                \\error: TheSkyIsFalling
                    \\source.zig:4:5: [address] in std.start.main (test)
                    \\    return error.TheSkyIsFalling;
                    \\    ^
                    \\
                ,
                // release-fast
                \\error: TheSkyIsFalling
                    \\
                ,
                // release-small
                \\error: TheSkyIsFalling
                    \\
                },
            );
            cases.addCase(
                "try return",
                source_try_return,
                [_][]const u8{
                // debug
                \\error: TheSkyIsFalling
                    \\source.zig:4:5: [address] in foo (test)
                    \\    return error.TheSkyIsFalling;
                    \\    ^
                    \\source.zig:8:5: [address] in main (test)
                    \\    try foo();
                    \\    ^
                    \\
                ,
                // release-safe
                \\error: TheSkyIsFalling
                    \\source.zig:4:5: [address] in std.start.main (test)
                    \\    return error.TheSkyIsFalling;
                    \\    ^
                    \\source.zig:8:5: [address] in std.start.main (test)
                    \\    try foo();
                    \\    ^
                    \\
                ,
                // release-fast
                \\error: TheSkyIsFalling
                    \\
                ,
                // release-small
                \\error: TheSkyIsFalling
                    \\
                },
            );
            cases.addCase(
                "try try return return",
                source_try_try_return_return,
                [_][]const u8{
                // debug
                \\error: TheSkyIsFalling
                    \\source.zig:12:5: [address] in make_error (test)
                    \\    return error.TheSkyIsFalling;
                    \\    ^
                    \\source.zig:8:5: [address] in bar (test)
                    \\    return make_error();
                    \\    ^
                    \\source.zig:4:5: [address] in foo (test)
                    \\    try bar();
                    \\    ^
                    \\source.zig:16:5: [address] in main (test)
                    \\    try foo();
                    \\    ^
                    \\
                ,
                // release-safe
                \\error: TheSkyIsFalling
                    \\source.zig:12:5: [address] in std.start.main (test)
                    \\    return error.TheSkyIsFalling;
                    \\    ^
                    \\source.zig:8:5: [address] in std.start.main (test)
                    \\    return make_error();
                    \\    ^
                    \\source.zig:4:5: [address] in std.start.main (test)
                    \\    try bar();
                    \\    ^
                    \\source.zig:16:5: [address] in std.start.main (test)
                    \\    try foo();
                    \\    ^
                    \\
                ,
                // release-fast
                \\error: TheSkyIsFalling
                    \\
                ,
                // release-small
                \\error: TheSkyIsFalling
                    \\
                },
            );
        },
        .linux => {
            cases.addCase(
                "return",
                source_return,
                [_][]const u8{
                // debug
                \\error: TheSkyIsFalling
                    \\source.zig:4:5: [address] in main (test)
                    \\    return error.TheSkyIsFalling;
                    \\    ^
                    \\
                ,
                // release-safe
                \\error: TheSkyIsFalling
                    \\source.zig:4:5: [address] in std.start.posixCallMainAndExit (test)
                    \\    return error.TheSkyIsFalling;
                    \\    ^
                    \\
                ,
                // release-fast
                \\error: TheSkyIsFalling
                    \\
                ,
                // release-small
                \\error: TheSkyIsFalling
                    \\
                },
            );
            cases.addCase(
                "try return",
                source_try_return,
                [_][]const u8{
                // debug
                \\error: TheSkyIsFalling
                    \\source.zig:4:5: [address] in foo (test)
                    \\    return error.TheSkyIsFalling;
                    \\    ^
                    \\source.zig:8:5: [address] in main (test)
                    \\    try foo();
                    \\    ^
                    \\
                ,
                // release-safe
                \\error: TheSkyIsFalling
                    \\source.zig:4:5: [address] in std.start.posixCallMainAndExit (test)
                    \\    return error.TheSkyIsFalling;
                    \\    ^
                    \\source.zig:8:5: [address] in std.start.posixCallMainAndExit (test)
                    \\    try foo();
                    \\    ^
                    \\
                ,
                // release-fast
                \\error: TheSkyIsFalling
                    \\
                ,
                // release-small
                \\error: TheSkyIsFalling
                    \\
                },
            );
            cases.addCase(
                "try try return return",
                source_try_try_return_return,
                [_][]const u8{
                // debug
                \\error: TheSkyIsFalling
                    \\source.zig:12:5: [address] in make_error (test)
                    \\    return error.TheSkyIsFalling;
                    \\    ^
                    \\source.zig:8:5: [address] in bar (test)
                    \\    return make_error();
                    \\    ^
                    \\source.zig:4:5: [address] in foo (test)
                    \\    try bar();
                    \\    ^
                    \\source.zig:16:5: [address] in main (test)
                    \\    try foo();
                    \\    ^
                    \\
                ,
                // release-safe
                \\error: TheSkyIsFalling
                    \\source.zig:12:5: [address] in std.start.posixCallMainAndExit (test)
                    \\    return error.TheSkyIsFalling;
                    \\    ^
                    \\source.zig:8:5: [address] in std.start.posixCallMainAndExit (test)
                    \\    return make_error();
                    \\    ^
                    \\source.zig:4:5: [address] in std.start.posixCallMainAndExit (test)
                    \\    try bar();
                    \\    ^
                    \\source.zig:16:5: [address] in std.start.posixCallMainAndExit (test)
                    \\    try foo();
                    \\    ^
                    \\
                ,
                // release-fast
                \\error: TheSkyIsFalling
                    \\
                ,
                // release-small
                \\error: TheSkyIsFalling
                    \\
                },
            );
        },
        .macosx => {
            cases.addCase(
                "return",
                source_return,
                [_][]const u8{
                // debug
                    \\error: TheSkyIsFalling
                    \\source.zig:4:5: [address] in main (test)
                    \\    return error.TheSkyIsFalling;
                    \\    ^
                    \\
                ,
                // release-safe
                    \\error: TheSkyIsFalling
                    \\source.zig:4:5: [address] in std.start.main (test)
                    \\    return error.TheSkyIsFalling;
                    \\    ^
                    \\
                ,
                // release-fast
                \\error: TheSkyIsFalling
                    \\
                ,
                // release-small
                \\error: TheSkyIsFalling
                    \\
                },
            );
            cases.addCase(
                "try return",
                source_try_return,
                [_][]const u8{
                // debug
                    \\error: TheSkyIsFalling
                    \\source.zig:4:5: [address] in foo (test)
                    \\    return error.TheSkyIsFalling;
                    \\    ^
                    \\source.zig:8:5: [address] in main (test)
                    \\    try foo();
                    \\    ^
                    \\
                ,
                // release-safe
                    \\error: TheSkyIsFalling
                    \\source.zig:4:5: [address] in std.start.main (test)
                    \\    return error.TheSkyIsFalling;
                    \\    ^
                    \\source.zig:8:5: [address] in std.start.main (test)
                    \\    try foo();
                    \\    ^
                    \\
                ,
                // release-fast
                \\error: TheSkyIsFalling
                    \\
                ,
                // release-small
                \\error: TheSkyIsFalling
                    \\
                },
            );
            cases.addCase(
                "try try return return",
                source_try_try_return_return,
                [_][]const u8{
                // debug
                    \\error: TheSkyIsFalling
                    \\source.zig:12:5: [address] in make_error (test)
                    \\    return error.TheSkyIsFalling;
                    \\    ^
                    \\source.zig:8:5: [address] in bar (test)
                    \\    return make_error();
                    \\    ^
                    \\source.zig:4:5: [address] in foo (test)
                    \\    try bar();
                    \\    ^
                    \\source.zig:16:5: [address] in main (test)
                    \\    try foo();
                    \\    ^
                    \\
                ,
                // release-safe
                    \\error: TheSkyIsFalling
                    \\source.zig:12:5: [address] in std.start.main (test)
                    \\    return error.TheSkyIsFalling;
                    \\    ^
                    \\source.zig:8:5: [address] in std.start.main (test)
                    \\    return make_error();
                    \\    ^
                    \\source.zig:4:5: [address] in std.start.main (test)
                    \\    try bar();
                    \\    ^
                    \\source.zig:16:5: [address] in std.start.main (test)
                    \\    try foo();
                    \\    ^
                    \\
                ,
                // release-fast
                \\error: TheSkyIsFalling
                    \\
                ,
                // release-small
                \\error: TheSkyIsFalling
                    \\
                },
            );
        },
        .windows => {
            cases.addCase(
                "return",
                source_return,
                [_][]const u8{
                // debug
                \\error: TheSkyIsFalling
                    \\source.zig:4:5: [address] in main (test.obj)
                    \\    return error.TheSkyIsFalling;
                    \\    ^
                    \\
                ,
                // release-safe
                // --disabled-- results in segmenetation fault
                "",
                // release-fast
                \\error: TheSkyIsFalling
                    \\
                ,
                // release-small
                \\error: TheSkyIsFalling
                    \\
                },
            );
            cases.addCase(
                "try return",
                source_try_return,
                [_][]const u8{
                // debug
                    \\error: TheSkyIsFalling
                    \\source.zig:4:5: [address] in foo (test.obj)
                    \\    return error.TheSkyIsFalling;
                    \\    ^
                    \\source.zig:8:5: [address] in main (test.obj)
                    \\    try foo();
                    \\    ^
                    \\
                ,
                // release-safe
                // --disabled-- results in segmenetation fault
                "",
                // release-fast
                \\error: TheSkyIsFalling
                    \\
                ,
                // release-small
                \\error: TheSkyIsFalling
                    \\
                },
            );
            cases.addCase(
                "try try return return",
                source_try_try_return_return,
                [_][]const u8{
                // debug
                    \\error: TheSkyIsFalling
                    \\source.zig:12:5: [address] in make_error (test.obj)
                    \\    return error.TheSkyIsFalling;
                    \\    ^
                    \\source.zig:8:5: [address] in bar (test.obj)
                    \\    return make_error();
                    \\    ^
                    \\source.zig:4:5: [address] in foo (test.obj)
                    \\    try bar();
                    \\    ^
                    \\source.zig:16:5: [address] in main (test.obj)
                    \\    try foo();
                    \\    ^
                    \\
                ,
                // release-safe
                // --disabled-- results in segmenetation fault
                "",
                // release-fast
                \\error: TheSkyIsFalling
                    \\
                ,
                // release-small
                \\error: TheSkyIsFalling
                    \\
                },
            );
        },
        else => {},
    }
}
// zig fmt: off
