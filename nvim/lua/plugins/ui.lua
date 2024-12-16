local function flags_status()
  local flags = {
    -- See format.lua for how vim.b.format_on_save is defined
    vim.b.format_on_save and "\u{f18f2}" or nil,
    not vim.o.ignorecase and "\u{eab1}" or nil,
    vim.o.paste and "\u{f0192}" or nil,
    vim.bo.fileformat == "dos" and "\u{f05b3}" or nil,
  }
  return table.concat(
    vim.tbl_filter(function(flag)
      return flag
    end, flags),
    " "
  )
end

return {
  -- Tag line
  {
    "akinsho/bufferline.nvim",
    dependencies = "nvim-tree/nvim-web-devicons",
    opts = {
      options = {
        mode = "tabs",
        always_show_bufferline = false,
      },
    },
  },

  -- Status line
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      options = {
        component_separators = { left = nil, right = nil },
      },
      sections = {
        lualine_c = {
          { "filename", path = 1 },
          { flags_status, color = { fg = "#cb4b16" } }, -- solarized orange
        },
        lualine_x = { "encoding", "filetype" },
      },
    },
  },

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

  -- For editing textarea in Chrome/Edge, macOS only
  {
    "glacambre/firenvim",
    enabled = vim.fn.has("mac") == 1,
    build = ":call firenvim#install(0)",
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
