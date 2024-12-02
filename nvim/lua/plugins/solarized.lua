return {
  "maxmx03/solarized.nvim",
  lazy = false,
  priority = 1000,
  opts = {},
  config = function(_, opts)
    vim.opt.termguicolors = true
    vim.opt.background = "dark"
    require("solarized").setup(opts)
    vim.cmd.colorscheme("solarized")
  end,
}
