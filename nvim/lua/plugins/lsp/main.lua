local lsp_status_ok, lspconfig = pcall(require, 'lspconfig')
if not lsp_status_ok then
  return
end

require('plugins.lsp.components.nvim-cmp')
require('plugins.lsp.components.null-ls')
require('plugins.lsp.components.nodedev')

local on_attach = require('plugins.lsp.attach')
local capabilities = require('cmp_nvim_lsp').default_capabilities()

local configured = { 'cmake', 'cssls', 'html', 'pyright', 'tsserver' }
for _, lsp in ipairs(configured) do
  lspconfig[lsp].setup({
    on_attach = on_attach,
    capabilities = capabilities,
  })
end

-- clangd
lspconfig['clangd'].setup({
  on_attach = function(client, bufnr)
    on_attach(client, bufnr)
    if client.name == 'clangd' then
      vim.keymap.set(
        'n',
        '<leader>o',
        '<cmd>ClangdSwitchSourceHeader<cr>',
        { noremap = true, silent = true, buffer = bufnr }
      )
    end
  end,
  capabilities = capabilities,
})

lspconfig['sumneko_lua'].setup({
  on_attach = on_attach,
  capabilities = capabilities,

  settings = {
    Lua = {
      cmd = { 'lua-language-server' },
      format = {
        enable = false,
      },
      filetypes = { 'lua' },
      runtime = {
        version = 'LuaJIT',
      },
      completion = { enable = true, callSnippet = 'Both' },
      diagnostics = {
        enable = true,
        globals = { 'vim', 'describe' },
      },
      workspace = {
        library = {
          vim.api.nvim_get_runtime_file('', true),
        },
        -- adjust these two values if your performance is not optimal
        maxPreload = 2000,
        preloadFileSize = 1000,
      },
      telemetry = { enable = false },
    },
  },
})
