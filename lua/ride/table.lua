local M = {}

local function make_row(cols, fill)
    local line = "|"
    local cell = fill .. fill .. fill
    for _ = 1, cols do
        line = line .. cell .. "|"
    end
    return line
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

M._make_table = function(cols, rows)
    local t = {}

    -- Make header row
    t[1] = make_row(cols, " ")
    t[2] = make_row(cols, "-")

    -- Make the rest of the rows
    for i = 3, rows + 1 do
        t[i] = make_row(cols, " ")
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

local function repeated(str, n)
    local res = ""
    for _ = 1, n, 1 do
        res = res .. str
    end
    return res
end

M._format_table = function()
    local cursor_pos = vim.api.nvim_win_get_cursor(vim.api.nvim_get_current_win())
    local buf = vim.api.nvim_get_current_buf()
    local top = get_top_row(buf, cursor_pos)
    local bottom = get_bottom_row(buf, cursor_pos)
    local lines = vim.api.nvim_buf_get_lines(buf, top, bottom, true)

    lines = remove_until(lines, "|")

    -- Find contents and width of the widest cell content for each column
    local column_widths = {}
    local contents = {}
    for i, _ in ipairs(lines) do
        contents[i] = {}
    end
    local x = 1
    while lines[1] ~= "" do
        column_widths[x] = 0
        for y, line in ipairs(lines) do
            if y == 2 then
                goto continue
            end
            local content_end, _ = string.find(line, "%s*|")
            content_end = content_end - 1
            local _, _, content = string.find(string.sub(line, 1, content_end), "%s*(.*)")
            contents[y][x] = content
            column_widths[x] = math.max(column_widths[x], #content)
            ::continue::
        end
        x = x + 1
        lines = remove_until(lines, "|")
    end

    -- Build formatted table
    for y, row in ipairs(contents) do
        lines[y] = "|"
        if y == 2 then
            for _, width in pairs(column_widths) do
                lines[y] = lines[y] .. repeated("-", width + 2) .. "|"
            end
            goto continue
        end
        for x, content in pairs(row) do
            lines[y] = lines[y] .. " " .. content .. repeated(" ", column_widths[x] - #content) .. " |"
        end
        ::continue::
    end

    vim.api.nvim_buf_set_lines(buf, top, bottom, true, lines)
end

return M
