local g = vim.g
local o = vim.o

-- update time
o.timeoutlen = 500
o.updatetime = 200

-- number line
o.number = true

-- Better editing experience
o.expandtab = true
o.smarttab = true
o.cindent = true
o.autoindent = true
o.wrap = true
o.textwidth = 300
o.tabstop = 2
o.shiftwidth = 2
o.softtabstop = -1 -- If negative, shiftwidth value is used
o.list = true
o.listchars = 'trail:·,nbsp:◇,tab:→ ,extends:▸,precedes:◂'

-- share clipboard with OS
o.clipboard = 'unnamedplus'

-- smart case search setup
o.ignorecase = true
o.smartcase = true

-- undo and backup options
o.backup = false
o.writebackup = false
o.undofile = true
o.swapfile = false
o.backupdir = '/tmp/'
o.directory = '/tmp/'
o.undodir = '/tmp/'

-- map <leader> to space
g.mapleader = ' '
g.maplocalleader = ' '

-- skip some remote provider loading
g.loaded_python3_provider = 0
g.loaded_node_provider = 0
g.loaded_perl_provider = 0
g.loaded_ruby_provider = 0


local terminal_group = vim.api.nvim_create_augroup('TerminalGroup', {})
vim.api.nvim_create_autocmd('TermOpen', {
  group = terminal_group,
  callback = function()
    vim.wo.number = false
    vim.wo.relativenumber = false
  end,
})

local help_group = vim.api.nvim_create_augroup('HelpGroup', {})
vim.api.nvim_create_autocmd('FileType', {
  group = help_group,
  pattern = 'help',
  command = 'wincmd L',
})

