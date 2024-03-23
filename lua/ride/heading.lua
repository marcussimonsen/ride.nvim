local M = {}

M._increase_heading_level = function()
    vim.print("increase inside heading")
end

M._decrease_heading_level = function()
    vim.print("descrease inside heading")
end

return M
