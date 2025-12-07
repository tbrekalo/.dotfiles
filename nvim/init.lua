local function map(m, k, v, opts)
  opts = opts or { silent = true }
  vim.keymap.set(m, k, v, { silent = true })
end

-- refresh file
vim.api.nvim_create_autocmd({ 'FocusGained', 'BufEnter', 'CursorHold' }, {
  command = 'checktime',
})

-- map <leader> to space
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- skip some remote provider loading
vim.g.loaded_python3_provider = 0
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0

-- update time
vim.o.timeoutlen = 500
vim.o.updatetime = 200
vim.o.autoread = true
vim.o.number = true

-- Better editing experience
vim.o.expandtab = true
vim.o.smarttab = true
vim.o.cindent = true
vim.o.autoindent = true
vim.o.wrap = true
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.softtabstop = -1 -- If negative, shiftwidth value is used
vim.o.list = true
vim.o.listchars = 'trail:·,nbsp:◇,tab:→ ,extends:▸,precedes:◂'

-- share clipboard with OS
vim.o.clipboard = 'unnamedplus'

-- smart case search setup
vim.o.ignorecase = true
vim.o.smartcase = true

-- undo and backup options
vim.o.backup = false
vim.o.writebackup = false
vim.o.undofile = true
vim.o.swapfile = false
vim.o.backupdir = '/tmp/'
vim.o.directory = '/tmp/'
vim.o.undodir = '/tmp/'

map('n', 'gn', '<cmd>tabnew<cr>')
map('n', 'gx', '<cmd>tabclose<cr>')

local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
  { 'tpope/vim-fugitive' },
  { 'neovim/nvim-lspconfig' },
  {
    'saghen/blink.cmp',
    version = '*',
    opts = {
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
    },
  },
  { 'windwp/nvim-autopairs', event = 'InsertEnter', config = true },
  {
    'nvim-telescope/telescope.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release',
      },
    },
    opts = {
      defaults = {
        layout_strategy = 'vertical',
        vimgrep_arguments = {
          'rg',
          '--pcre2',
          '--color=never',
          '--no-heading',
          '--with-filename',
          '--line-number',
          '--column',
          '--smart-case',
        },
      },
      extensions = {
        fzf = {
          fuzzy = true, -- false will only do exact matching
          override_generic_sorter = true, -- override the generic sorter
          override_file_sorter = true, -- override the file sorter
          case_mode = 'smart_case', -- or "ignore_case" or "respect_case" or "smart_case"
        },
      },
      load_extensions = { 'fzf' },
    },
  },
  {
    'nvim-treesitter/nvim-treesitter',
    dependencies = { 'windwp/nvim-ts-autotag' },

    build = ':TSUpdate',
    main = 'nvim-treesitter.configs',

    opts = {
      ensure_installed = { 'cmake', 'cpp', 'json', 'lua', 'python' },
      auto_install = true,

      modules = { 'autotag', 'highlight', 'incremental_selection' },
      autotag = { enable = true },
      highlight = { enable = true },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = '<leader>t',
          node_incremental = 'tn',
          scope_incremental = 'tg',
          node_decremental = 'tp',
        },
      },
    },
  },
  {
    'EdenEast/nightfox.nvim',
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd('colorscheme terafox')
    end,
  },
})

local blink = require('blink.cmp')
local capabilities = blink.get_lsp_capabilities()
local on_attach = function(_, bufnr)
  local opts = { noremap = true, silent = true, buffer = bufnr }
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
  vim.keymap.set('n', 'rn', vim.lsp.buf.rename, opts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
  vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
  vim.keymap.set('n', '<leader>a', vim.lsp.buf.code_action, opts)
  vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, opts)
  vim.keymap.set('n', '[d', function()
    vim.diagnostic.jump({ count = 1, float = true })
  end, opts)
  vim.keymap.set('n', ']d', function()
    vim.diagnostic.jump({ count = -1, float = true })
  end, opts)
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
  'ruff',
}

for _, lsp in ipairs(configured) do
  lspconfig[lsp].setup({
    on_attach = on_attach,
    capabilities = capabilities,
  })
end

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
    '--clang-tidy',
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

lspconfig['pyright'].setup({
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

map('n', 'ff', '<cmd>Telescope find_files<cr>')
map('n', 'fh', '<cmd>Telescope find_files hidden=true<cr>')
map('n', 'fb', '<cmd>Telescope buffers<cr>')
map('n', 'fd', '<cmd>Telescope diagnostics bufnr=0<cr>')
map('n', 'rg', '<cmd>Telescope live_grep<cr>')
map('n', 'ss', '<cmd>Telescope grep_string<cr>')
