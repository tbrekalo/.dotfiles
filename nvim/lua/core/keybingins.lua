local function map(m, k, v)
  vim.keymap.set(m, k, v, { silent = true })
end

map('n', '<C-H>', '<C-W><C-H>')
map('n', '<C-J>', '<C-W><C-J>')
map('n', '<C-K>', '<C-W><C-K>')
map('n', '<C-L>', '<C-W><C-L>')

map('n', 'gn', '<cmd>tabnew<cr>')
map('n', '<leader>l', function()
  print('reloaded ' .. vim.api.nvim_buf_get_name(0))
  vim.cmd('luafile %')
end)
