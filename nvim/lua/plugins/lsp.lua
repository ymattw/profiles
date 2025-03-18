return {
  "neovim/nvim-lspconfig",
  version = "1.0.0", -- 1.1.0 breaks goDeclaration
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
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
      "<cmd>lua if vim.diagnostic.jump then vim.diagnostic.jump()(-1) else vim.diagnostic.goto_prev() end<cr>",
      desc = "Goto previous diagnostic",
    },
    {
      "]d",
      "<cmd>lua if vim.diagnostic.jump then vim.diagnostic.jump()(1) else vim.diagnostic.goto_next() end<cr>",
      desc = "Goto next diagnostic",
    },
  },
  config = function()
    require("mason").setup()
    require("mason-lspconfig").setup({
      ensure_installed = { "gopls", "pylsp", "lua_ls" },
    })

    local lspconfig = require("lspconfig")
    local capabilities = require("cmp_nvim_lsp").default_capabilities()

    -- Use default formatexpr for document formatting
    local on_attach = function(client, bufnr)
      -- LSP offered documentFormattingProvider is often not desired
      if client.server_capabilities.documentFormattingProvider then
        vim.bo[bufnr].formatexpr = nil
      end
    end

    -- Configure LSP servers
    lspconfig.gopls.setup({
      capabilities = capabilities,
      on_attach = on_attach,
      settings = {
        gopls = {
          analyses = {
            unusedparams = true,
          },
          staticcheck = true,
        },
      },
    })

    lspconfig.lua_ls.setup({
      capabilities = capabilities,
      on_attach = on_attach,
      settings = {
        Lua = {
          diagnostics = {
            globals = { "vim" },
          },
        },
      },
    })

    lspconfig.pylsp.setup({
      capabilities = capabilities,
      on_attach = on_attach,
    })

    lspconfig.ts_ls.setup({
      capabilities = capabilities,
      on_attach = on_attach,
      -- sudo npm i -g typescript typescript-language-server
      filetypes = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
      cmd = { "typescript-language-server", "--stdio" },
    })
  end,
}
