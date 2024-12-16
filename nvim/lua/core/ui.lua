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

-- Cursor
vim.opt.guicursor = {
  "n-v-c-ci-sm:block", -- Block shape for n,v,c modes
  "r-cr:hor20-blinkon500-blinkoff250-blinkwait250",
  "i-o:block-blinkon500-blinkoff250-blinkwait250",
}
vim.opt.cursorline = true

-- Coloring
vim.api.nvim_set_hl(0, "ColorColumn", { link = "Search" })
vim.api.nvim_set_hl(0, "CharExceedsWidth", { link = "WarningMsg" })
vim.api.nvim_set_hl(0, "IllegalChar", { link = "ErrorMsg" })

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

-- Tab
vim.opt.smarttab = true
vim.opt.shiftround = true
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.softtabstop = 4
vim.opt.tabstop = 8
vim.opt.smartindent = true
vim.opt.autoindent = true
vim.opt.copyindent = true

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
