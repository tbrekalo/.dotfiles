require('core.settings') -- has to go before because of the leader key
require('core.keybingins')

require('plugins.init_packer')

require('plugins.lsp.nvim-cmp') -- goes before lsp config
require('plugins.lsp.null-ls') -- goes before lsp config
require('plugins.lsp.lua-dev') -- goes before lsp config
require('plugins.lsp.lsp')

require('plugins.nvim-treesitter')
require('plugins.luasnip')

require('plugins.lualine')
require('plugins.gitlinker')
require('plugins.telescope')
