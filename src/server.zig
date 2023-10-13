const std = @import("std");
const StreamServer = std.net.StreamServer;

pub const Server = @This();

stream: StreamServer,

/// Initializes a server.
pub fn init() Server {
    return Server{
        .stream = StreamServer.init(.{ .reuse_port = true }),
    };
}

/// Deinitializes the server.
/// This also stops listening.
pub fn deinit(self: *const Server) void {
    self.stream.deinit();
}
