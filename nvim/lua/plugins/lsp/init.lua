local lsp = require('lsp-zero')
lsp.preset('minimal')
lsp.preset('recommended')

lsp.ensure_installed({
  'clangd',
  'cmake',
  'cssls',
  'html',
  'lua_ls',
  'pyright',
  'tsserver',
})

lsp.configure('clangd', {
  on_attach = function(client, bufnr)
    vim.keymap.set(
      'n',
      '<leader>h',
      '<cmd>ClangdSwitchSourceHeader<cr>',
      { noremap = true, silent = true, buffer = bufnr }
    )
  end
})

lsp.configure('lua_ls', {
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
}
)

local cmp = require('cmp')
local cmp_mappings = lsp.defaults.cmp_mappings({
  ['<C-n>'] = cmp.mapping.select_next_item(),
  ['<C-p>'] = cmp.mapping.select_prev_item(),
  ['<C-d>'] = cmp.mapping.scroll_docs(-4),
  ['<C-f>'] = cmp.mapping.scroll_docs(4),
  ['<C-e>'] = cmp.mapping.close(),
  ['<C-y>'] = cmp.mapping.confirm({
    behavior = cmp.ConfirmBehavior.Replace,
    select = true,
  }),
  ['<Tab>'] = nil,
  ['<S-Tab>'] = nil,
}
)

lsp.setup_nvim_cmp({
  mapping = cmp_mappings,
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end,
  },
  experimental = {
    native_menu = false,
    ghost_text = true,
  }
})

local cmp_autopairs = require('nvim-autopairs.completion.cmp')
cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())

lsp.on_attach(function(client, bufnr)
  local opts = { buffer = bufnr, remap = false }

  -- Mappings.
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
      timeout = 2000,
    })
  end, opts)
end)

lsp.setup()

vim.diagnostic.config({
  virtual_text = true
})
