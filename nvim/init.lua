require('core.settings') -- has to go before because of the leader key
require('core.keybingins')

require('plugins.init_packer')
require('plugins.lsp.main')

require('plugins.nvim-treesitter')
require('plugins.luasnip')

require('plugins.lualine')
require('plugins.gitlinker')
require('plugins.telescope')
