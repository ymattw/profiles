vim.g.mapleader = " "

local map = vim.keymap.set

-- Main interface
map("n", "<BS>", ":set ic!<CR>", { desc = "Toggle ignore case" })
map("n", "<C-H>", ":set hlsearch!<CR>", { desc = "Toggle highlight search" })
map("n", "<C-J>", "<C-W>w", { desc = "Cycle to next window" })
map("n", "<C-K>", ":%s/\\s\\+$//<CR>", { desc = "Remove trailing blanks" })
map("n", "<C-N>", ":set number!<CR>", { desc = "Toggle line number" })
map("n", "<C-P>", ":set paste!<CR>", { desc = "Toggle paste mode" })
-- NOTE: <CR> is mapped to toggle spelling conditionally ini autocmds.lua

map("n", "_", ":silent! set cursorline!<CR>", { desc = "Toggle cursorline" })
map("n", "|", ":silent! set cursorcolumn!<CR>", { desc = "Toggle cursorcolumn" })
map("n", "q:", ":q", { desc = "Make q: less boring" })
map("n", "!!", ":q!<CR>", { desc = "Quit without saving" })
map("n", "Q", "gqip", { desc = "Format current paragraph" })
map("n", "qq", ":q<CR>", { desc = "Quickly close current window" })
map("n", "qa", ":qa<CR>", { desc = "Quickly close all windows" })

map("n", "<leader>2", ":set et sts=2 sw=2<CR>", { desc = "Use 2-space indention" })
map("n", "<leader>4", ":set et sts=4 sw=4<CR>", { desc = "Use 4-space indention" })
map("n", "<Leader>d", ":cd %:h<CR>:pwd<CR>", { desc = "Switch to dir of current file" })
map("n", "<Leader>-", ":cd -<CR>:pwd<CR>", { desc = "Switch back to previous dir" })
map("n", "<Leader>f", "<C-w>gf", { desc = "Open file under cursor in new tab" })
map("n", "<leader>q", ":qall<CR>", { desc = "Quickly quit vim" })
map("n", "<leader>s", ":Ack! -w <cword><CR>", { desc = "Quick search word under cursor" })
map("n", "<Leader>t", "<C-w><C-]><C-w>T", { desc = "Open tag in new tab" })
map("n", "<leader>w", ":w<CR>", { desc = "Save 2 keystrokes" })
map("n", "<leader><CR>", ":set wrap!<CR>", { desc = "Toggle wrapping" })

-- Tabs
map("n", "<leader>e", ":tabedit ", { desc = "Tab edit new file" })
-- TODO: there must be a way to auto feed Tab
map("n", "<leader>E", ":tabedit %:h/", { desc = "Tab edit file in dir of current file" })
map("n", "<leader>h", ":tabprevious<CR>", { desc = "Previous Tab" })
map("n", "<leader>l", ":tabnext<CR>", { desc = "Next Tab" })

-- When select+yank, copy to the system clipboard
vim.api.nvim_set_keymap("v", "y", '"+y', { noremap = true, silent = true })

function ToggleTab()
  if vim.bo.expandtab then
    vim.cmd("setlocal noet sw=8")
  else
    vim.cmd("setlocal et sw=" .. vim.bo.shiftwidth)
  end
end

function ToggleColorColumn()
  if vim.wo.colorcolumn == "" then
    vim.cmd("setlocal colorcolumn=+1")
  else
    vim.cmd("setlocal colorcolumn=")
  end
end

map("n", "<leader>|", ":lua ToggleColorColumn()<CR>", { desc = "Toggle color column" })
map("n", "<leader><Tab>", ":lua ToggleTab()<CR>", { desc = "Toggle between spaces and tabs" })

map("n", "<leader>y", function()
  vim.cmd("term ydiff " .. vim.fn.expand("%"))
end, { desc = "Run ydiff on current file" })
map("n", "<leader>Y", ":term ydiff<CR>", { desc = "Run ydiff on unstaged changes" })

-- Maps for insert mode
map("i", "<C-J>", "<ESC>kJA", { desc = "Join to prev line (undo auto wrap)" })
map("i", "<C-A>", "<C-O>I", { desc = "Emacs style Home" })
map("i", "<C-E>", "<C-O>A", { desc = "Emacs style End" })
map("i", "<C-F>", "<C-X><C-F>", { desc = "Complete filename" })
map("i", "<C-K>", "<C-X><C-K>", { desc = "Complete spell from words" })

-- Maps for command mode
map("c", "w!!", "w !sudo tee % > /dev/null", { desc = "Write file as sudo" })

-- Diff mode mappings
if vim.o.diff then
  map("n", "qq", ":qa<CR>", { desc = "Close all windows" })
  map("n", "<Up>", "[c", { desc = "Previous change" })
  map("n", "<Down>", "]c", { desc = "Next change" })
  map("n", "<Left>", "<C-w>h", { desc = "Left window" })
  map("n", "<Right>", "<C-w>l", { desc = "Right window" })
  map("n", "<C-L>", ":diffupdate<CR>", { desc = "Refresh diff" })
else
  map("n", "<Up>", "<C-w>k", { desc = "Upper window" })
  map("n", "<Down>", "<C-w>j", { desc = "Bottom window" })
  map("n", "<Left>", ":tabprevious<CR>", { desc = "Previous tab" })
  map("n", "<Right>", ":tabnext<CR>", { desc = "Next tab" })
end
