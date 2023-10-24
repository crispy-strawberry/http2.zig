const std = @import("std");
const net = std.net;
const StreamServer = std.net.StreamServer;

pub const Server = @This();

stream: StreamServer,
allocator: std.mem.Allocator,

/// Initializes a server.
pub fn init(allocator: std.mem.Allocator) Server {
    return Server{
        .stream = StreamServer.init(.{
            .reuse_port = true,
        }),
        .allocator = allocator,
    };
}

pub fn listen(self: *Server) !void {
    const address = net.Address.initIp4([4]u8{ 127, 0, 0, 1 }, 8000);
    try self.stream.listen(address);
}

pub fn accept(self: *Server) !void {
    var conn = try self.stream.accept();
    defer conn.stream.close();

    var buf: [1024]u8 = undefined;
    var reader = conn.stream.reader();
    _ = reader;
    _ = conn.stream.read(buf[0..]) catch @panic("Errored!");

    // std.http.Server;
    //std.io.BufferedWriter
    var resp = try std.ArrayList(u8).initCapacity(self.allocator, 1024);
    defer resp.deinit();
    var resp_writer = resp.writer();
    try resp_writer.writeAll("HTTP/1.1 200 OK\r\n");
    try resp_writer.writeAll(
        \\Date: Sat, 14 October 2023 22:30:34 GMT
        \\Content-Type: text/html; charset=UTF-8
        \\Last-Modified: Wed, 08 Jan 2023 23:11:55 GMT
        \\Server: http2.zig (Windows) (Microsoft/Windows 10)
        // \\ETag: "3f80f-1b6-3e1cb03b"
        \\Content-Length: 183
        \\Accept-Ranges: bytes
        \\Connection: close
    );
    try resp_writer.writeAll("\r\n\r\n");

    try resp_writer.writeAll(
        \\<html lang="en">
        \\  <head>
        \\    <title>An Example Page</title>
        \\  </head>
        \\  <body>
        \\    <h1>Hello World</h1>
        \\    <p>Hello World, this is a very simple HTML document.</p>
        \\  </body>
        \\</html>
    );

    try conn.stream.writeAll(resp.items);
}

/// Deinitializes the server.
/// This also stops listening.
pub fn deinit(self: *Server) void {
    self.stream.deinit();
}
