local M = {}

M._increase_heading_level = function()
    -- Get line, position and buffer
    local r, _ = unpack(vim.api.nvim_win_get_cursor(vim.api.nvim_get_current_win()))
    local line = vim.api.nvim_get_current_line()
    local buf = vim.api.nvim_get_current_buf()

    -- Modify line
    -- If line is not already a header, add space
    if string.sub(line, 1, 1) ~= "#" then
        line = " " .. line
    end
    -- Add a '#' to start of line
    line = "#" .. line

    -- Write to buffer
    vim.api.nvim_buf_set_lines(buf, r - 1, r, true, { line })
end

M._decrease_heading_level = function()
    -- Get line, position and buffer
    local r, _ = unpack(vim.api.nvim_win_get_cursor(vim.api.nvim_get_current_win()))
    local line = vim.api.nvim_get_current_line()
    local buf = vim.api.nvim_get_current_buf()

    -- Modify line
    -- If H1, remove space as well
    if string.sub(line, 1, 2) == "# " then
        line = string.sub(line, 3)
    elseif string.sub(line, 1, 1) == "#" then
        line = string.sub(line, 2)
    else
        vim.notify("Line is not a header", vim.log.levels.ERROR)
    end

    -- Write to buffer
    vim.api.nvim_buf_set_lines(buf, r - 1, r, true, { line })
end

return M
