# Neovim Keybindings

Leader key: `Space`

## File Navigation

| Key | Action |
|-----|--------|
| `<leader>e` | Toggle file tree (NvimTree) |
| `<leader>E` | Reveal current file in tree |
| `<leader>ff` | Find files (Telescope) |
| `<leader>fg` | Live grep (Telescope) |
| `<leader>fb` | Find open buffers |

## Scoped Search

Sök inom specifik mapp — löser problemet med många filer som heter samma sak (graph.py, tools.py etc).

| Key | Action |
|-----|--------|
| `<leader>sb` | Find files in `backend/` |
| `<leader>sg` | Grep in `backend/` |
| `<leader>sf` | Find files in `frontend/` |
| `<leader>sa` | Find files in `backend/src/agents/` |

## Harpoon (Pinned Files)

Pinna 1-4 filer du jobbar med just nu och hoppa mellan dem direkt.

| Key | Action |
|-----|--------|
| `<leader>a` | Pin current file |
| `<leader>h` | Show pinned files menu |
| `<leader>1` | Jump to pinned file 1 |
| `<leader>2` | Jump to pinned file 2 |
| `<leader>3` | Jump to pinned file 3 |
| `<leader>4` | Jump to pinned file 4 |

## LSP (Python, Lua)

Fungerar automatiskt i Python-filer via basedpyright. Första gången kan Mason behöva installera servern — kör `:Mason` för att se status.

| Key | Action |
|-----|--------|
| `gd` | Go to definition |
| `gr` | Find all references |
| `gI` | Go to implementation |
| `K` | Hover docs (visa typ/docstring) |
| `<leader>rn` | Rename symbol |
| `<leader>ca` | Code action |
| `<leader>D` | Go to type definition |
| `<leader>fs` | Find symbols in current file |
| `<leader>fS` | Find symbols in workspace |

## Window Navigation

| Key | Action |
|-----|--------|
| `Ctrl+h` | Go to left window |
| `Ctrl+j` | Go to lower window |
| `Ctrl+k` | Go to upper window |
| `Ctrl+l` | Go to right window |

## Editing

| Key | Action |
|-----|--------|
| `gcc` | Toggle comment (line) |
| `gc` | Toggle comment (visual selection) |

## Plugins

| Plugin | Purpose |
|--------|---------|
| lazy.nvim | Plugin manager |
| nvim-tree | File explorer |
| telescope + fzf-native | Fuzzy finder |
| harpoon | Quick file switching |
| nvim-lspconfig + mason | LSP (go-to-def, references, rename) |
| basedpyright | Python type checker / LSP |
| ruff | Python linting / formatting |
| treesitter | Syntax highlighting |
| catppuccin | Color scheme (frappe) |
| lualine | Status line |
| gitsigns | Git indicators in gutter |
| which-key | Shows available keybindings on `<leader>` |
| nvim-autopairs | Auto-close brackets |
| Comment.nvim | Toggle comments |
| indent-blankline | Indentation guides |
| claudecode.nvim | Claude Code IDE integration |
| avante.nvim | AI assistant |
