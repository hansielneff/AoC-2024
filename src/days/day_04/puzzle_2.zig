const std = @import("std");

const input = @embedFile("input.txt");
const input_line_count = blk: {
    @setEvalBranchQuota(0x8000);
    break :blk std.mem.count(u8, input, "\n") + 1;
};
const input_line_width = std.mem.indexOfScalar(u8, input, '\n').?;
const input_size = input_line_count * input_line_width;

pub fn solve() void {
    var result: u32 = 0;

    var grid: [input_line_count][input_line_width]u8 = undefined;
    for (0..input_line_count) |y| {
        for (0..input_line_width) |x| {
            grid[y][x] = input[y * (input_line_width + 1) + x];
        }
    }

    for (0..input_line_count) |y| {
        for (0..input_line_width) |x| {
            if (y == 0 or y == input_line_count - 1 or
                x == 0 or x == input_line_width - 1 or
                grid[y][x] != 'A')
            {
                continue;
            }

            const tl = grid[y - 1][x - 1];
            const br = grid[y + 1][x + 1];
            const tr = grid[y - 1][x + 1];
            const bl = grid[y + 1][x - 1];
            if (((tl == 'M' and br == 'S') or (tl == 'S' and br == 'M')) and
                ((tr == 'M' and bl == 'S') or (tr == 'S' and bl == 'M')))
            {
                result += 1;
            }
        }
    }

    std.debug.print("Result: {d}\n", .{result});
}
