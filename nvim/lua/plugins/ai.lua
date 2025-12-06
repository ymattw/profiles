return {
  "yetone/avante.nvim",
  event = "VeryLazy",
  lazy = false,
  version = '*',              -- pull the latest release
  dependencies = {
    "nvim-lua/plenary.nvim",  -- utils lib
    "MunifTanjim/nui.nvim",   -- UI lib
    "stevearc/dressing.nvim", -- better UI
  },
  opts = {
    provider = "ollama",
    providers = {
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

      -- Requires $GEMINI_API_KEY
      gemini = {
        model = "gemini-2.0-flash",
        timeout = "10000", -- milliseconds
      },
    },

    -- TODO: map a key to toggle this?
    dual_boost = {
      enabled = false,
      first_provider = "gemini",
      second_provider = "openai",
      timeout = 60000, -- milliseconds
    },
    behaviour = {
      auto_suggestions = false, -- Experimental stage
      auto_set_highlight_group = true,
      auto_set_keymaps = true,
      auto_apply_diff_after_generation = false,
      support_paste_from_clipboard = false,
      minimize_diff = true,                -- Whether to remove unchanged lines when applying a code block
      enable_token_counting = true,        -- Whether to enable token counting. Default to true.
      enable_cursor_planning_mode = false, -- Whether to enable Cursor Planning Mode. Default to false.
    },
  },
}
