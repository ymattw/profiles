return {
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-nvim-lsp-signature-help",
      "hrsh7th/cmp-path",
      "onsails/lspkind-nvim",
      "uga-rosa/cmp-dictionary",
    },

    config = function()
      local cmp = require("cmp")
      local lspkind = require("lspkind")

      require("cmp_dictionary").setup({
        paths = vim.tbl_map(vim.fn.expand, vim.opt.dictionary:get()),
        exact_length = 2,
        first_case_insensitive = true,
      })
      cmp.setup({
        preselect = cmp.PreselectMode.None,
        formatting = {
          format = lspkind.cmp_format({
            mode = "symbol_text",
            maxwidth = 50,
            ellipsis_char = "...",
            show_labelDetails = true,
          }),
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
        sources = cmp.config.sources({
          { name = "buffer" },
          { name = "dictionary" },
          { name = "nvim_lsp" },
          { name = "nvim_lsp_signature_help" },
          { name = "path" },
        }),
      })
    end,
  },
}
