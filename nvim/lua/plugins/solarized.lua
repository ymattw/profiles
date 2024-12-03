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

    -- Overrides. Too many colors is distracting.
    vim.api.nvim_set_hl(0, "Constant", { fg = "#2aa198" }) -- cyan
    vim.api.nvim_set_hl(0, "Function", { fg = "#839496" }) -- base0 grey
    vim.api.nvim_set_hl(0, "Identifier", { fg = "#839496" }) -- base0 grey
    vim.api.nvim_set_hl(0, "Keyword", { fg = "#859900" }) -- green
    vim.api.nvim_set_hl(0, "Parameter", { fg = "#268bd2" }) -- blue
    vim.api.nvim_set_hl(0, "Property", { fg = "#839496" }) -- base0 grey
    vim.api.nvim_set_hl(0, "Type", { fg = "#839496" }) -- base0 grey
  end,
}
