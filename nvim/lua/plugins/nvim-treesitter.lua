local is_treesitter_ok, treesitter_cfg = pcall(require, 'nvim-treesitter.configs')
if not is_treesitter_ok then
  return
end

treesitter_cfg.setup({
  sync_install = true,
  ensure_installed = { 'cpp', 'html', 'json', 'lua', 'python', 'scss', 'sql', 'tsx', 'typescript' },

  highlight = {
    enable = true,
    dissable = {'cpp', 'python'}
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
