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
          ensure_installed = { "lua", "python", "javascript", "typescript", "rust", "go" },
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
          theme = "catppuccin-frappe",
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
    config = function()
      local wk = require("which-key")
      wk.setup({})

      -- Group labels so Space shows a discoverable PR-review menu.
      if wk.add then
        wk.add({
          { "<leader>p", group = "PR review" },
          { "<leader>g", group = "Git / diff" },
          { "<leader>f", group = "Find" },
          { "<leader>s", group = "Scoped search" },
        })
      else
        wk.register({
          p = { name = "+PR review" },
          g = { name = "+Git / diff" },
          f = { name = "+Find" },
          s = { name = "+Scoped search" },
        }, { prefix = "<leader>" })
      end
    end,
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
        org_agenda_files = "~/dev/todo/*.org",
        org_default_notes_file = "~/dev/todo/TODO.org",
        org_todo_keywords = { "TODO", "IN_PROGRESS", "WAITING", "|", "DONE", "MOVED", "CANCELLED" },
        org_startup_folded = "content",
        org_startup_indented = true,
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

      -- Archive DONE/CANCELLED headings that have no active children
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "org",
        callback = function()
          -- Fast batch archive (direct file manipulation)
          vim.keymap.set("n", "<leader>oD", function()
            local bufnr = vim.api.nvim_get_current_buf()
            local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
            local filepath = vim.api.nvim_buf_get_name(bufnr)
            local archive_path = filepath:gsub("%.org$", "_archive.org")

            local active_todo_keywords = {
              TODO = true,
              IN_PROGRESS = true,
              WAITING = true,
            }

            -- Parse headlines and find closed items without active TODO children.
            -- Plain org subheadings (without TODO keyword) are content, not active tasks.
            local to_archive = {}
            local i = 1
            while i <= #lines do
              local line = lines[i]
              local level, todo, title = line:match("^(%*+)%s+(%S+)%s+(.*)$")
              if level and (todo == "DONE" or todo == "CANCELLED" or todo == "MOVED") then
                -- Check if any children are not done
                local has_active = false
                local end_line = i
                for j = i + 1, #lines do
                  local next_level = lines[j]:match("^(%*+)%s+")
                  if next_level then
                    if #next_level <= #level then break end
                    local child_todo = lines[j]:match("^%*+%s+(%S+)%s+")
                    if child_todo and active_todo_keywords[child_todo] then
                      has_active = true
                      break
                    end
                  end
                  end_line = j
                end
                if not has_active then
                  table.insert(to_archive, {start = i, ["end"] = end_line})
                  i = end_line
                end
              end
              i = i + 1
            end

            if #to_archive == 0 then
              vim.notify("No closed items to archive (closed items with active children are kept)")
              return
            end

            -- Extract items to archive (reverse order to preserve line numbers)
            local archived_lines = {}
            for i = #to_archive, 1, -1 do
              local range = to_archive[i]
              local item = {}
              for j = range.start, range["end"] do
                table.insert(item, lines[j])
              end
              table.insert(archived_lines, 1, table.concat(item, "\n"))
              -- Remove from buffer
              for j = range["end"], range.start, -1 do
                table.remove(lines, j)
              end
            end

            -- Write updated main file
            vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
            vim.cmd("write")

            -- Append to archive file
            local archive_content = ""
            local archive_file = io.open(archive_path, "r")
            if archive_file then
              archive_content = archive_file:read("*all")
              archive_file:close()
            end
            archive_file = io.open(archive_path, "w")
            if archive_file then
              archive_file:write(archive_content)
              if not archive_content:match("\n$") and archive_content ~= "" then
                archive_file:write("\n")
              end
              archive_file:write(table.concat(archived_lines, "\n\n") .. "\n")
              archive_file:close()
              vim.notify(("✓ Archived %d items to %s"):format(#to_archive, vim.fn.fnamemodify(archive_path, ":t")))
            else
              vim.notify("Error: Could not write to archive file", vim.log.levels.ERROR)
            end
          end, { buffer = true, desc = "org archive all closed: DONE/CANCELLED/MOVED (fast batch)" })
        end,
      })
    end,
  },

  -- Claude Code (IDE-integration via WebSocket)
  {
    "coder/claudecode.nvim",
    config = true,
  },

  -- Avante (disabled - using claudecode.nvim instead)
  -- {
  --   "yetone/avante.nvim",
  --   enabled = false,
  -- },
}
