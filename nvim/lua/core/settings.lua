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
