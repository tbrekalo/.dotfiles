-- Diagnostic options, see: `:help vim.diagnostic.config`
vim.diagnostic.config({
  update_in_insert = true,
  float = {
    focusable = false,
    style = 'minimal',
    border = 'rounded',
    source = 'always',
    header = '',
    prefix = '',
  },
})
