-- Formatting behavior.
--
-- NOTE: plugin file basename determines the lazy loading order. So to override
-- the formatting behavior, define a plugin with file basename comes after
-- "format" (eg. format-xxx.lua), then override the opts function. Example:
--
-- local formatters_by_ft = ...
-- local formatters = ...
--
-- return {
--   "stevearc/conform.nvim",
--   opts = function(_, opts)
--     opts.formatters_by_ft = formatters_by_ft
--     opts.formatters = formatters
--     return opts
--   end,
-- }

local formatters_by_ft = {
  css = { "prettier" },
  go = { "gofmt" },
  html = { "prettier" },
  javascript = { "prettier" },
  lua = { "stylua" },
  python = { "pyink" },
  rust = { "rustfmt" },
  typescriptreact = { "prettier" },
}

local formatters = {}

return {
  "stevearc/conform.nvim",
  event = { "InsertEnter", "TextChanged", "TextChangedI", "BufWritePre" },
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

  -- opts() is excuted before plugin is loaded
  opts = function(_, opts)
    opts.formatters_by_ft = formatters_by_ft
    opts.formatters = formatters
    opts.default_format_opts = { lsp_format = "fallback" }
    return opts
  end,

  -- config() is excuted once after plugin is loaded
  config = function(_, opts)
    opts.format_on_save = function(bufnr)
      return vim.b.format_on_save and { timeout_ms = 500 } or nil
    end
    require("conform").setup(opts)

    -- Initial value for current buf where plugin is loaded
    vim.b.format_on_save = opts.formatters_by_ft[vim.bo.filetype] ~= nil

    -- Create an autocmd to set format_on_save for new buffers
    vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
      callback = function()
        vim.b.format_on_save = opts.formatters_by_ft[vim.bo.filetype] ~= nil
      end,
    })

    -- Create a new command ToggleFormatOnSave
    vim.api.nvim_create_user_command("ToggleFormatOnSave", function(args)
      vim.b.format_on_save = not vim.b.format_on_save
      vim.notify(
        string.format("Format on save: %s", tostring(vim.b.format_on_save)),
        vim.log.levels.WARN
      )
    end, { desc = "Toggle format on save" })

    -- <leader>uF to trigger ToggleFormatOnSave
    vim.keymap.set("n", "<leader>uF", ":ToggleFormatOnSave<CR>", { desc = "Toggle format on save" })
  end,
}
