local M = {}

local function make_array(size, fill)
    local arr = {}
    for i = 1, size do
        arr[i] = fill
    end
    return arr
end

M._parse_input = function(s)
    local cols_start, cols_end = string.find(s, "^%d+")
    local rows_start, rows_end = string.find(s, "%d+$")
    if cols_start == nil or cols_end == nil or rows_start == nil or rows_end == nil then
        vim.notify("Could not parse input", vim.log.levels.ERROR)
        return;
    end
    local cols = string.sub(s, cols_start, cols_end)
    local rows = string.sub(s, rows_start, rows_end)
    return {
        cols = tonumber(cols),
        rows = tonumber(rows),
    }
end

local function repeated(str, n)
    local res = ""
    for _ = 1, n, 1 do
        res = res .. str
    end
    return res
end

local function build_line(row, widths)
    local line = "|"
    for x, content in pairs(row) do
        line = line .. " " .. content .. repeated(" ", widths[x] - #content) .. " |"
    end
    return line
end

M._make_table = function(cols, rows)
    local t = {}
    local widths = make_array(cols, 1)

    -- Make header row
    t[1] = build_line(make_array(cols, " "), widths)
    t[2] = build_line(make_array(cols, "-"), widths)

    -- Make the rest of the rows
    for i = 3, rows + 1 do
        t[i] = make_array(cols, " ")
    end

    -- Write table to buffer
    vim.api.nvim_paste(table.concat(t, "\r"), true, -1)
end

local function is_table(s)
    return string.match(s, "^|.*|$")
end

M._inside_table = function()
    return is_table(vim.api.nvim_get_current_line())
end

local function get_top_row(buf, cursor)
    local i = cursor[1]
    while i ~= 0 and is_table(vim.api.nvim_buf_get_lines(buf, i - 1, i, true)[1]) do
        i = i - 1
    end
    return i
end

local function get_bottom_row(buf, cursor)
    local buf_bottom = vim.api.nvim_buf_line_count(buf)
    local i = cursor[1]
    while i ~= buf_bottom and is_table(vim.api.nvim_buf_get_lines(buf, i, i + 1, true)[1]) do
        i = i + 1
    end
    return i
end

local function remove_until(lines, pattern)
    local new_lines = {}
    for i, line in ipairs(lines) do
        local idx_start, idx_end = string.find(line, pattern)
        if idx_start == nil or idx_end == nil then return {} end
        new_lines[i] = string.sub(line, idx_end + 1)
    end
    return new_lines
end

local function read_table(buf, pos)
    local top = get_top_row(buf, pos)
    local bottom = get_bottom_row(buf, pos)
    local lines = vim.api.nvim_buf_get_lines(buf, top, bottom, true)
    return lines
end

local function extract_content(lines)
    -- Initialize table
    local contents = {}
    for i = 1, #lines do
        contents[i] = {}
    end

    -- Extract contents for each cell in the table
    lines = remove_until(lines, "|")
    local x = 1
    while lines[1] ~= "" do
        for y, line in ipairs(lines) do
            if y == 2 then
                goto continue
            end
            local content_end, _ = string.find(line, "%s*|")
            content_end = content_end - 1
            local _, _, content = string.find(string.sub(line, 1, content_end), "%s*(.*)")
            contents[y][x] = content
            ::continue::
        end
        x = x + 1
        lines = remove_until(lines, "|")
    end

    return contents
end

local function find_widest_columns(t)
    -- Initialize table
    local widths = make_array(#t[1], 0)
    -- Actually find widest cells
    for y = 1, #t do
        for x = 1, #t[y] do
            widths[x] = math.max(widths[x], #t[y][x])
        end
    end

    return widths
end

local function build_table(t, widths)
    local lines = {}
    for y, row in ipairs(t) do
        -- Ignore second column which is always: |---|---|---| ...
        if y == 2 then
            lines[y] = "|"
            for _, width in pairs(widths) do
                lines[y] = lines[y] .. repeated("-", width + 2) .. "|"
            end
            goto continue
        end

        -- Build formatted line
        lines[y] = build_line(row, widths)
        ::continue::
    end

    return lines
end

M._format_table = function()
    local cursor_pos = vim.api.nvim_win_get_cursor(vim.api.nvim_get_current_win())
    local buf = vim.api.nvim_get_current_buf()
    local top = get_top_row(buf, cursor_pos)
    local bottom = get_bottom_row(buf, cursor_pos)
    local lines = read_table(buf, cursor_pos)

    local contents = extract_content(lines)

    local widths = find_widest_columns(contents)

    lines = build_table(contents, widths)

    vim.api.nvim_buf_set_lines(buf, top, bottom, true, lines)
end

local function count_columns(line)
    -- Two lines needed so variable is convertable to 'integer|nil'
    local i
    i = 1
    local columns = 0

    while i < #line do
        i = i + 1
        local start, _ = string.find(line, "|", i)
        i = start
        columns = columns + 1
    end
    return columns
end

M._prepend_row = function()
    local buf = vim.api.nvim_get_current_buf()
    local cursor_pos = vim.api.nvim_win_get_cursor(vim.api.nvim_get_current_win())
    local current_line = vim.api.nvim_get_current_line()
    local cols = count_columns(current_line)
    local widths = find_widest_columns(extract_content(read_table(buf, cursor_pos)))

    local new_lines = {
        build_line(make_array(cols, " "), widths),
        current_line,
    }

    vim.api.nvim_buf_set_lines(buf, cursor_pos[1] - 1, cursor_pos[1], true, new_lines)
end

M._append_row = function()
    local buf = vim.api.nvim_get_current_buf()
    local cursor_pos = vim.api.nvim_win_get_cursor(vim.api.nvim_get_current_win())
    local current_line = vim.api.nvim_get_current_line()
    local cols = count_columns(current_line)
    local widths = find_widest_columns(extract_content(read_table(buf, cursor_pos)))

    local new_lines = {
        current_line,
        build_line(make_array(cols, " "), widths),
    }

    vim.api.nvim_buf_set_lines(buf, cursor_pos[1] - 1, cursor_pos[1], true, new_lines)
end

return M
