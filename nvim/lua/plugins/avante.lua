return {
  "yetone/avante.nvim",
  event = "VeryLazy",
  lazy = false,
  version = false, -- always pull the latest change
  dependencies = {
    "nvim-lua/plenary.nvim", -- utils lib
    "MunifTanjim/nui.nvim", -- UI lib
    "stevearc/dressing.nvim", -- better UI
  },
  opts = {
    provider = "ollama",
    vendors = {
      ollama = {
        __inherited_from = "openai",
        api_key_name = "",
        endpoint = "http://localhost:11434/v1",
        model = "qwen2.5-coder",
        temperature = 0.3, -- the smaller the more stable response
        max_tokens = 2048,
      },

      -- Requires $OPENAI_API_KEY
      openai = {
        model = "gpt-4o-mini",
      },
    },

    -- TODO: map a key to toggle this?
    dual_boost = {
      enabled = false,
      first_provider = "ollama",
      second_provider = "openai",
      timeout = 60000, -- milliseconds
    },
  },
}
