const std = @import("std");

/// I liked the approach that `std.http.Methods`
/// Unlike the standard library, I don't give a shit about
/// c backend support.
pub const Method = enum(u192) {
    GET = parse("GET"),
    PUT = parse("PUT"),
    POST = parse("POST"),
    PATCH = parse("PATCH"),
    HEAD = parse("HEAD"),
    DELETE = parse("DELETE"),
    CONNECT = parse("CONNECT"),
    TRACE = parse("TRACE"),
    OPTIONS = parse("OPTIONS"),

    _,

    pub fn parse(s: []const u8) u192 {
        var val: u192 = undefined;
        @memcpy(std.mem.asBytes(&val)[0..s.len], s);
        return val;
    }

    pub fn fromString(s: []const u8) Method {
        return @enumFromInt(parse(s));
    }
};

test "method" {
    const get_method = Method.GET;

    std.debug.print("{d}\n", .{get_method});

    try std.testing.expectEqual(Method.fromString("POST"), Method.POST);
}
