const std = @import("std");

const input = @embedFile("input.txt");
const input_line_count = blk: {
    @setEvalBranchQuota(0x8000);
    break :blk std.mem.count(u8, input, "\n") + 1;
};

pub fn solve() void {
    var result: u32 = 0;

    var mul_enabled = true;
    var it_line = std.mem.tokenizeScalar(u8, input, '\n');
    while (it_line.next()) |tkn| {
        var i: usize = 0;
        while (i < tkn.len) {
            if (tkn.len - i < "mul(x,y)".len) break;
            defer i += 1;

            if (std.mem.eql(u8, tkn[i .. i + 4], "do()")) {
                mul_enabled = true;
                i += 4;
            }

            if (std.mem.eql(u8, tkn[i .. i + 7], "don't()")) {
                mul_enabled = false;
                i += 7;
            }

            if (!std.mem.eql(u8, tkn[i .. i + 4], "mul(")) continue;
            i += 4;
            var digit_count = countDigits(tkn[i .. i + 3]);
            if (digit_count < 1 or digit_count > 3) continue;
            const lhs = std.fmt.parseUnsigned(u32, tkn[i .. i + digit_count], 10) catch unreachable;
            i += digit_count;
            if (tkn[i] != ',') continue;
            i += 1;
            digit_count = countDigits(tkn[i .. i + 3]);
            const rhs = std.fmt.parseUnsigned(u32, tkn[i .. i + digit_count], 10) catch unreachable;
            if (digit_count < 1 or digit_count > 3) continue;
            i += digit_count;
            if (tkn[i] != ')') continue;
            result += if (mul_enabled) lhs * rhs else 0;
        }
    }

    std.debug.print("Result: {d}\n", .{result});
}

fn countDigits(str: []const u8) u32 {
    var result: u32 = 0;
    for (str) |c| {
        if (std.ascii.isDigit(c)) {
            result += 1;
        } else {
            break;
        }
    }
    return result;
}
