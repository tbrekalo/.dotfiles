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
  -- styling
  'kyazdani42/nvim-web-devicons',
  'nvim-lualine/lualine.nvim',
  {
    'EdenEast/nightfox.nvim',
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd('colorscheme dayfox')
    end,
  },

  -- utility
  'chaoren/vim-wordmotion',
  {
    'tversteeg/registers.nvim',
    name = 'registers',
    keys = {
      { '"', mode = { 'n', 'v' } },
      { '<C-R>', mode = 'i' },
    },
    cmd = 'Registers',
  },

  -- tree sitter
  {
    'nvim-treesitter/nvim-treesitter',
    dependencies = { 'windwp/nvim-ts-autotag' },
    config = function()
      vim.cmd('TSUpdateSync')
    end,
  },

  -- lsp
  'neovim/nvim-lspconfig',
  'ray-x/lsp_signature.nvim',
  'jose-elias-alvarez/null-ls.nvim',

  -- autocomplete
  {
    'L3MON4D3/LuaSnip',
    build = 'make install_jsregexp',
  },

  {
    'hrsh7th/nvim-cmp',
    dependencies = {
      'hrsh7th/cmp-nvim-lsp-signature-help',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
    },
  },

  {
    'windwp/nvim-autopairs',
    config = function()
      require('nvim-autopairs').setup({})
    end,
  },

  -- formatting
  'lukas-reineke/indent-blankline.nvim',

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

  -- git
  'tpope/vim-fugitive',
  {
    'ruifm/gitlinker.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
  },
}

require('lazy').setup(plugins)
