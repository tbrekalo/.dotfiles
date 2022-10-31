local map = function(m, k, v, opts)
  opts = opts or { silent = true }
  vim.keymap.set(m, k, v, opts)
end

map('n', '<C-H>', '<C-W><C-H>')
map('n', '<C-J>', '<C-W><C-J>')
map('n', '<C-K>', '<C-W><C-K>')
map('n', '<C-L>', '<C-W><C-L>')

map('n', 'gn', '<cmd>tabnew<cr>')
map('n', 'gx', '<cmd>tabclose<cr>')
map('t', '<ESC>', [[<C-\><C-n>]], { silent = true, noremap = true })
map('t', '<ESC>', [[<C-\><C-n>]], { silent = true, noremap = true })
