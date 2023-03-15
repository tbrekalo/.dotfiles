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

local plugins = {
  -- quality of life stuff
  'nvim-lua/plenary.nvim',

  -- git related plugins
  'tpope/vim-fugitive',
  'ruifm/gitlinker.nvim',

  -- automatic indentation and blanklines
  { 'lukas-reineke/indent-blankline.nvim', opts = {} },
  'tpope/vim-sleuth',

  -- lsp configuration
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      -- package managment for lsp
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',

      -- status updates for lsp
      { 'j-hui/fidget.nvim', opts = {} },

      -- additional lua configuration
      { 'folke/neodev.nvim', opts = {} },
    },
  },
  'jose-elias-alvarez/null-ls.nvim',

  -- autocomplete
  {
    'hrsh7th/nvim-cmp',
    dependencies = {
      'hrsh7th/cmp-nvim-lsp-signature-help',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      {
        'L3MON4D3/LuaSnip',
        build = 'make install_jsregexp',
      },
    },
  },

  -- styling
  'kyazdani42/nvim-web-devicons',
  {
    'EdenEast/nightfox.nvim',
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd('colorscheme dayfox')
    end,
  },

  {
    'nvim-lualine/lualine.nvim',
    opts = {
      theme = 'nightfox',
      component_separators = '|',
      section_separators = '',
    },
  },

  -- utility
  'chaoren/vim-wordmotion',
  { 'numToStr/Comment.nvim', opts = {} },

  -- tree sitter
  {
    'nvim-treesitter/nvim-treesitter',
    dependencies = { 'windwp/nvim-ts-autotag' },
    config = function()
      vim.cmd('TSUpdateSync')
    end,
  },

  {
    'windwp/nvim-autopairs',
    config = function()
      require('nvim-autopairs').setup({})
    end,
  },

  -- file navigation
  {
    'nvim-telescope/telescope.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = [[
          cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && 
          cmake --build build --config Release && 
          cmake --install build --prefix build
        ]],
      },
    },
  },

  -- REPL
  'hkupty/iron.nvim',
}

require('lazy').setup(plugins)