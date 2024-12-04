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
    provider = "openai",
    ollama = {
      endpoint = "http://localhost:11434",
      model = "codegemma",
      temperature = 0, -- stable response
      max_tokens = 4096,
      ["local"] = true,
    },
    -- Requires $OPENAI_API_KEY
    openai = {
      model = "gpt-4o-mini",
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
