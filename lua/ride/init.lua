local settings = require('ride.settings')
local ride_heading = require('ride.heading')
local ride_table = require('ride.table')
local ride_list = require('ride.list')

local M = {}

M.setup = function(opts)
    settings._update_settings(opts)
    settings._create_commands()
    settings._create_auto_commands()
    settings._set_default_keymaps()
end

M.increase_heading = function()
    ride_heading._increase_heading_level()
end

M.decrease_heading = function()
    ride_heading._decrease_heading_level()
end

M.make_table = function()
    local input = vim.fn.input("<Columns> <Rows>: ")
    local dimensions = ride_table._parse_input(input)
    if dimensions == nil then
        return;
    end
    ride_table._make_table(dimensions.cols, dimensions.rows)
end

M.format_table = function()
    if ride_table._inside_table() then
        ride_table._format_table()
    end
end

M.prepend_row = function()
    if ride_table._inside_table() then
        ride_table._prepend_row()
    end
end

M.append_row = function()
    if ride_table._inside_table() then
        ride_table._append_row()
    end
end

M.make_check_list = function()
    local input = vim.fn.input("Lines: ")
    local count = ride_list._parse_input(input)
    if count == nil then
        return
    end
    ride_list._make_check_list(count)
end

M.toggle_check_list = function()
    if not ride_list._in_check_list() then
        vim.notify("Not in a check list", vim.log.levels.WARN)
        return
    end
    ride_list._toggle_check_list()
end

M.prepend_check_line = function()
    ride_list._prepend_check_line()
end

M.append_check_line = function()
    ride_list._append_check_line()
end

return M
