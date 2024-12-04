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

local specs = {
  { import = "plugins" },
}

-- Load the work plugin named after $WORK_PROFILE, if exists
if vim.env.WORK_PROFILE then
  local ok, plugins = pcall(require, string.format("plugins.%s", vim.env.WORK_PROFILE))
  if ok then
    for _, spec in ipairs(plugins) do
      table.insert(specs, spec)
    end
  end
end

-- Setup lazy and load plugins
require("lazy").setup({
  spec = specs,
  defaults = {
    lazy = false,
    version = "*", -- try installing the latest semver version
  },
  -- automatically check for plugin updates
  checker = {
    enabled = true,
    notify = false,
  },
  change_detection = {
    notify = false,
  },
  performance = {
    rtp = {
      -- disable some rtp plugins
      disabled_plugins = {
        "gzip",
        "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})
