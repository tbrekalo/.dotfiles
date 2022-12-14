require('core.settings') -- has to go before because of the leader key
require('core.keybingins')

require('plugins.init_packer') -- has to go before all plugin configurations
require('impatient')
require('plugins.lsp.main')

require('plugins.nvim-treesitter')
require('plugins.luasnip')

-- require('plugins.leap')
require('plugins.gitlinker')
require('plugins.iron')
require('plugins.lualine')
require('plugins.orgmode')
require('plugins.telescope')
