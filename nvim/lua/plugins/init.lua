return {
  -- Filutforskare (ersätter nerdtree)
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = {
      "nvim-tree/nvim-web-devicons", -- Fina ikoner
    },
    config = function()
      require("nvim-tree").setup({
        view = {
          width = 30,
        },
        renderer = {
          group_empty = true,
        },
        filters = {
          dotfiles = false, -- Visa dolda filer
        },
        filesystem_watchers = {
          ignore_dirs = {
            ".claude",
            ".antigravity-server",
            ".cache",
          },
        },
      })
    end,
  },

  -- Färgtema (catppuccin är snyggt!)
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
      require("catppuccin").setup({
        integrations = {
          avante = true,  -- Bättre färger för Avante
        },
      })
      vim.cmd.colorscheme("catppuccin-frappe")
    end,
  },

  -- Syntax highlighting (mycket bättre än standard)
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "master",
    build = function()
      -- Ny build-metod för nvim-treesitter 1.x
      pcall(function()
        require("nvim-treesitter.install").update({ with_sync = true })
      end)
    end,
    config = function()
      -- nvim-treesitter 1.x använder vim.treesitter direkt
      -- Installera parsers manuellt om det behövs
      local ok, install = pcall(require, "nvim-treesitter.install")
      if ok and install then
        install.prefer_git = false
      end
      
      -- Försök konfigurera om configs finns (äldre API)
      local configs_ok, configs = pcall(require, "nvim-treesitter.configs")
      if configs_ok and configs and configs.setup then
        configs.setup({
          ensure_installed = { "lua", "python", "javascript", "typescript", "rust", "go", "org" },
          highlight = { enable = true },
          indent = { enable = true },
        })
      end
    end,
  },

  -- Autopairs (stänger automatiskt parenteser, brackets etc)
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      local autopairs = require("nvim-autopairs")
      autopairs.setup()
      -- Stäng av autopairs för todo.txt
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "todo", "text" },
        callback = function()
          require("nvim-autopairs").disable()
        end,
      })
    end,
  },

  -- Comment.nvim (kommentera kod enkelt med gcc)
  {
    "numToStr/Comment.nvim",
    config = true,
  },

  -- Statusline (snygg statusrad)
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("lualine").setup({
        options = {
          theme = "catppuccin",
        },
      })
    end,
  },

  -- Git integration (se ändringar i editorn)
  {
    "lewis6991/gitsigns.nvim",
    config = true,
  },

  -- Indent guides (se indentering tydligt)
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    config = true,
  },

  -- Which-key (visar tillgängliga genvägar)
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    config = true,
  },

  -- Bullets.vim (auto-bullets och checkbox-toggle för markdown)
  {
    "dkarter/bullets.vim",
    ft = { "markdown", "text", "gitcommit" },
  },

  -- Org-mode (hierarkisk task-hantering)
  {
    "nvim-orgmode/orgmode",
    tag = "0.7.0", -- last version supporting Neovim 0.10
    event = "VeryLazy",
    ft = { "org" },
    config = function()
      require("orgmode").setup({
        org_agenda_files = "~/dev/todo/**/*",
        org_default_notes_file = "~/dev/todo/TODO.org",
        org_todo_keywords = { "TODO", "IN_PROGRESS", "WAITING", "|", "DONE", "CANCELLED" },
        org_capture_templates = {
          w = {
            description = "Work task",
            template = "** TODO %?\n",
            target = "~/dev/todo/TODO.org",
            headline = "Work",
          },
          p = {
            description = "Personal task",
            template = "** TODO %?\n",
            target = "~/dev/todo/TODO.org",
            headline = "Personal",
          },
        },
      })
    end,
  },

  -- Claude Code (IDE-integration via WebSocket)
  {
    "coder/claudecode.nvim",
    config = true,
  },

  -- Avante (Cursor-liknande AI-assistent)
  {
    "yetone/avante.nvim",
    event = "VeryLazy",
    version = false,
    build = "make",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "stevearc/dressing.nvim",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-tree/nvim-web-devicons",
      "MeanderingProgrammer/render-markdown.nvim",
    },
    config = function()
      require("avante").setup({
        provider = "claude",
        providers = {
          claude = {
            endpoint = "https://ai-agents-dev-001.services.ai.azure.com/anthropic",
            model = "claude-opus-4-5",
            extra_request_body = {
              max_tokens = 4096,
            },
          },
        },
      })
    end,
  },
}
