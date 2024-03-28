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

return M
