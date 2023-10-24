const std = @import("std");
const testing = std.testing;

const allocator = testing.allocator;

const Server = @import("server.zig");

comptime {
    _ = @import("methods.zig");
}

test "test server init" {
    var server = Server.init(allocator);
    try server.listen();
    //while (true) {
    //    try server.accept();
    //}

    server.stream.close();
    server.deinit();
    // defer server.deinit();
}

// test "basic add functionality" {
//     const allocator = testing.allocator;
//     _ = allocator;
//     const address = try std.net.Address.parseIp("127.0.0.1", 8000);
//     var stream = std.net.StreamServer.init(.{ .reuse_address = true });
//     try stream.listen(address);
//     var conn = try stream.accept();
//     _ = try conn.stream.write("Hello World\n");
//     // defer stream.close();
//     //const stdout = std.io.getStdOut().writer();
//     //try stdout.print("Hello Test\n", .{});
//     // std.debug.print("Hello Test.\n", .{});
//     try testing.expect(add(3, 7) == 10);
// }
