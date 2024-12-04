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
        -- Ref: https://github.com/ollama/ollama/blob/main/docs/openai.md
        endpoint = "http://localhost:11434/v1",
        model = "codegemma",
        temperature = 0.3, -- the smaller the more stable response
        max_tokens = 2048,
        parse_curl_args = function(opts, code_opts)
          return {
            url = opts.endpoint .. "/chat/completions",
            headers = {
              ["Accept"] = "application/json",
              ["Content-Type"] = "application/json",
              ["x-api-key"] = "ollama",
            },
            body = {
              model = opts.model,
              temperature = opts.temperature,
              max_tokens = opts.max_tokens,
              stream = true,
            },
          }
        end,
        -- FIXME: not supported yet?
        parse_response_data = function(data_stream, event_state, opts)
          require("avante.providers").copilot.parse_response(data_stream, event_state, opts)
        end,
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
