local attach_keybingins = require('plugins.lsp.keybindings')
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
end

return on_attach
