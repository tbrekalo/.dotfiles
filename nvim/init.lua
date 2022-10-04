require('core.keybingins')
require('core.settings')

require('plugins.init_packer')

require('plugins.nvim-cmp')
require('plugins.null-ls') -- goes before lsp config
require('plugins.lua-dev') -- goes before lsp config
require('plugins.nvim-treesitter')
require('plugins.luasnip')
require('plugins.lsp')

require('plugins.lualine')
require('plugins.gitlinker')
require('plugins.telescope')
