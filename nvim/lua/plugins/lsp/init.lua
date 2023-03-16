local cmp = require('cmp')

cmp.setup({
  -- load snippet support
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end,
  },
  mapping = {
    ['<C-n>'] = cmp.mapping.select_next_item(),
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-e>'] = cmp.mapping.close(),
    ['<C-y>'] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    }),
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'nvim_lsp_signature_help' },
    { name = 'luasnip' },
    { name = 'buffer' },
  },
})

local cmp_autopairs = require('nvim-autopairs.completion.cmp')
cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

require('mason').setup()
local on_attach = function(_, bufnr)
  local opts = { noremap = true, silent = true, buffer = bufnr }
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
  vim.keymap.set('n', 'rn', vim.lsp.buf.rename, opts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
  vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
  vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, opts)
  vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
  vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
  vim.keymap.set('n', '<leader>f', function()
    vim.lsp.buf.format({
      async = true,
    })
  end, opts)
end

local servers = {
  clangd = {
    on_attach = function(client, bufnr)
      on_attach(client, bufnr)
      vim.keymap.set(
        'n',
        '<leader>h',
        '<cmd>ClangdSwitchSourceHeader<cr>',
        { noremap = true, silent = true, buffer = bufnr }
      )
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

local null_ls = require('null-ls')
local mason_nls = require('mason-null-ls')

mason_nls.setup({
  ensure_installed = { 'stylua', 'jq', 'autopep8', 'pylint', 'mypy' },
  automatic_setup = true,
})

null_ls.setup({
  on_attach = function(_, bufnr)
    vim.keymap.set({ 'n' }, '<leader>f', function()
      vim.lsp.buf.format({
        async = true,
      })
    end, { noremap = true, silent = true, buffer = bufnr })
  end,
})

mason_nls.setup_handlers({})
