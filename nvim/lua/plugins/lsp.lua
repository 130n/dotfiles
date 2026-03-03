return {
  -- Mason: installerar LSP-servrar automatiskt
  {
    "williamboman/mason.nvim",
    config = true,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim", "neovim/nvim-lspconfig" },
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = { "basedpyright", "ruff", "lua_ls" },
      })
    end,
  },

  -- LSP config
  {
    "neovim/nvim-lspconfig",
    dependencies = { "williamboman/mason-lspconfig.nvim" },
    config = function()
      local lspconfig = require("lspconfig")

      -- Keybindings när LSP attachar
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(event)
          local opts = { buffer = event.buf }
          vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = event.buf, desc = "Go to definition" })
          vim.keymap.set("n", "gr", vim.lsp.buf.references, { buffer = event.buf, desc = "Find references" })
          vim.keymap.set("n", "gI", vim.lsp.buf.implementation, { buffer = event.buf, desc = "Go to implementation" })
          vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = event.buf, desc = "Hover docs" })
          vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { buffer = event.buf, desc = "Rename symbol" })
          vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { buffer = event.buf, desc = "Code action" })
          vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, { buffer = event.buf, desc = "Type definition" })
        end,
      })

      -- Python (basedpyright)
      lspconfig.basedpyright.setup({
        settings = {
          basedpyright = {
            analysis = {
              typeCheckingMode = "standard",
              diagnosticSeverityOverrides = {
                -- Matcha projektets basedpyright-config
                reportUnusedImport = "information",
                reportUnusedVariable = "information",
              },
            },
          },
        },
      })

      -- Ruff (Python linting/formatting, snabbare än ruff-lsp)
      lspconfig.ruff.setup({})

      -- Lua (för nvim-config)
      lspconfig.lua_ls.setup({
        settings = {
          Lua = {
            diagnostics = { globals = { "vim" } },
          },
        },
      })
    end,
  },
}
