local on_attach = function(client, bufnr)
  -- Use default formatexpr for document formatting
  -- LSP offered documentFormattingProvider is often not desired
  if client.server_capabilities.documentFormattingProvider then
    vim.bo[bufnr].formatexpr = nil
  end

  -- Enable native document highlighting
  if client.server_capabilities.documentHighlightProvider then
    -- Create a unique group name for this specific buffer
    local group = vim.api.nvim_create_augroup("Illuminate" .. bufnr, { clear = true })

    vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
      buffer = bufnr,
      group = group,
      callback = vim.lsp.buf.document_highlight,
    })
    vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
      buffer = bufnr,
      group = group,
      callback = vim.lsp.buf.clear_references,
    })
  end
end

local servers = {
  gopls = {
    settings = {
      gopls = {
        analyses = {
          unusedparams = true,
        },
        staticcheck = true,
      },
    },
  },
  lua_ls = {
    settings = {
      Lua = {
        diagnostics = {
          globals = { "vim" },
        },
      },
    },
  },
  pylsp = {},
  rust_analyzer = {
    settings = {
      ["rust-analyzer"] = {
        cargo = {
          allFeatures = true,
        },
      },
    },
  },
  ts_ls = {
    filetypes = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
    cmd = { "typescript-language-server", "--stdio" },
  },
}

return {
  "neovim/nvim-lspconfig",
  version = "1.0.0", -- 1.1.0 breaks goDeclaration
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
  },

  keys = {
    {
      "<leader><space>",
      "<cmd>lua vim.lsp.buf.hover()<cr>",
      desc = "LSP hover",
    },
    {
      "<leader>r",
      "<cmd>lua vim.lsp.buf.references()<cr>",
      desc = "List references",
    },
    {
      "[d",
      "<cmd>lua if vim.diagnostic.jump then vim.diagnostic.jump({ count = -1 }) else vim.diagnostic.goto_prev() end<cr>",
      desc = "Goto previous diagnostic",
    },
    {
      "]d",
      "<cmd>lua if vim.diagnostic.jump then vim.diagnostic.jump({ count = 1 }) else vim.diagnostic.goto_next() end<cr>",
      desc = "Goto next diagnostic",
    },
  },

  opts = function(_, opts)
    local capabilities = require("cmp_nvim_lsp").default_capabilities()
    local local_servers = {}
    for server, config in pairs(servers) do
      local_servers[server] = vim.tbl_extend("force", {
        capabilities = capabilities,
        on_attach = on_attach,
      }, config)
    end
    return vim.tbl_deep_extend("force", opts, {
      on_attach = on_attach,
      servers = local_servers,
    })
  end,

  config = function(_, opts)
    local lspconfig = require("lspconfig")
    for server_name, server_opts in pairs(opts.servers) do
      lspconfig[server_name].setup(server_opts)
    end
  end,
}
