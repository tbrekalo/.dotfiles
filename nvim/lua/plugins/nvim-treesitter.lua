local is_treesitter_ok, treesitter_cfg = pcall(require, 'nvim-treesitter.configs')
if not is_treesitter_ok then
  return
end

treesitter_cfg.setup({
  sync_install = true,
  ensure_installed = {
    'cmake',
    'cpp',
    'css',
    'html',
    'json',
    'lua',
    'org',
    'python',
    'rust',
    'scss',
    'sql',
    'tsx',
    'typescript',
  },

  highlight = {
    enable = true,
  },

  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = '<leader>t',
      node_incremental = 'tn',
      scope_incremental = 'tg',
      node_decremental = 'tp',
    },
  },

  autotag = {
    enable = true,
  },
})
