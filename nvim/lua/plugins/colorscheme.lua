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
    local e = require("solarized.color") -- effects

    -- Syntax groups
    hl(0, "Constant", { fg = c.cyan })
    hl(0, "Function", { link = "Normal" })
    hl(0, "Identifier", { link = "Normal" })
    hl(0, "Keyword", { fg = c.green })
    hl(0, "Parameter", { fg = e.darken(c.blue, 10) })
    hl(0, "Property", { link = "Normal" })
    hl(0, "Special", { fg = c.violet })
    hl(0, "Type", { link = "Normal" })

    -- Diff mode
    hl(0, "DiffDelete", { fg = c.base01, bg = c.base02 })
    hl(0, "DiffAdd", { fg = c.green, bg = c.base02, bold = true })
    hl(0, "DiffChange", { fg = c.yellow, bg = c.base02 })
    hl(0, "DiffText", { fg = c.yellow, bg = c.base02, bold = true, underline = true })

    -- Other internal groups
    hl(0, "ColorColumn", { link = "Search" })
    hl(0, "CursorColumn", { bg = c.base02 })
    hl(0, "IncSearch", { fg = c.base02, bg = c.orange })
    hl(0, "MatchParen", { fg = c.base2 })
    hl(0, "NormalFloat", { link = "Pmenu" })
    hl(0, "Pmenu", { fg = c.base1, bg = c.base02 })
    hl(0, "Search", { fg = c.base02, bg = c.yellow })

    -- RRethy/vim-illuminate
    hl(0, "IlluminatedWordText", { link = "MatchParen" })
    hl(0, "IlluminatedWordRead", { link = "MatchParen" })
    hl(0, "IlluminatedWordWrite", { link = "MatchParen" })
  end,
}
