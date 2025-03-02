local blink = require('blink.cmp')
blink.setup({
  appearance = {
    highlight_ns = vim.api.nvim_create_namespace('blink_cmp'),
    nerd_font_variant = 'mono',
  },
  fuzzy = {
    use_proximity = true,
    implementation = 'lua',
    prebuilt_binaries = {
      download = true,
    },
  },
})

local capabilities = blink.get_lsp_capabilities()
local on_attach = function(_, bufnr)
  local opts = { noremap = true, silent = true, buffer = bufnr }
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
  vim.keymap.set('n', 'rn', vim.lsp.buf.rename, opts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
  vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
  vim.keymap.set('n', '<leader>a', vim.lsp.buf.code_action, opts)
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
  'eslint',
  'html',
  'pyre',
  'ruff',
  'rust_analyzer',
  'ts_ls',
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

require('lspconfig').pyright.setup({
  settings = {
    pyright = {
      -- Using Ruff's import organizer
      disableOrganizeImports = true,
    },
    python = {
      analysis = {
        -- Ignore all files for analysis to exclusively use Ruff for linting
        ignore = { '*' },
      },
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

local efm_rust = {
  require('efmls-configs.formatters.rustfmt'),
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
      lua = efm_lua,
      markdown = efm_markdown,
      rust = efm_rust,
      text = efm_text,
      typescript = efm_typescript,
    },
  },
})
