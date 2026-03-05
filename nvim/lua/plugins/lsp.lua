return {
  -- Mason: installerar LSP-servrar automatiskt
  {
    "williamboman/mason.nvim",
    config = true,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim" },
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = { "basedpyright", "ruff", "lua_ls" },
      })
    end,
  },

  -- LSP config (Neovim 0.11+ native API)
  {
    "neovim/nvim-lspconfig",
    dependencies = { "williamboman/mason-lspconfig.nvim" },
    config = function()
      -- Keybindings när LSP attachar
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(event)
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
      vim.lsp.config.basedpyright = {
        settings = {
          basedpyright = {
            analysis = {
              typeCheckingMode = "standard",
              diagnosticSeverityOverrides = {
                reportUnusedImport = "information",
                reportUnusedVariable = "information",
              },
            },
          },
        },
      }

      -- Ruff (Python linting/formatting)
      vim.lsp.config.ruff = {}

      -- Lua (för nvim-config)
      vim.lsp.config.lua_ls = {
        settings = {
          Lua = {
            diagnostics = { globals = { "vim" } },
          },
        },
      }

      vim.lsp.enable({ "basedpyright", "ruff", "lua_ls" })
    end,
  },
}
