local is_nls_ls_ok, nls = pcall(require, 'null-ls')
if not is_nls_ls_ok then
  return
end

local formatting = nls.builtins.formatting
local diagnostics = nls.builtins.diagnostics

nls.setup({
  sources = {
    diagnostics.eslint,
    diagnostics.fish,
    diagnostics.pylint,

    formatting.autopep8,
    formatting.cmake_format,
    formatting.fish_indent,
    formatting.prettier,
    formatting.stylua.with({
      extra_args = {
        '--indent-type',
        'Spaces',
        '--indent-width',
        '2',
        '--quote-style',
        'ForceSingle',
      },
    }),
  },

  on_attach = function(client, bufnr)
    vim.keymap.set('n', '<leader>f', function()
      vim.lsp.buf.format({
        async = true,
        timeout = 2000,
      })
    end, { noremap = true, silent = true, buffer = bufnr })
  end,
})
