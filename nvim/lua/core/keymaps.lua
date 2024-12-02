vim.g.mapleader = " "

-- Main interface
vim.keymap.set("n", "<BS>", ":set ic!<CR>", { desc = "Toggle ignore case" })
vim.keymap.set("n", "<C-H>", ":set hlsearch!<CR>", { desc = "Toggle highlight search" })
vim.keymap.set("n", "<C-J>", "<C-W>w", { desc = "Cycle to next window" })
vim.keymap.set("n", "<C-K>", ":%s/[ \t]+$//<CR>", { desc = "Remove trailing blanks" })
vim.keymap.set("n", "<C-N>", ":set number!<CR>", { desc = "Toggle line number" })
vim.keymap.set("n", "<C-P>", ":set paste!<CR>", { desc = "Toggle paste mode" })

-- Tabs
vim.keymap.set("n", "<leader>e", ":tabedit ", { desc = "Tab edit new file" })
vim.keymap.set("n", "<leader>E", ":tabedit %:h/<tab>", { desc = "Tab edit file in cwd" })
vim.keymap.set("n", "<leader>h", ":tabprevious<CR>", { desc = "Previous Tab" })
vim.keymap.set("n", "<leader>l", ":tabnext<CR>", { desc = "Next Tab" })
