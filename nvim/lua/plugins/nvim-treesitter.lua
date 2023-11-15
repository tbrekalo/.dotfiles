local is_treesitter_ok, treesitter_cfg = pcall(require, 'nvim-treesitter.configs')
if not is_treesitter_ok then
  return
end

-- folding
vim.o.foldmethod = 'expr'
vim.o.foldexpr = 'nvim_treesitter#foldexpr()'

treesitter_cfg.setup({
  ensure_installed = {
    'cmake',
    'cpp',
    'css',
    'html',
    'javascript',
    'json',
    'lua',
    'markdown',
    'markdown_inline',
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

local fold_group = vim.api.nvim_create_augroup('FoldGroup', {})
vim.api.nvim_create_autocmd({ 'BufReadPost', 'FileReadPost' }, {
  group = fold_group,
  pattern = '*',
  command = 'normal zR',
})
