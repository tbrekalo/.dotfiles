local lsp_status_ok, lspconfig = pcall(require, 'lspconfig')
if not lsp_status_ok then
  return
end

local cmp_status_ok, cmp_nvim_lsp = pcall(require, 'cmp_nvim_lsp')
if not cmp_status_ok then
  return
end

-- Diagnostic options, see: `:help vim.diagnostic.config`
vim.diagnostic.config({
  update_in_insert = true,
  float = {
    focusable = false,
    style = "minimal",
    border = "rounded",
    source = "always",
    header = "",
    prefix = "",
  },
})

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = cmp_nvim_lsp.update_capabilities(capabilities)

capabilities.textDocument.completion.completionItem.documentationFormat = { 'markdown', 'plaintext' }
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.completion.completionItem.preselectSupport = true
capabilities.textDocument.completion.completionItem.insertReplaceSupport = true
capabilities.textDocument.completion.completionItem.labelDetailsSupport = true
capabilities.textDocument.completion.completionItem.deprecatedSupport = true
capabilities.textDocument.completion.completionItem.commitCharactersSupport = true
capabilities.textDocument.completion.completionItem.tagSupport = { valueSet = { 1 } }
capabilities.textDocument.completion.completionItem.resolveSupport = {
  properties = {
    'documentation',
    'detail',
    'additionalTextEdits',
  },
}

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  local lsp_signature_ok, lsp_signature = pcall(require, 'lsp_signature')
  if lsp_signature_ok then
    lsp_signature.on_attach()
  end

  -- Mappings.
  local opts = { noremap = true, silent = true, buffer = bufnr }
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
  vim.keymap.set('n', 'rn', vim.lsp.buf.rename, opts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
  vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, opts)
  vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
  vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
  vim.keymap.set('n', '<leader>f', function()
    vim.lsp.buf.format {
      async = true,
      timeout = 2000,
    }
  end, opts)
  vim.keymap.set('n', '<leader>o', '<cmd>ClangdSwitchSourceHeader<cr>', opts)
end

local servers = { 'sumneko_lua', 'pyright', 'clangd', 'tsserver', 'html', 'cssls' }
local server_settings = {
  ['sumneko_lua'] = {
    Lua = {
      cmd = { "lua-language-server" },
      format = {
        enable = true, -- set to false to let null-ls handle the formatting
      },
      filetypes = { "lua" },
      runtime = {
        version = "LuaJIT",
      },
      completion = { enable = true, callSnippet = "Both" },
      diagnostics = {
        enable = true,
        globals = { "vim", "describe" },
      },
      workspace = {
        library = {
          vim.api.nvim_get_runtime_file("", true),
        },
        -- adjust these two values if your performance is not optimal
        maxPreload = 2000,
        preloadFileSize = 1000,
      },
      telemetry = { enable = false },
    }
  },
}

-- Call setup
for _, lsp in ipairs(servers) do
  local args = {
    on_attach = on_attach,
    capabilities = capabilities,
    flags = {
      -- default in neovim 0.7+
      debounce_text_changes = 150,
    }
  }
  if server_settings[lsp] then
    args.settings = server_settings[lsp]
  end

  lspconfig[lsp].setup(args)
end
