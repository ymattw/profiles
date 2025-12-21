return {
  {
    "yetone/avante.nvim",
    event = "VeryLazy",
    lazy = false,
    version = '*', -- pull the latest release
    build = "make",
    dependencies = {
      "nvim-lua/plenary.nvim",  -- utils lib
      "MunifTanjim/nui.nvim",   -- UI lib
      "stevearc/dressing.nvim", -- better UI
      "nvim-tree/nvim-web-devicons",
      {
        -- Render markdown in sidebar
        "MeanderingProgrammer/render-markdown.nvim",
        opts = { file_types = { "Avante" } },
        ft = { "Avante" },
      },
    },
    opts = {
      provider = "gemini",
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
  },
  {
    "milanglacier/minuet-ai.nvim",
    lazy = false,
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("minuet").setup({
        provider = "gemini",
        provider_options = {
          -- Requires $GEMINI_API_KEY
          gemini = {
            model = "gemini-2.5-flash",
            stream = true,
          },
        },
        virtualtext = {
          auto_trigger_ft = {}, -- manually trigger, see ./completion.lua
          keymap = {
            accept = "<Tab>",
            accept_line = "<C-l>",
            next = "<C-]>",
            dismiss = "<C-e>",
          },
        },
        throttle = 150, -- Request only after paused typing for 150ms
      })
    end,
  },
}
