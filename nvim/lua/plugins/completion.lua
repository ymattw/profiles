return {
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-nvim-lsp-signature-help",
      "hrsh7th/cmp-path",
      "uga-rosa/cmp-dictionary",
    },

    config = function()
      require("cmp_dictionary").setup({
        paths = vim.tbl_map(vim.fn.expand, vim.opt.dictionary:get()),
        exact_length = 2,
        first_case_insensitive = true,
      })

      -- Native replacement for onsails/lspkind.nvim icons
      local kind_icons = {
        Class = "󰠱",
        Color = "󰏘",
        Constant = "󰏿",
        Constructor = "",
        Enum = "",
        EnumMember = "",
        Event = "",
        Field = "󰜢",
        File = "󰈙",
        Folder = "󰉋",
        Function = "󰊕",
        Interface = "",
        Keyword = "󰌋",
        Method = "󰆧",
        Module = "",
        Operator = "󰆕",
        Property = "󰜢",
        Reference = "󰈇",
        Snippet = "",
        Struct = "󰙅",
        Text = "",
        TypeParameter = "󰊄",
        Unit = "󰑭",
        Value = "󰎠",
        Variable = "󰀫",
      }
      local cmp = require("cmp")

      local source_mapping = {
        buffer = "[Buffer]",
        dictionary = "[Dict]",
        nvim_lsp = "[LSP]",
        nvim_lsp_signature_help = "[Signature]",
        path = "[Path]",
      }

      cmp.setup({
        preselect = cmp.PreselectMode.None,
        formatting = {
          format = function(entry, item)
            item.kind = kind_icons[item.kind] or "?"
            item.menu = source_mapping[entry.source.name] or entry.source.name
            return item
          end,
        },
        mapping = {
          ["<Tab>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
          ["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
          ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
          ["<C-space>"] = pcall(require, "minuet") and require("minuet").make_cmp_map() or nil,
        },
        experimental = {
          ghost_text = true,
        },
        -- Global default for all sources
        completion = {
          keyword_length = 2,
        },
        sources = cmp.config.sources({ -- Order matters
          { name = "nvim_lsp" },
          { name = "nvim_lsp_signature_help" },
          { name = "buffer" },
          { name = "dictionary" },
          { name = "path" },
        }),
      })
    end,
  },
}
