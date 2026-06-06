-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "--branch=stable",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Setup lazy and load plugins
require("lazy").setup({
  spec = { import = "plugins" },
  defaults = {
    lazy = false,
    version = "*", -- try installing the latest semver version
  },
  -- automatically check for plugin updates
  checker = {
    enabled = false,
  },
  change_detection = {
    enabled = false,
  },
  performance = {
    rtp = {
      -- disable some rtp plugins
      disabled_plugins = {
        "gzip",
        "netrwPlugin",
        "rplugin",
        "spellfile_plugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})
