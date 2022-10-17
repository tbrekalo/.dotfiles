local is_iron_ok, iron = pcall(require, 'iron.core')
if not is_iron_ok then
  return
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

    keymaps = {
      send_motion = '<leader>sc',
      visual_send = '<leader>sc',
      send_file = '<leader>sf',
      send_line = '<leader>sl',
      send_mark = '<leader>sm',
      mark_motion = '<leader>mc',
      mark_visual = '<leader>mc',
      remove_mark = '<leader>md',
      cr = '<leader>s<cr>',
      interrupt = '<leader>s<leader>',
      exit = '<leader>sq',
      clear = '<leader>cl',
    },
  },
})

local map = function(m, k, v, opts)
  opts = opts or { silent = true }
  vim.keymap.set(m, k, v, opts)
end

map('n', '<space>rs', '<cmd>IronRepl<cr>')
map('n', '<space>rr', '<cmd>IronRestart<cr>')
map('n', '<space>rf', '<cmd>IronFocus<cr>')
map('n', '<space>rh', '<cmd>IronHide<cr>')
