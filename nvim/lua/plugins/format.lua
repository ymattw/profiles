local filetype_formatters = {
  go = { "gofmt" },
  lua = { "stylua" },
  python = { "black" },
}

local filetype_format_on_save_denylist = {
  python = true,
}

local formatters = {}

return {
  "stevearc/conform.nvim",
  event = { "TextChanged", "TextChangedI", "BufWritePre" },
  cmd = { "ConformInfo" },
  keys = {
    {
      "<leader>F",
      function()
        require("conform").format({ async = true })
      end,
      mode = "n",
      desc = "Format buffer",
    },
  },

  ---@module "conform"
  ---@type conform.setupOpts
  opts = {
    -- Define your formatters
    formatters_by_ft = filetype_formatters,
    default_format_opts = {
      lsp_format = "fallback",
    },
    format_on_save = function(bufnr)
      if vim.b.format_on_save then
        return { timeout_ms = 500, lsp_format = "fallback" }
      end
    end,

    formatters = formatters,
  },

  init = function()
    vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
  end,

  config = function(_, opts)
    require("conform").setup(opts)

    -- Initial value
    vim.b.format_on_save = not filetype_format_on_save_denylist[vim.bo.filetype]

    -- Create a new command ToggleFormatOnSave
    vim.api.nvim_create_user_command("ToggleFormatOnSave", function(args)
      vim.b.format_on_save = not vim.b.format_on_save
      vim.notify(string.format("Format on save: %s", tostring(vim.b.format_on_save)), vim.log.levels.WARN)
    end, { desc = "Toggle format on save" })

    -- <leader>uF to trigger ToggleFormatOnSave
    vim.keymap.set("n", "<leader>uF", ":ToggleFormatOnSave<CR>", { desc = "Toggle format on save", noremap = true })
  end,
}
