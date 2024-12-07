-- Formatting behavior.
--
-- NOTE: plugin file basename determines the lazy loading order. So to override
-- the formatting behavior, define a plugin with file basename comes after
-- "format" (eg. format-xxx.lua), then override the opts function. Example:
--
-- local format_on_save_fts = ...
-- local formatters_by_ft = ...
-- local formatters = ...
--
-- return {
--   "stevearc/conform.nvim",
--   opts = function(_, opts)
--     vim.b.format_on_save = format_on_save_fts[vim.bo.filetype]
--     opts.formatters_by_ft = formatters_by_ft
--     opts.formatters = formatters
--     return opts
--   end,
-- }

local format_on_save_fts = {
  go = true,
  lua = true,
}

local formatters_by_ft = {
  go = { "gofmt" },
  lua = { "stylua" },
  python = { "black" },
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

  opts = function(_, opts)
    vim.b.format_on_save = format_on_save_fts[vim.bo.filetype]
    opts.formatters_by_ft = formatters_by_ft
    opts.formatters = formatters
    opts.default_format_opts = { lsp_format = "fallback" }

    opts.format_on_save = function(bufnr)
      if vim.b.format_on_save then
        return { timeout_ms = 500 }
      end
    end
    return opts
  end,

  config = function(_, opts)
    require("conform").setup(opts)

    -- Create a new command ToggleFormatOnSave
    vim.api.nvim_create_user_command("ToggleFormatOnSave", function(args)
      vim.b.format_on_save = not vim.b.format_on_save
      vim.notify(string.format("Format on save: %s", tostring(vim.b.format_on_save)), vim.log.levels.WARN)
    end, { desc = "Toggle format on save" })

    -- <leader>uF to trigger ToggleFormatOnSave
    vim.keymap.set("n", "<leader>uF", ":ToggleFormatOnSave<CR>", { desc = "Toggle format on save", noremap = true })
  end,
}
