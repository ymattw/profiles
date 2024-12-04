local hl = vim.api.nvim_set_hl

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
    local c = require("solarized.palette.solarized-light").solarized

    -- Internal groups
    hl(0, "Constant", { fg = c.cyan })
    hl(0, "Function", { fg = c.base0 })
    hl(0, "Identifier", { fg = c.base0 })
    hl(0, "Keyword", { fg = c.green })
    hl(0, "Parameter", { fg = c.blue })
    hl(0, "Property", { fg = c.base0 })
    hl(0, "Type", { fg = c.base0 })
    hl(0, "Pmenu", { fg = c.base0, bg = c.base02 })
    hl(0, "Search", { fg = c.base02, bg = c.base1 })
    hl(0, "IncSearch", { fg = c.base02, bg = c.base1 })

    -- RRethy/vim-illuminate
    hl(0, "IlluminatedWordText", { fg = c.base1, bg = c.base02, bold = true })
    hl(0, "IlluminatedWordRead", { fg = c.base1, bg = c.base02, bold = true })
    hl(0, "IlluminatedWordWrite", { fg = c.base1, bg = c.base02, bold = true })
  end,
}
