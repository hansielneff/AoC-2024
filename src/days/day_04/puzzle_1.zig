const std = @import("std");

const input = @embedFile("input.txt");
const input_line_count = blk: {
    @setEvalBranchQuota(0x8000);
    break :blk std.mem.count(u8, input, "\n") + 1;
};
const input_line_width = std.mem.indexOfScalar(u8, input, '\n').?;
const input_size = input_line_count * input_line_width;

const word = "XMAS";
const signed_word_len: isize = @as(isize, @intCast(word.len));

pub fn solve() void {
    var result: u32 = 0;

    var grid: [input_line_count][input_line_width]u8 = undefined;
    for (0..input_line_count) |y| {
        for (0..input_line_width) |x| {
            grid[y][x] = input[y * (input_line_width + 1) + x];
        }
    }

    const directions = [_]i8{ -1, 0, 1 };
    for (0..input_line_count) |y| {
        for (0..input_line_width) |x| {
            if (grid[y][x] != word[0]) continue;

            for (directions) |dir_y| {
                const word_end_y = @as(isize, @intCast(y)) + dir_y * (signed_word_len - 1);
                if (word_end_y < 0 or word_end_y >= input_line_count)
                    continue;
                for (directions) |dir_x| {
                    if (dir_x == 0 and dir_y == 0)
                        continue;

                    const word_end_x = @as(isize, @intCast(x)) + dir_x * (signed_word_len - 1);
                    if (word_end_x < 0 or word_end_x >= input_line_width)
                        continue;

                    var is_match = true;
                    for (1..word.len) |i| {
                        const grid_x: usize = @intCast(@as(isize, @intCast(x)) + dir_x * @as(isize, @intCast(i)));
                        const grid_y: usize = @intCast(@as(isize, @intCast(y)) + dir_y * @as(isize, @intCast(i)));
                        is_match = is_match and grid[grid_y][grid_x] == word[i];
                        if (!is_match) break;
                    }

                    if (is_match) result += 1;
                }
            }
        }
    }

    std.debug.print("Result: {d}\n", .{result});
}
