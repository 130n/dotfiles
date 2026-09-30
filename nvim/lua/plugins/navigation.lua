return {
  -- Bufferline: flikar för öppna filer
  {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("bufferline").setup({
        options = {
          diagnostics = "nvim_lsp",
          offsets = {
            { filetype = "NvimTree", text = "Explorer", highlight = "Directory", separator = true },
          },
          show_close_icon = false,
          separator_style = "thin",
        },
      })
      vim.keymap.set("n", "<Tab>", "<cmd>BufferLineCycleNext<CR>", { desc = "Next buffer" })
      vim.keymap.set("n", "<S-Tab>", "<cmd>BufferLineCyclePrev<CR>", { desc = "Prev buffer" })
      vim.keymap.set("n", "<leader>x", "<cmd>bdelete<CR>", { desc = "Close buffer" })
    end,
  },

  -- Diffview: lokal PR-vy/diff mot en base branch (t.ex. origin/dev)
  {
    "sindrets/diffview.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewFileHistory", "PRView", "PROpen" },
    keys = {
      -- PR-review workflow (visible under <leader>p in which-key)
      { "<leader>pr", "<cmd>PRView<CR>", desc = "PR view vs origin/dev" },
      { "<leader>pR", "<cmd>PRView dev<CR>", desc = "PR view vs local dev" },
      { "<leader>po", "<cmd>PROpen<CR>", desc = "PR files in tabs vs origin/dev" },
      { "<leader>pc", "<cmd>DiffviewClose<CR>", desc = "Close PR/diff view" },
      { "<leader>ph", "<cmd>DiffviewFileHistory %<CR>", desc = "Current file history" },

      -- Git/diff aliases (kept for muscle memory)
      { "<leader>gd", "<cmd>DiffviewOpen origin/dev...HEAD<CR>", desc = "Diff vs origin/dev" },
      { "<leader>gD", "<cmd>DiffviewOpen<CR>", desc = "Diff vs working tree" },
      { "<leader>gh", "<cmd>DiffviewFileHistory %<CR>", desc = "File history" },
      { "<leader>gq", "<cmd>DiffviewClose<CR>", desc = "Close diffview" },
    },
    config = function()
      require("diffview").setup()

      vim.api.nvim_create_user_command("PRView", function(opts)
        local base = opts.args ~= "" and opts.args or "origin/dev"
        vim.cmd("DiffviewOpen " .. base .. "...HEAD")
      end, {
        nargs = "?",
        desc = "Open a GitHub/Azure-PR-like diff view against a base branch (default: origin/dev)",
        complete = function()
          return { "origin/dev", "dev", "origin/main", "main" }
        end,
      })

      vim.api.nvim_create_user_command("PROpen", function(opts)
        local base = opts.args ~= "" and opts.args or "origin/dev"
        local files = vim.fn.systemlist(
          "git diff --name-only --diff-filter=d " .. base .. "...HEAD"
        )
        if vim.v.shell_error ~= 0 then
          vim.notify("git diff failed: " .. table.concat(files, "\n"), vim.log.levels.ERROR)
          return
        end
        if #files == 0 then
          vim.notify("No changed files vs " .. base, vim.log.levels.WARN)
          return
        end
        for _, f in ipairs(files) do
          vim.cmd("tabedit " .. vim.fn.fnameescape(f))
        end
        vim.notify("Opened " .. #files .. " file(s) in tabs", vim.log.levels.INFO)
      end, {
        nargs = "?",
        desc = "Open every file changed vs base branch in its own tab (default: origin/dev)",
        complete = function()
          return { "origin/dev", "dev", "origin/main", "main" }
        end,
      })
    end,
  },

  -- Harpoon: snabba hopp mellan aktiva filer
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local harpoon = require("harpoon")
      harpoon:setup()

      vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end, { desc = "Harpoon add file" })
      vim.keymap.set("n", "<leader>h", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, { desc = "Harpoon menu" })

      -- Hoppa till fil 1-4 med leader + siffra
      vim.keymap.set("n", "<leader>1", function() harpoon:list():select(1) end, { desc = "Harpoon file 1" })
      vim.keymap.set("n", "<leader>2", function() harpoon:list():select(2) end, { desc = "Harpoon file 2" })
      vim.keymap.set("n", "<leader>3", function() harpoon:list():select(3) end, { desc = "Harpoon file 3" })
      vim.keymap.set("n", "<leader>4", function() harpoon:list():select(4) end, { desc = "Harpoon file 4" })
    end,
  },

  -- Telescope: bättre path display + snabbare fuzzy find
  {
    "nvim-telescope/telescope-fzf-native.nvim",
    build = "make",
  },
  {
    "nvim-telescope/telescope.nvim",
    branch = "master",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope-fzf-native.nvim",
    },
    config = function()
      local telescope = require("telescope")
      local actions = require("telescope.actions")

      telescope.setup({
        defaults = {
          -- Visa parent-mappar så du ser purchase_order/graph.py, inte bara graph.py
          path_display = { "smart" },
          -- Ignorera tunga mappar
          file_ignore_patterns = {
            "node_modules/",
            ".git/",
            "__pycache__/",
            "%.pyc",
            ".claude/",
            ".antigravity%-server/",
            "%.egg%-info/",
          },
          mappings = {
            i = {
              ["<C-j>"] = actions.move_selection_next,
              ["<C-k>"] = actions.move_selection_previous,
            },
          },
        },
      })

      telescope.load_extension("fzf")
    end,
  },
}
