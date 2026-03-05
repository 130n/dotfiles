-- Fix för Telescope/nvim-treesitter i Neovim 0.10+
-- Lägger till saknade funktioner som togs bort i nya versioner
vim.filetype.get_lang = vim.treesitter.language.get_lang

-- Fix för nvim-treesitter parsers.ft_to_lang som Telescope använder
vim.api.nvim_create_autocmd("User", {
  pattern = "LazyDone",
  callback = function()
    local ok, parsers = pcall(require, "nvim-treesitter.parsers")
    if ok and parsers and not parsers.ft_to_lang then
      parsers.ft_to_lang = vim.treesitter.language.get_lang
    end
  end,
})

-- Fallback om LazyDone inte triggas
vim.defer_fn(function()
  local ok, parsers = pcall(require, "nvim-treesitter.parsers")
  if ok and parsers and not parsers.ft_to_lang then
    parsers.ft_to_lang = vim.treesitter.language.get_lang
  end
end, 100)

-- Grundläggande inställningar
vim.g.mapleader = " "  -- Space som leader-tangent
vim.opt.number = true  -- Radnummer
vim.opt.relativenumber = true  -- Relativa radnummer
vim.opt.mouse = "a"  -- Musstöd
vim.opt.ignorecase = true  -- Skiftlägesokänslig sökning
vim.opt.smartcase = true  -- ...men skiftlägeskänslig om du använder stor bokstav
vim.opt.hlsearch = false  -- Ingen highlight efter sökning
vim.opt.wrap = true  -- Wordwrap
vim.opt.linebreak = true  -- Bryt vid ord, inte mitt i ett ord
vim.opt.breakindent = true  -- Behåll indentering vid radbrytning
vim.opt.tabstop = 4  -- Tab-storlek
vim.opt.shiftwidth = 4  -- Indentering
vim.opt.expandtab = true  -- Använd spaces istället för tabs
vim.opt.termguicolors = true  -- Fullfärg
vim.opt.clipboard = "unnamedplus"  -- Kopiera till system clipboard

-- WSL clipboard support
if vim.fn.has("wsl") == 1 then
  vim.g.clipboard = {
    name = "WslClipboard",
    copy = {
      ["+"] = "clip.exe",
      ["*"] = "clip.exe",
    },
    paste = {
      ["+"] = 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
      ["*"] = 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
    },
    cache_enabled = 0,
  }
end

-- Bootstrap lazy.nvim plugin manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Ladda plugins
require("lazy").setup("plugins")

-- Genvägar
vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>", { desc = "Toggle file explorer" })
vim.keymap.set("n", "<leader>E", ":NvimTreeFindFile<CR>", { desc = "Reveal current file in tree" })
vim.keymap.set("n", "<leader>ff", ":Telescope find_files<CR>", { desc = "Find files" })
vim.keymap.set("n", "<leader>fg", ":Telescope live_grep<CR>", { desc = "Live grep" })
vim.keymap.set("n", "<leader>fb", ":Telescope buffers<CR>", { desc = "Find buffers" })
vim.keymap.set("n", "<leader>fs", ":Telescope lsp_document_symbols<CR>", { desc = "Find symbols in file" })
vim.keymap.set("n", "<leader>fS", ":Telescope lsp_workspace_symbols<CR>", { desc = "Find symbols in workspace" })

-- Scoped search: sök bara i backend/
vim.keymap.set("n", "<leader>sb", function()
  require("telescope.builtin").find_files({ search_dirs = { "backend/" } })
end, { desc = "Find files in backend" })
vim.keymap.set("n", "<leader>sg", function()
  require("telescope.builtin").live_grep({ search_dirs = { "backend/" } })
end, { desc = "Grep in backend" })

-- Scoped search: sök bara i frontend/
vim.keymap.set("n", "<leader>sf", function()
  require("telescope.builtin").find_files({ search_dirs = { "frontend/" } })
end, { desc = "Find files in frontend" })

-- Sök i agents-mappen specifikt (alla graph.py, tools.py etc)
vim.keymap.set("n", "<leader>sa", function()
  require("telescope.builtin").find_files({ search_dirs = { "backend/src/agents/" } })
end, { desc = "Find files in agents" })

-- Hoppa mellan fönster med Ctrl+hjkl
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Go to left window" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Go to lower window" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Go to upper window" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Go to right window" })
