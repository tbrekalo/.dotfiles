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

-- better editing experience
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

-- enable experimental ui2
require('vim._core.ui2').enable({})

-- tab settings
vim.keymap.set('n', 'gn', vim.cmd.tabnew, { silent = true })
vim.keymap.set('n', 'gx', vim.cmd.tabclose, { silent = true })

-- movement
vim.keymap.set('n', '<C-u>', function()
  vim.cmd('normal! \x15')
  vim.cmd('normal! zz')
end)
vim.keymap.set('n', '<C-d>', function()
  vim.cmd('normal! \x04')
  vim.cmd('normal! zz')
end)

-- plugin build steps (run on install/update via the builtin package manager)
vim.api.nvim_create_autocmd('PackChanged', {
  group = vim.api.nvim_create_augroup('AuGroupPackBuild', { clear = true }),
  callback = function(args)
    local kind = args.data.kind
    local name = args.data.spec.name
    if name == 'telescope-fzf-native.nvim' and (kind == 'install' or kind == 'update') then
      vim.notify('Building telescope-fzf-native.nvim')
      vim.system({ 'cmake', '-S.', '-Bbuild', '-DCMAKE_BUILD_TYPE=Release' }, { cwd = args.data.path }):wait()
      vim.system({ 'cmake', '--build', 'build', '--config', 'Release' }, { cwd = args.data.path }):wait()
    elseif name == 'nvim-treesitter' and kind == 'update' then
      -- parsers for configured languages are installed at startup; refresh them on update
      vim.cmd('TSUpdate')
    end
  end,
})

-- plugins (neovim 0.12 builtin package manager)
vim.pack.add({
  { src = 'https://github.com/tpope/vim-fugitive' },
  { src = 'https://github.com/folke/lazydev.nvim' },
  { src = 'https://github.com/saghen/blink.cmp', version = vim.version.range('*') },
  { src = 'https://github.com/nvim-lua/plenary.nvim' },
  { src = 'https://github.com/nvim-telescope/telescope-fzf-native.nvim' },
  { src = 'https://github.com/nvim-telescope/telescope.nvim' },
  { src = 'https://github.com/nvim-treesitter/nvim-treesitter', version = 'main' },
  { src = 'https://github.com/windwp/nvim-ts-autotag' },
  { src = 'https://github.com/windwp/nvim-autopairs' },
  { src = 'https://github.com/EdenEast/nightfox.nvim' },
})

-- lazydev
require('lazydev').setup({
  library = {
    { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
  },
})

-- blink.cmp
require('blink.cmp').setup({
  appearance = {
    highlight_ns = vim.api.nvim_create_namespace('blink_cmp'),
    nerd_font_variant = 'mono',
  },
  fuzzy = {
    use_proximity = true,
    implementation = 'lua',
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
})

-- telescope
local telescope = require('telescope')
telescope.setup({
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
      fuzzy = true,
      override_generic_sorter = true,
      override_file_sorter = true,
      case_mode = 'smart_case',
    },
  },
})
telescope.load_extension('fzf')

-- treesitter
local treesitter = require('nvim-treesitter')
local treesitter_languages = { 'cmake', 'cpp', 'json', 'lua', 'python' }
treesitter.install(treesitter_languages)
require('nvim-ts-autotag').setup()
vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('AuGroupTreesitterSetup', { clear = true }),
  pattern = treesitter_languages,
  callback = function()
    vim.treesitter.start()
  end,
})

-- autopairs
require('nvim-autopairs').setup()

-- colorscheme
vim.cmd('colorscheme terafox')

-- lsp cconfig
vim.lsp.config('*', { capabilities = require('blink.cmp').get_lsp_capabilities() })
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('AuGroupLspAttach', { clear = true }),
  callback = function(args)
    local opts = { noremap = true, silent = true, buffer = args.buf }
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

-- stylua has no language server, so run it directly to format lua buffers on save
vim.api.nvim_create_autocmd('BufWritePre', {
  group = vim.api.nvim_create_augroup('AuGroupStylua', { clear = true }),
  pattern = '*.lua',
  callback = function(args)
    local input = table.concat(vim.api.nvim_buf_get_lines(args.buf, 0, -1, false), '\n')
    local result = vim.system({ 'stylua', '-' }, { stdin = input, text = true }):wait()
    if result.code ~= 0 then
      vim.notify('stylua: ' .. (result.stderr or 'failed'), vim.log.levels.ERROR)
      return
    end
    local formatted = vim.split((result.stdout or ''):gsub('\n$', ''), '\n')
    vim.api.nvim_buf_set_lines(args.buf, 0, -1, false, formatted)
  end,
})

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
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
        diagnosticMode = 'openFilesOnly',
      },
    },
  },
})
vim.lsp.enable('pyright')

vim.lsp.config('ruff', {
  cmd = { 'ruff', 'server' },
  filetypes = { 'python' },
  root_markers = { { 'pyproject.toml', 'ruff.toml', '.ruff.toml' }, '.git' },
  settings = {},
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
