# Dotfiles

Mini repo containing personal dotofiles.
The main focus is around [neovim](https://neovim.io/) and [tmux](https://github.com/tmux/tmux).

## Noevim

##\* General key bindings

```lua
local function map(m, k, v)
  vim.keymap.set(m, k, v, { silent = true })
end

map('n', '<C-H>', '<C-W><C-H>')
map('n', '<C-J>', '<C-W><C-J>')
map('n', '<C-K>', '<C-W><C-K>')
map('n', '<C-L>', '<C-W><C-L>')

map('n', 'gn', '<cmd>tabnew<cr>')
```

### Navigation

[telescope](https://github.com/nvim-telescope/telescope.nvim)

```lua
map('n', 'ff', '<cmd>Telescope find_files<cr>')
map('n', 'fh', '<cmd>Telescope find_files hidden=true<cr>')
map('n', 'fb', '<cmd>Telescope buffers<cr>')
map('n', 'fd', '<cmd>Telescope diagnostics bufnr=0<cr>')
map('n', 'rg', '<cmd>Telescope live_grep<cr>')

map('n', 'gs', '<cmd>Telescope lsp_dynamic_workspace_symbols<cr>')
map('n', 'gr', '<cmd>Telescope lsp_references<cr>')
```

### LSP

Using neovim's [lsp-config](https://github.com/neovim/nvim-lspconfig)

- preconfigured clients
- clangd
- cssls
- html
- pyright
- sumneko lua
- tsserver

### Keybindings

```lua
vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
vim.keymap.set('n', 'rn', vim.lsp.buf.rename, opts)
vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
vim.keymap.set('n', '<leader>f', function()
  vim.lsp.buf.format({
    async = true,
    timeout = 2000,
  })
end, opts)
```

### Diagnostics and linting

Done throught [null-ls](https://github.com/jose-elias-alvarez/null-ls.nvim)

- diagnostics
  - eslint
  - fish
  - pylint
  - sqlfluff
- formatting
  - autopep8
  - cmake_format
  - fish_indent
  - prettier
  - sqlfluff
  - stylua

### Treesitter

[Treesitter repo](https://github.com/nvim-treesitter/nvim-treesitter)
Enabled features:

- autotag
- highlight
- incremental selection
  ```lua
    keymaps = {
      init_selection = '<leader>t',
      node_incremental = 'tn',
      scope_incremental = 'tg',
      node_decremental = 'tp',
    },
  ```
- supported languages
  - cpp
  - html
  - json
  - lua
  - python
  - scss
  - sql
  - tsx
  - typescript'

### Quality of life

- [gitlinker](https://github.com/ruifm/gitlinker.nvim)
- [lualine](https://github.com/nvim-lualine/lualine.nvim)
- [LuaSnip](https://github.com/L3MON4D3/LuaSnip)
