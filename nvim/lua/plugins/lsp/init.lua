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
    { name = 'path' },
  },
})

local cmp_autopairs = require('nvim-autopairs.completion.cmp')
cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

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

local lspconfig = require('lspconfig')
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
        '<leader>h',
        '<cmd>ClangdSwitchSourceHeader<cr>',
        { noremap = true, silent = true, buffer = bufnr }
      )
    end
  end,
  capabilities = capabilities,
})

lspconfig['lua_ls'].setup({
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

local null_ls = require('null-ls')

local formatting = null_ls.builtins.formatting
local diagnostics = null_ls.builtins.diagnostics

null_ls.setup({
  sources = {
    diagnostics.eslint,
    diagnostics.jsonlint,
    diagnostics.fish,
    diagnostics.mypy,
    diagnostics.pylint,
    diagnostics.sqlfluff.with({
      extra_args = { '--dialect', 'mysql' },
    }),
    diagnostics.yamllint,

    formatting.autopep8,
    formatting.isort,
    formatting.fish_indent,
    formatting.jq,
    formatting.nimpretty,
    formatting.prettier,
    formatting.rustfmt,
    formatting.sqlfluff.with({
      extra_args = { '--dialect', 'mysql' },
    }),
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

  on_attach = function(_, bufnr)
    vim.keymap.set({ 'n', 'v' }, '<leader>f', function()
      vim.lsp.buf.format({
        async = true,
        timeout = 2000,
      })
    end, { noremap = true, silent = true, buffer = bufnr })
  end,

  root_dir = require('null-ls.utils').root_pattern('.null-ls-root', '.git', '.pyproject.toml'),
})
