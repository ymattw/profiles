local hl = vim.api.nvim_set_hl

return {
  "maxmx03/solarized.nvim",
  priority = 1000,
  opts = {},
  config = function(_, opts)
    vim.opt.termguicolors = true
    vim.opt.background = vim.g.neovide and "light" or "dark"
    require("solarized").setup(opts)
    vim.cmd.colorscheme("solarized")

    -- Overrides. Too many colors is distracting. To tell the highlight group
    -- of text under cursor, use :Inspect
    local p = vim.o.background == "dark" and "solarized.palette" or "solarized.palette.solarized-light"
    local c = require(p).solarized
    local e = require("solarized.color") -- effects

    -- Syntax groups
    hl(0, "Constant", { fg = c.cyan })
    hl(0, "Function", { fg = c.base0 })
    hl(0, "Identifier", { fg = c.base0 })
    hl(0, "Keyword", { fg = c.green })
    hl(0, "Parameter", { fg = e.darken(c.blue, 10) })
    hl(0, "Property", { fg = c.base0 })
    hl(0, "Special", { fg = c.violet })
    hl(0, "Type", { fg = c.base0 })

    hl(0, "@lsp.mod.defaultLibrary", { fg = e.darken(c.green, 10) })
    hl(0, "@lsp.typemod.function.defaultLibrary", { fg = e.darken(c.green, 20) })
    hl(0, "@lsp.typemod.method.declaration", { fg = c.blue })
    hl(0, "@lsp.typemod.parameter", { fg = c.base0, italic = true })
    hl(0, "@lsp.type.parameter", { link = "@lsp.typemod.parameter" })
    hl(0, "@lsp.type.interface", { fg = c.base0 })
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
    
    -- Custom Todo Highlights
    hl(0, "TodoNote", { fg = c.base03, bg = c.green, bold = true })
    hl(0, "TodoTodo", { fg = c.base03, bg = c.blue, bold = true })
    hl(0, "TodoHack", { fg = c.base03, bg = c.orange, bold = true })
    hl(0, "TodoWarn", { fg = c.base03, bg = c.yellow, bold = true })
    hl(0, "TodoFixme", { fg = c.base03, bg = c.red, bold = true })

    -- Native LSP documentHighlight
    hl(0, "LspReferenceText", { bg = e.lighten(c.base03, 20), bold = true })
    hl(0, "LspReferenceRead", { bg = e.lighten(c.base03, 20), bold = true })
    hl(0, "LspReferenceWrite", { bg = e.lighten(c.base03, 20), bold = true })

    if vim.g.neovide then
      hl(0, "Pmenu", { bg = c.base1, fg = c.base02 })
      hl(0, "LspReferenceText", { fg = c.base03, bold = true })
      hl(0, "LspReferenceRead", { fg = c.base03, bold = true })
      hl(0, "LspReferenceWrite", { fg = c.base03, bold = true })
    end
  end,
}
