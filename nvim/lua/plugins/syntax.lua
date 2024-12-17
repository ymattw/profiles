return {
  -- syntax parser, to tell the highlight group of text under cursor, use:
  -- :echo synIDattr(synID(line('.'), col('.'), 1), 'name')
  {
    "nvim-treesitter/nvim-treesitter",
  },

  -- highlighting other uses of the word under the cursor
  {
    "RRethy/vim-illuminate",
    config = function()
      require("illuminate").configure({
        delay = 100, -- milliseconds
        filetypes_denylist = { "NvimTree", "TelescopePrompt" },
        providers = { "treesitter", "lsp", "regex" },
        under_cursor = false,
      })
      -- NOTE: colors are dfined in colorscheme.lua
    end,
  },

  -- highlight keywords
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      keywords = {
        TODO = { icon = "\u{f4a0}", color = "info" },
      },
      highlight = {
        pattern = [[.*<(KEYWORDS)>]],
        after = "",
      },
    },
  },
}
