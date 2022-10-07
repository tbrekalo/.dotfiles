local is_treesitter_ok, treesitter_cfg = pcall(require, 'nvim-treesitter.configs')
if not is_treesitter_ok then
  return
end

treesitter_cfg.setup({
  ensure_installed = { 'cpp', 'json', 'lua', 'tsx', 'html', 'typescript', 'sql' },
  sync_install = true,
  additional_vim_regex_highlighting = false,

  autotag = {
    enable = true,
  },
})
