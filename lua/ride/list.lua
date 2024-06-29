local M = {}

local build_check_line = function()
    return "- [ ] "
end

local is_check_list = function(s)
    return s:match("^- %[[x ]%]")
end

M._in_check_list = function()
    return is_check_list(vim.api.nvim_get_current_line())
end

M._parse_input = function(s)
    local lines_start, lines_end = s:find("%d+")

    if lines_start == nil or lines_end == nil then
        vim.notify("Could not parse input", vim.log.levels.ERROR)
        return
    end

    local lines_str = s:sub(lines_start, lines_end)
    return tonumber(lines_str)
end

M._make_check_list = function(lines)
    local l = {}

    -- Build list
    for i = 1, lines do
        l[i] = build_check_line()
    end

    -- Write list to buffer
    vim.api.nvim_paste(l:concat("\r"), true, -1)
end

M._toggle_check_list = function()
    local current_line = vim.api.nvim_get_current_line()
    local current = current_line:sub(4, 4)

    -- Change the toggle box on copy of current line
    local replacement = ""
    if current == "x" then
        replacement = " "
    else
        replacement = "x"
    end
    current_line = current_line:sub(1, 3) .. replacement .. current_line:sub(5)

    -- Write change to buffer
    vim.api.nvim_set_current_line(current_line)
end

M._prepend_check_line = function()
    local buf = vim.api.nvim_get_current_buf()
    local pos = vim.api.nvim_win_get_cursor(0)
    vim.api.nvim_buf_set_lines(buf, pos[1] - 1, pos[1], true, { build_check_line(), vim.api.nvim_get_current_line() })
    -- Move cursor to end of prepended line
    vim.api.nvim_win_set_cursor(0, { vim.api.nvim_win_get_cursor(0)[1], 6 })
end

M._append_check_line = function()
    local buf = vim.api.nvim_get_current_buf()
    local pos = vim.api.nvim_win_get_cursor(0)
    vim.api.nvim_buf_set_lines(buf, pos[1] - 1, pos[1], true, { vim.api.nvim_get_current_line(), build_check_line() })
    -- Move cursor to appended line
    vim.api.nvim_win_set_cursor(0, { pos[1] + 1, 6 })
end

return M
