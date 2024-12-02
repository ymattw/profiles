-- Restore the last cursor position when reopening a file
vim.api.nvim_create_autocmd("BufReadPost", {
    callback = function()
        local last_position = vim.fn.line("'\"")
        if last_position > 0 and last_position <= vim.fn.line("$") then
            vim.api.nvim_win_set_cursor(0, { last_position, 0 })
        end
    end,
    desc = "Restore last cursor position",
})
