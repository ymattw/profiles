return {
  -- git sign
  {
    "lewis6991/gitsigns.nvim",
    opts = {},
  },

  -- indention
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    opts = {
      scope = { show_start = false, show_end = false },
    },
  },

  -- highlighting other uses of the word under the cursor
  {
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

  -- help remember keymaps
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {},
    keys = {
      {
        "<leader>?",
        function()
          require("which-key").show({ global = false })
        end,
        desc = "Buffer Local Keymaps (which-key)",
      },
    },
  },
}
