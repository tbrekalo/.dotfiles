local lsp_status_ok, lspconfig = pcall(require, 'lspconfig')
if not lsp_status_ok then
  return
end

local attach_keybingins = require('plugins.lsp.keybindings')
local cmp = require('plugins.lsp.components.nvim-cmp')
require('plugins.lsp.components.null-ls')
require('plugins.lsp.components.lua-dev')

local capabilities = cmp.bind_capabilities(vim.lsp.protocol.make_client_capabilities())

local on_attach = function(client, bufnr)
  local lsp_signature_ok, lsp_signature = pcall(require, 'lsp_signature')
  if lsp_signature_ok then
    lsp_signature.on_attach({
      bind = true,
      handler_opts = {
        border = 'rounded',
      },
      hint_prefix = '',
    }, bufnr)
  end

  local opts = { noremap = true, silent = true, buffer = bufnr }
  attach_keybingins(opts)

  -- TODO: inject lsp specific keybingins
  if client.name == 'clangd' then
    vim.keymap.set('n', '<leader>o', '<cmd>ClangdSwitchSourceHeader<cr>', opts)
  end
end

local servers = { 'sumneko_lua', 'pyright', 'clangd', 'tsserver', 'html', 'cssls' }
local server_settings = {
  ['sumneko_lua'] = require('plugins.lsp.servers.sumneko_lua'),
}

-- Call setup
for _, lsp in ipairs(servers) do
  local args = {
    on_attach = on_attach,
    capabilities = capabilities,
    flags = {
      -- default in neovim 0.7+
      debounce_text_changes = 150,
    },
  }
  if server_settings[lsp] then
    args.settings = server_settings[lsp]
  end

  lspconfig[lsp].setup(args)
end
