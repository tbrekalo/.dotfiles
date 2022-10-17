local bootstrap_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'

  local is_bootstrapped = false
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({
      'git',
      'clone',
      'https://github.com/wbthomason/packer.nvim',
      install_path,
    })
    print('Installing packer...')
    vim.api.nvim_command('packadd packer.nvim')
  end

  return is_bootstrapped, require('packer')
end

local is_bootstrapped, packer = bootstrap_packer()

packer.init({
  enable = true, -- enable profiling via :PackerCompile profile=true
  threshold = 0, -- the amount in ms that a plugins load time must be over for it to be included in the profile
  max_jobs = 20, -- Limit the number of simultaneous jobs. nil means no limit. Set to 20 in order to prevent PackerSync form being "stuck" -> https://github.com/wbthomason/packer.nvim/issues/746
  -- Have packer use a popup window
  display = {
    open_fn = function()
      return require('packer.util').float({ border = 'rounded' })
    end,
  },
})

-- Autocommand that reloads neovim whenever you save the packer_init.lua file
local packer_group = vim.api.nvim_create_augroup('packer_user_config', { clear = true })
vim.api.nvim_create_autocmd('BufWritePost', {
  pattern = 'init_packer.lua',
  command = 'source <afile> | PackerSync',
  group = packer_group,
})

-- manage plugins
return packer.startup(function(use)
  -- self manage packer
  use('wbthomason/packer.nvim')

  -- quality of life
  use('lewis6991/impatient.nvim')
  use({
    'tversteeg/registers.nvim',
    config = function()
      require('registers').setup()
    end,
  })

  -- styling
  use('kyazdani42/nvim-web-devicons')
  use('EdenEast/nightfox.nvim')
  use('folke/tokyonight.nvim')
  use('nvim-lualine/lualine.nvim')
  vim.cmd('colorscheme tokyonight-storm')

  -- file navigation
  use({
    'nvim-telescope/telescope.nvim',
    tag = '0.1.0',
    requires = {
      { 'nvim-lua/plenary.nvim' },
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        run = [[
          cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && 
          cmake --build build --config Release && 
          cmake --install build --prefix build
        ]],
      },
    },
  })

  -- lsp
  use('neovim/nvim-lspconfig')
  use('jose-elias-alvarez/null-ls.nvim')
  use({
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate',
  })
  use('folke/nodedev.nvim')
  use('nickeb96/fish.vim')

  -- autocomplete
  use({
    'L3MON4D3/LuaSnip',
    run = 'make install_jsregexp',
  })
  use({
    'hrsh7th/nvim-cmp',
    requires = {
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-buffer',

      'mtoohey31/cmp-fish',
      'saadparwaiz1/cmp_luasnip',
    },
  })

  use('windwp/nvim-ts-autotag')
  use('ray-x/lsp_signature.nvim')

  -- formatting
  use('lukas-reineke/indent-blankline.nvim')
  use({
    'windwp/nvim-autopairs',
    config = function()
      require('nvim-autopairs').setup({})
    end,
  })

  -- git
  use('tpope/vim-fugitive')
  use({
    'ruifm/gitlinker.nvim',
    requires = 'nvim-lua/plenary.nvim',
  })

  if is_bootstrapped then
    packer.sync()
  end
end)
