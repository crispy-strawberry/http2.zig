const std = @import("std");
const ArrayList = std.ArrayList;
const StringHashMap = std.StringHashMap;

pub const Header = union(enum) {
    ContentLength: usize,
    value: []const u8,
};

pub const Headers = struct {
    allocator: std.mem.Allocator,
    buffer: StringHashMap([]const u8),

    pub fn init(allocator: std.mem.Allocator) Headers {
        return Headers{
            .allocator = allocator,
            .buffer = StringHashMap([]const u8).init(allocator),
        };
    }

    pub fn AddHeader(self: *Headers, key: []const u8, value: []const u8) !void {
        self.buffer.put(key, value);
    }

    pub fn deinit(self: *Headers) void {
        self.buffer.deinit();
    }
};
