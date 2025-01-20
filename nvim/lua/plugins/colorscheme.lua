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

    -- Overrides. Too many colors is distracting. To tell the highlight group
    -- of text under cursor, use :Inspect
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

    hl(0, "@lsp.mod.defaultLibrary", { fg = e.darken(c.green, 10) })
    hl(0, "@lsp.typemod.function.defaultLibrary", { fg = e.darken(c.green, 20) })
    hl(0, "@lsp.typemod.method.declaration", { fg = c.blue })
    hl(0, "@lsp.typemod.parameter", { fg = c.base0, italic = true })
    hl(0, "@lsp.type.parameter", { link = "@lsp.typemod.parameter" })
    hl(0, "@lsp.type.interface", { link = "Normal" })
    hl(0, "@lsp.type.type", { link = "Keyword" })

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
    hl(0, "Pmenu", { fg = c.base1, bg = e.lighten(c.base02, 10) })
    hl(0, "Search", { fg = c.base02, bg = c.yellow })
    hl(0, "SpellBad", { underline = true })
    hl(0, "TabLineSel", { fg = c.base2, bg = c.orange })

    -- Customization
    hl(0, "CharExceedsWidth", { link = "WarningMsg" })
    hl(0, "IllegalChar", { link = "ErrorMsg" })

    -- RRethy/vim-illuminate
    hl(0, "IlluminatedWordText", { bg = e.lighten(c.base03, 20), bold = true })
    hl(0, "IlluminatedWordRead", { bg = e.lighten(c.base03, 20), bold = true })
    hl(0, "IlluminatedWordWrite", { bg = e.lighten(c.base03, 20), bold = true })
  end,
}
