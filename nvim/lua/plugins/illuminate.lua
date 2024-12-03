return {
  "RRethy/vim-illuminate",
  config = function()
    require("illuminate").configure({
      delay = 100, -- milliseconds
      filetypes_denylist = { "NvimTree", "TelescopePrompt" },
      providers = { "lsp", "treesitter", "regex" },
      under_cursor = false,
    })
    vim.api.nvim_set_hl(0, "IlluminatedWordText", { bg = "#334455" })
    vim.api.nvim_set_hl(0, "IlluminatedWordRead", { bg = "#334455" })
    vim.api.nvim_set_hl(0, "IlluminatedWordWrite", { bg = "#334455" })
  end,
}
