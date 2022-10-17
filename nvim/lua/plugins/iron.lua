local is_iron_ok, iron = pcall(require, 'iron.core')
if not is_iron_ok then
  return
end

local map = function(m, k, v, opts)
  opts = opts or { silent = true }
  vim.keymap.set(m, k, v, opts)
end

iron.setup({
  config = {
    scratch_repl = true,
    repl_definition = {
      fish = {
        command = { 'fish' },
      },
      python = require('iron.fts.python').ipython,
    },

    repl_open_cmd = require('iron.view').split.vertical.botright(0.5),
  },
})

map('n', '<leader>is', '<cmd>IronRepl<cr>')
map('n', '<leader>ir', '<cmd>IronRestart<cr>')
map('n', '<leader>if', '<cmd>IronFocus<cr>')
map('n', '<leader>ih', '<cmd>IronHide<cr>')
map('n', '<leader>il', iron.send_line)
map('n', '<leader>ib', iron.send_file)
map('v', '<leader>is', iron.visual_send)
