vim.o.tabstop = 2
vim.o.softtabstop = 2
vim.o.shiftwidth = 2

vim.keymap.set('n', '<leader>l', function()
  local target_file = vim.api.nvim_buf_get_name(0)
  print('reloaded ' .. target_file)
  vim.cmd('luafile ' .. target_file)
end)
