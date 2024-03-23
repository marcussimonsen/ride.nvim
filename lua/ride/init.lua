local settings = require('ride.settings')
local heading = require('ride.heading')

local M = {}

M.setup = function(opts)
    settings._update_settings(opts)
    settings._create_commands()
    settings._set_default_keymaps()
end

M.increase_heading = function()
    heading._increase_heading_level()
end

M.decrease_heading = function()
    heading._decrease_heading_level()
end

return M
