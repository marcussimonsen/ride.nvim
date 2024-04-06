local M = {}

local DEFAULT_SETTINGS = {
    ---@type boolean Use the default keymaps
    use_default_keymaps = true,
    ---@type boolean Format tables on exit insert mode
    format_table_on_exit_insert = true,
}

local commands = {
    {
        name = "IncreaseHeading",
        desc = "Increase Heading Level",
        func = "increase_heading",
        keys = "<space>l+",
        mode = "n",
    },
    {
        name = "DecreaseHeading",
        desc = "Decrease Heading Level",
        func = "decrease_heading",
        keys = "<space>l-",
        mode = "n",
    },
    {
        name = "MakeTable",
        desc = "Create a Table",
        func = "make_table",
        keys = "<space>lt",
        mode = "n",
    },
    {
        name = "FormatTable",
        desc = "Format a Table",
        func = "format_table",
        keys = "<space>lf",
        mode = "n",
    },
}

M.settings = DEFAULT_SETTINGS

local function merge_settings(opts)
    opts = opts or {}

    local settings = M.settings

    for setting, value in pairs(opts) do
        settings[setting] = value
    end

    return settings
end

M._update_settings = function(opts)
    M.settings = merge_settings(opts)
end

M._set_default_keymaps = function()
    if M.settings.use_default_keymaps then
        local ride = require('ride')
        for _, cmd in ipairs(commands) do
            vim.keymap.set(cmd.mode, cmd.keys, ride[cmd.func], { desc = cmd.desc })
        end
    end
end

M._create_commands = function()
    local ride = require('ride')
    for _, cmd in ipairs(commands) do
        vim.api.nvim_create_user_command(cmd.name, function()
            ride[cmd.func]()
        end, { desc = cmd.desc })
    end
end

M._create_auto_commands = function()
    local ride = require("ride")
    if M.settings.format_table_on_exit_insert then
        vim.api.nvim_create_autocmd({ "InsertLeave" }, { callback = ride["format_table"] })
    end
end

return M
