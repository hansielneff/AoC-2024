const std = @import("std");

const input = @embedFile("input.txt");
const input_line_count = blk: {
    @setEvalBranchQuota(0x8000);
    break :blk std.mem.count(u8, input, "\n") + 1;
};

pub fn solve() void {
    var list_a = [_:0]u32{0} ** input_line_count;
    var list_b = [_:0]u32{0} ** input_line_count;

    var it = std.mem.tokenizeAny(u8, input, " \n");
    var num_index: usize = 0;
    while (it.next()) |tkn| {
        const line_index = num_index / 2;
        const num = std.fmt.parseUnsigned(u32, tkn, 10) catch break;
        const dst = if (num_index % 2 == 0) &list_a[line_index] else &list_b[line_index];
        dst.* = num;
        num_index += 1;
    }

    std.mem.sort(u32, &list_a, {}, std.sort.asc(u32));
    std.mem.sort(u32, &list_b, {}, std.sort.asc(u32));

    var result: u64 = 0;
    for (list_a, list_b) |a, b| {
        const signed_a: i64 = a;
        const signed_b: i64 = b;
        result += @abs(signed_a - signed_b);
    }

    std.debug.print("Result: {d}\n", .{result});
}
