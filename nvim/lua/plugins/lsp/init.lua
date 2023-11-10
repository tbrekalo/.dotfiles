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
  vim.keymap.set({ 'n', 'v' }, '<leader>f', function()
    vim.lsp.buf.format({
      async = true,
    })
  end, opts)
end

local lspconfig = require('lspconfig')
local configured = {
  'bashls',
  'cmake',
  'cssls',
  'dockerls',
  'eslint',
  'html',
  'pyre',
  'pyright',
  'ruff_lsp',
  'tsserver',
}

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
    vim.keymap.set(
      'n',
      '<leader>h',
      '<cmd>ClangdSwitchSourceHeader<cr>',
      { noremap = true, silent = true, buffer = bufnr }
    )
  end,
  capabilities = capabilities,
  cmd = {
    'clangd',
    '--offset-encoding=utf-16',
  },
})

lspconfig['pyre'].setup({
  on_attach = on_attach,
  capabilities = capabilities,
  root_dir = function(file_name)
    local util = require('lspconfig.util')
    return util.root_pattern(unpack({
      'pyproject.toml',
      'setup.cfg',
      'setup.py',
    }))(file_name)
  end,
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

local efm_bash = {
  require('efmls-configs.formatters.shfmt'),
}

local efm_cmake = {
  require('efmls-configs.linters.cmake_lint'),
}

local efm_docker = {
  require('efmls-configs.linters.hadolint'),
}

local efm_javascript = {
  require('efmls-configs.linters.eslint'),
  require('efmls-configs.formatters.prettier'),
}

local efm_json = {
  require('efmls-configs.linters.jq'),
  require('efmls-configs.formatters.jq'),
}

local efm_markdown = {
  require('efmls-configs.linters.markdownlint'),
}

local efm_lua = {
  require('efmls-configs.linters.luacheck'),
  require('efmls-configs.formatters.stylua'),
}

local efm_python = {
  require('efmls-configs.formatters.isort'),
  require('efmls-configs.formatters.black'),
}

local efm_text = {
  require('efmls-configs.linters.vale'),
}

local efm_typescript = {
  require('efmls-configs.linters.eslint'),
  require('efmls-configs.formatters.prettier'),
}

lspconfig.efm.setup({
  init_options = {
    documentFormatting = true,
    documentRangeFormatting = true,
  },
  settings = {
    rootMarkers = { '.git/' },
    languages = {
      bash = efm_bash,
      cmake = efm_cmake,
      docker = efm_docker,
      javascript = efm_javascript,
      json = efm_json,
      markdown = efm_markdown,
      lua = efm_lua,
      python = efm_python,
      text = efm_text,
      typescript = efm_typescript,
    },
  },
})
