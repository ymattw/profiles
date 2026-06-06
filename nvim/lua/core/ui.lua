-- Interface
vim.opt.mouse = ""
vim.opt.showmatch = true
vim.opt.matchtime = 2
vim.opt.scrolloff = 4
vim.opt.relativenumber = false
vim.opt.list = true
vim.opt.listchars = { tab = "▸ ", trail = "▌", extends = "»", precedes = "«" }
vim.opt.synmaxcol = 150
vim.opt.lazyredraw = true

-- Override pbcopy and force OSC 52
vim.g.clipboard = {
  name = "OSC 52",
  copy = {
    ["+"] = require("vim.ui.clipboard.osc52").copy("+"),
    ["*"] = require("vim.ui.clipboard.osc52").copy("*"),
  },
  paste = {
    ["+"] = require("vim.ui.clipboard.osc52").paste("+"),
    ["*"] = require("vim.ui.clipboard.osc52").paste("*"),
  },
}

if vim.g.neovide then
  vim.o.guifont = "AnonymicePro Nerd Font:h16"
  vim.opt.mouse = "a"
  vim.g.neovide_cursor_trail_size = 0.5
  vim.g.neovide_cursor_animation_length = 0.05
end

-- Cursor
vim.opt.guicursor = {
  "n-v-c-ci-sm:block", -- Block shape for n,v,c modes
  "r-cr:hor20-blinkon500-blinkoff250-blinkwait250",
  "i-o:block-blinkon500-blinkoff250-blinkwait250",
}
vim.opt.cursorline = true

-- Searching
vim.opt.ignorecase = true
vim.opt.incsearch = true
vim.opt.smartcase = true
vim.opt.hlsearch = true
vim.fn.matchadd("IllegalChar", "\\%xa0\\|[“”‘’—]")

-- Editing
-- Tolerate 1 letter diff sign, also fit for python (PEP8)
vim.opt.textwidth = 79
-- Trigger OptionSet event manually
vim.api.nvim_exec_autocmds("OptionSet", { pattern = "textwidth" })
vim.opt.backspace = { "indent", "eol", "start" }
vim.opt.timeoutlen = 2000
vim.opt.ttimeoutlen = 100
vim.opt.isfname:remove("=")
vim.opt.matchpairs:append("<:>")
vim.opt.formatoptions = "tcqron1MBj"
vim.opt.spelllang = { "en_us" }
vim.opt.dictionary:append("~/.vim/dictionary")
-- Do not confuse LSP servers
vim.opt.backup = false
vim.opt.backupdir:remove(".")
vim.opt.swapfile = false

-- Tab
vim.opt.smarttab = true
vim.opt.shiftround = true
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.softtabstop = 4
vim.opt.tabstop = 8

-- Indentation
vim.opt.smartindent = true
vim.opt.autoindent = true
vim.opt.copyindent = true

-- Completion
vim.opt.completeopt = { "menuone", "noselect" }
vim.opt.complete:append({ "kspell", "k~/.vim/dictionary" })
vim.opt.complete:remove(".")
vim.opt.pumheight = 15

-- Command-line completion
vim.opt.wildmenu = true
vim.opt.wildmode = { "longest:full", "full" }

-- Ignore list for file completion
vim.opt.suffixes:append({
  ".a",
  ".so",
  ".la",
  ".class",
  ".pyc",
  ".jpg",
  ".png",
  ".gif",
  ".pdf",
  ".doc",
  ".tar",
  ".tgz",
  ".gz",
  ".bz2",
  ".zip",
})

-- Ignore list for wildmenu completion
vim.opt.wildignore:append({
  ".git",
  "*.o",
  "*.a",
  "*.so",
  "*.la",
  "*.class",
  "*.pyc",
  "*.swp",
  "*.jpg",
  "*.png",
  "*.gif",
  "*.pdf",
  "*.doc",
  "*.tar",
  "*.gz",
  "*.tgz",
  "*.bz2",
  "*.zip",
})

-- Lightweight Todo highlighting (you don't need folke/todo-comments.nvim).
local function setup_todo_highlights()
  for _, match in ipairs(vim.fn.getmatches()) do
    if match.group:match("^Todo") then
      pcall(vim.fn.matchdelete, match.id)
    end
  end
  vim.fn.matchadd("TodoNote", [[\C\<\(NOTE\|INFO\)\>]])
  vim.fn.matchadd("TodoTodo", [[\C\<\(TODO\)\>]])
  vim.fn.matchadd("TodoHack", [[\C\<\(HACK\|XXX\)\>]])
  vim.fn.matchadd("TodoWarn", [[\C\<\(WARN\|WARNING\)\>]])
  vim.fn.matchadd("TodoFixme", [[\C\<\(FIXME\|BUG\|ERROR\)\>]])
end

vim.api.nvim_create_autocmd({ "WinEnter", "BufEnter" }, {
  callback = setup_todo_highlights,
})
