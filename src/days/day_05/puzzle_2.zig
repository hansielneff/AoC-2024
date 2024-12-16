const std = @import("std");

const input = @embedFile("input.txt");
const input_line_count = blk: {
    @setEvalBranchQuota(0x8000);
    break :blk std.mem.count(u8, input, "\n") + 1;
};

pub fn solve() !void {
    var result: u32 = 0;

    var page_map = std.AutoArrayHashMap(u8, std.ArrayList(u8)).init(std.heap.page_allocator);
    defer page_map.deinit();

    var it_line = std.mem.tokenizeScalar(u8, input, '\n');
    while (it_line.peek()) |tkn| {
        if (std.mem.indexOfScalar(u8, tkn, '|') == null) break;
        _ = it_line.next();
        var it_num = std.mem.tokenizeScalar(u8, tkn, '|');
        const page_1 = std.fmt.parseUnsigned(u8, it_num.next().?, 10) catch unreachable;
        const page_2 = std.fmt.parseUnsigned(u8, it_num.next().?, 10) catch unreachable;
        if (!page_map.contains(page_2))
            try page_map.put(page_2, std.ArrayList(u8).init(std.heap.page_allocator));
        try page_map.getPtr(page_2).?.append(page_1);
    }

    var updates = std.ArrayList(std.ArrayList(u8)).init(std.heap.page_allocator);
    defer updates.deinit();

    while (it_line.next()) |tkn| {
        var it_num = std.mem.tokenizeScalar(u8, tkn, ',');
        try updates.append(std.ArrayList(u8).init(std.heap.page_allocator));
        while (it_num.next()) |num_str| {
            const num = std.fmt.parseUnsigned(u8, num_str, 10) catch unreachable;
            try updates.items[updates.items.len - 1].append(num);
        }
    }

    var forbidden_pages = std.ArrayList(u8).init(std.heap.page_allocator);
    defer forbidden_pages.deinit();
    for (updates.items) |update| {
        var is_wrong_order = false;
        var was_wrong_order: ?bool = null;
        while (was_wrong_order == null or is_wrong_order) {
            is_wrong_order = false;
            if (was_wrong_order == null)
                was_wrong_order = false;
            forbidden_pages.clearRetainingCapacity();
            outer_loop: for (update.items, 0..) |page, i| {
                for (forbidden_pages.items) |forbidden| {
                    if (page == forbidden) {
                        is_wrong_order = true;
                        was_wrong_order = true;
                        std.debug.assert(i != 0);
                        std.mem.swap(u8, &update.items[i], &update.items[i - 1]);
                        break :outer_loop;
                    }
                }
                if (!page_map.contains(page)) continue;
                try forbidden_pages.appendSlice(page_map.get(page).?.items);
            }
        }

        if (was_wrong_order != null and was_wrong_order.?)
            result += update.items[update.items.len / 2];
    }

    std.debug.print("Result: {d}\n", .{result});
}
