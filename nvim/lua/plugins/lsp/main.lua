require('plugins.lsp.components.nvim-cmp')
require('plugins.lsp.components.null-ls')

local on_attach = require('plugins.lsp.attach')
local capabilities = require('cmp_nvim_lsp').default_capabilities()

local mason_status_ok, mason = pcall(require, 'mason')
if not mason_status_ok then
  return
end

mason.setup()

local servers = {
  clangd = {
    on_attach = function(client, bufnr)
      on_attach(client, bufnr)
      if client.name == 'clangd' then
        vim.keymap.set(
          'n',
          '<leader>h',
          '<cmd>ClangdSwitchSourceHeader<cr>',
          { noremap = true, silent = true, buffer = bufnr }
        )
      end
    end,
    capabilities = capabilities,
  },
  cmake = {},
  cssls = {},
  html = {},
  pyright = {},
  tsserver = {},
  lua_ls = {
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
}

local mason_lspconfig = require('mason-lspconfig')

mason_lspconfig.setup({
  ensure_installed = vim.tbl_keys(servers),
})

mason_lspconfig.setup_handlers({
  function(server_name)
    require('lspconfig')[server_name].setup({
      capabilities = capabilities,
      on_attach = on_attach,
      settings = servers[server_name],
    })
  end,
})
