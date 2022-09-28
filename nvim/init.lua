require('core.keybingins')
require('core.settings')

require('plugins.init_packer')

require('plugins.nvim-cmp')
require('plugins.null-ls')
require('plugins.lua-dev') -- lua dev has to go before lsp config
require('plugins.nvim-treesitter')
require('plugins.luasnip')
require('plugins.lsp')

require('plugins.lualine')
require('plugins.telescope')
