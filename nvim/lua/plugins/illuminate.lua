return {
  "RRethy/vim-illuminate",
  config = function()
    require("illuminate").configure({
      delay = 100, -- milliseconds
      filetypes_denylist = { "NvimTree", "TelescopePrompt" },
      providers = { "lsp", "treesitter", "regex" },
      under_cursor = false,
    })
    -- NOTE: colors are dfined in colorscheme.lua
  end,
}
