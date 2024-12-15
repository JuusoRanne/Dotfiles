-- required plugins for setting up connections to language server
return {
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "tailwindcss-language-server",
        "typescript-language-server",
      }
    }
  },
  {
    "williamboman/mason-lspconfig.nvim",
    lazy = false,
    opts = {
      ensure_installed =
      {"bashls", "rust_analyzer", "lua_ls", "bashls", "marksman", "pyright", "terraformls", "tflint", "azure_pipelines_ls", "jsonls", "gopls", "ts_ls", "html", "cssls", "texlab"},
    }
  },

  {
    "neovim/nvim-lspconfig",
    lazy = false,
    config = function()
      local capabilities = require('cmp_nvim_lsp').capabilities

      local lspconfig = require("lspconfig")
      local util = require "lspconfig/util"

      lspconfig.lua_ls.setup({
        capabilities = capabilities
      })
      lspconfig.ts_ls.setup({
        capabilities = capabilities
      })
      lspconfig.bashls.setup({
        capabilities = capabilities
      })
      lspconfig.marksman.setup({
        capabilities = capabilities
      })
      lspconfig.pyright.setup({
        capabilities = capabilities
      })
      lspconfig.terraformls.setup({
        capabilities = capabilities
      })
      lspconfig.tflint.setup({
        capabilities = capabilities
      })
      lspconfig.html.setup({
        capabilities = capabilities
      })
      lspconfig.cssls.setup({
        capabilities = capabilities
      })

      lspconfig.azure_pipelines_ls.setup({
        capabilities = capabilities
      })
      lspconfig.texlab.setup({
        capabilities = capabilities
      })

      lspconfig.gopls.setup({
        capabilities = capabilities,
        cmd = { "gopls" },
        filetypes = { "go", "gomod", "gowork", "gotmpl" },
        root_dir = util.root_pattern("go.work", "go.mod", ".git"),
        settings = {
          gopls = {
            completeUnimported = true,
          },
        },
      })
      lspconfig.jsonls.setup({
        capabilities = capabilities
      })

      vim.keymap.set('n', 'K', vim.lsp.buf.hover, {})
      vim.keymap.set('n', 'gd', vim.lsp.buf.definition, {})
      vim.keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, {})
      -- Set up a keybinding to rename a symbol using LSP
      vim.keymap.set('n', '<leader>r', vim.lsp.buf.rename, { desc = "Rename symbol" })

    end,
  },

}
