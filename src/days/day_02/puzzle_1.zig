const std = @import("std");

const input = @embedFile("input.txt");
const input_line_count = blk: {
    @setEvalBranchQuota(0x8000);
    break :blk std.mem.count(u8, input, "\n") + 1;
};

pub fn solve() void {
    var result: u32 = 0;

    var it_line = std.mem.tokenizeScalar(u8, input, '\n');
    while (it_line.next()) |tkn| {
        var prev_num: ?u32 = null;
        var is_ascending: ?bool = null;
        var is_safe = true;
        var it_num = std.mem.tokenizeScalar(u8, tkn, ' ');
        while (it_num.next()) |num_str| {
            const num = std.fmt.parseUnsigned(u32, num_str, 10) catch unreachable;
            if (prev_num != null) {
                const is_step_ascending = (num > prev_num.?);
                if (is_ascending == null)
                    is_ascending = is_step_ascending;
                const diff = if (is_step_ascending) num - prev_num.? else prev_num.? - num;
                if (diff == 0 or diff > 3 or is_ascending != is_step_ascending)
                    is_safe = false;
            }
            prev_num = num;
        }
        if (is_safe) result += 1;
    }

    std.debug.print("Result: {d}\n", .{result});
}
