-- Cursor line
vim.api.nvim_create_augroup("ActiveBuffer", { clear = true })
vim.api.nvim_create_autocmd("WinEnter", {
  group = "ActiveBuffer",
  pattern = "*",
  command = "setlocal cursorline",
})
vim.api.nvim_create_autocmd("WinLeave", {
  group = "ActiveBuffer",
  pattern = "*",
  command = "setlocal nocursorline",
})

-- Map enter to set spell, but not for quickfix buffer
vim.api.nvim_create_autocmd("BufWinEnter", {
  pattern = "*",
  callback = function()
    if vim.bo.buftype ~= "quickfix" then
      -- Toggle spell checking with <CR> in normal mode for non-quickfix buffers
      vim.api.nvim_buf_set_keymap(0, "n", "<CR>", ":set spell!<CR>", { noremap = true, silent = true })
    end
  end,
})

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

-- Filetype related autocmds
vim.api.nvim_create_autocmd("BufEnter", {
  pattern = { "*[Mm]akefile*", "[Mm]ake.*", "*.mak", "*.make" },
  callback = function()
    vim.bo.filetype = "make"
    vim.opt_local.expandtab = false
    vim.opt_local.shiftwidth = 8
  end,
})

-- File type tab size settings
vim.api.nvim_create_autocmd("FileType", {
  pattern = {
    "css",
    "eruby",
    "html",
    "jade",
    "javascript",
    "json",
    "lua",
    "ruby",
    "yaml",
  },
  callback = function()
    vim.opt_local.expandtab = true
    vim.opt_local.softtabstop = 2
    vim.opt_local.shiftwidth = 2
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "go",
  callback = function()
    vim.opt_local.expandtab = false
    vim.opt_local.shiftwidth = 8
    vim.opt_local.list = false
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "gitcommit", "markdown" },
  callback = function()
    vim.opt_local.textwidth = 72
    vim.opt_local.spell = true
  end,
})
