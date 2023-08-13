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
  'tpope/vim-rhubarb',
  'ruifm/gitlinker.nvim',

  -- automatic indentation and blanklines
  { 'lukas-reineke/indent-blankline.nvim', opts = {} },

  -- lsp configuration
  { 'neovim/nvim-lspconfig' }, -- Required

  -- autocompletion
  { 'hrsh7th/nvim-cmp' }, -- Required
  { 'hrsh7th/cmp-nvim-lsp' }, -- Required
  { 'hrsh7th/cmp-buffer' }, -- Optional
  { 'hrsh7th/cmp-path' }, -- Optional
  { 'saadparwaiz1/cmp_luasnip' }, -- Optional
  { 'hrsh7th/cmp-nvim-lua' }, -- Optional

  -- snippets
  {
    'L3MON4D3/LuaSnip',
    build = 'make install_jsregexp',
    dependencies = {
      'rafamadriz/friendly-snippets',
      config = function()
        require('luasnip.loaders.from_vscode').lazy_load()
      end,
    },
  },

  -- formatting
  'jose-elias-alvarez/null-ls.nvim',

  -- status updates for lsp
  { 'j-hui/fidget.nvim', tag = 'legacy', opts = {} },

  -- additional lua configuration
  { 'folke/neodev.nvim', opts = {} },

  -- styling
  'nvim-tree/nvim-web-devicons',
  {
    'EdenEast/nightfox.nvim',
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd('colorscheme terafox')
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

  -- navigation
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
}

require('lazy').setup(plugins)
