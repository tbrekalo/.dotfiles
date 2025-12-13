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
vim.o.tabstop = 2
vim.o.shiftwidth = 2
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

vim.keymap.set('n', 'gn', vim.cmd.tabnew, { silent = true })
vim.keymap.set('n', 'gx', vim.cmd.tabclose, { silent = true })

-- lazy setup
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
  {
    'folke/lazydev.nvim',
    ft = 'lua', -- only load on lua files
    opts = {
      library = {
        { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
      },
    },
  },
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
      sources = {
        default = { 'lsp', 'path', 'lazydev', 'buffer' },
        providers = {
          lazydev = {
            name = 'LazyDev',
            module = 'lazydev.integrations.blink',
            score_offset = 100,
          },
          cmdline = { min_keyword_length = 2 },
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

-- lsp cconfig
vim.lsp.config('*', { capabilities = require('blink.cmp').get_lsp_capabilities() })
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('AuGroupLspAttach', { clear = true }),
  callback = function(args)
    local opts = { noremap = true, silent = true, buffer = args.data.bufnr }
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
  end,
})

-- lua
vim.lsp.config('lua_ls', {
  cmd = { 'lua-language-server' },
  filetypes = { 'lua' },
  root_markers = {
    '.luarc.json',
    '.luarc.jsonc',
    '.luacheckrc',
    '.stylua.toml',
    'stylua.toml',
    'selene.toml',
    'selene.yml',
    '.git',
  },
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
      completion = { enable = true },
      diagnostics = {
        enable = true,
        globals = { 'vim', 'describe' },
      },
      workspace = {
        library = {
          vim.api.nvim_get_runtime_file('', true),
        },
        maxPreload = 2000,
        preloadFileSize = 1000,
      },
      telemetry = { enable = false },
    },
  },
})
vim.lsp.enable('lua_ls')

vim.lsp.config('stylua', {
  cmd = { 'stylua', '--lsp' },
  filetypes = { 'lua' },
  root_markers = {
    '.stylua.toml',
    'stylua.toml',
  },
})
vim.lsp.enable('stylua')

-- python
vim.lsp.config('pyright', {
  cmd = { 'pyright-langserver', '--stdio' },
  filetypes = { 'python' },
  root_markers = {
    'pyproject.toml',
    'setup.py',
    'setup.cfg',
    'requirements.txt',
    '.git',
  },
  settings = {
    python = {
      analysis = {
        ignore = { '*' },
      },
    },
  },
})
vim.lsp.enable('pyright')

vim.lsp.config('ruff', {
  cmd = { 'ruff', 'server' },
  filetypes = { 'python' },
  root_markers = { { 'pyproject.toml', 'ruff.toml', '.ruff.toml' }, '.git' },
})
vim.lsp.enable('ruff')

-- c/cpp
vim.lsp.config('clangd', {
  cmd = { 'clangd', '--clang-tidy' },
  filetypes = { 'c', 'cpp' },
  root_markers = { { '.clangd', '.clang-format', '.clang-tidy' }, 'compile_commands.json', '.git' },
  on_attach = function(client, bufnr)
    local switch_header_source = function()
      local method_name = 'textDocument/switchSourceHeader'
      local params = vim.lsp.util.make_text_document_params(bufnr)
      client:request(method_name, params, function(err, result)
        if err then
          error(tostring(err))
        end
        if not result then
          vim.notify('Didn\'t find corresponding header/source file.')
          return
        end
        vim.cmd.edit(vim.uri_to_fname(result))
      end)
    end

    vim.keymap.set('n', '<leader>h', switch_header_source, { noremap = true, silent = true, buffer = bufnr })
  end,
})
vim.lsp.enable('clangd')

-- telescope keybindings
vim.keymap.set('n', 'ff', '<cmd>Telescope find_files<cr>', { silent = true })
vim.keymap.set('n', 'fh', '<cmd>Telescope find_files hidden=true<cr>', { silent = true })
vim.keymap.set('n', 'fb', '<cmd>Telescope buffers<cr>', { silent = true })
vim.keymap.set('n', 'fd', '<cmd>Telescope diagnostics bufnr=0<cr>', { silent = true })
vim.keymap.set('n', 'rg', '<cmd>Telescope live_grep<cr>', { silent = true })
vim.keymap.set('n', 'ss', '<cmd>Telescope grep_string<cr>', { silent = true })
