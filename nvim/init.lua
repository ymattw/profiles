-- Load core settings
require("core.autocmds")
require("core.keymaps")
require("core.ui")

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

local specs = {
  { import = "plugins" },
}

-- Load the work plugin named after $WORK_PROFILE, if exists
if vim.env.WORK_PROFILE then
  local plugin_path = string.format("plugins.%s", vim.env.WORK_PROFILE)
  local ok, plugins = pcall(require, plugin_path)
  if ok then
    for _, spec in ipairs(plugins) do
      table.insert(specs, spec)
    end
  else
    vim.api.nvim_echo({ { "Plugin not found for WORK_PROFILE=" .. vim.env.WORK_PROFILE, "ErrorMsg" } }, true, {})
    vim.fn.getchar()
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
