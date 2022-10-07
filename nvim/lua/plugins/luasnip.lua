local is_ls_ok, ls = pcall(require, 'luasnip')
if not is_ls_ok then
  return
end

ls.config.set_config({
  history = true,
})

local function add_binding(k, predicate, action)
  vim.keymap.set({ 'i', 's' }, k, function()
    if predicate() then
      action()
    end
  end, { silent = true })
end

add_binding('<c-k>', ls.expand_or_jumpable, function()
  ls.expand_or_jump()
end)

add_binding('<c-j>', function()
  return ls.jumpable(-1)
end, function()
  ls.jump(-1)
end)

add_binding('<c-l>', ls.choice_active, function()
  ls.change_choice(1)
end)

local s = ls.s
local i = ls.insert_node
local rep = require('luasnip.extras').rep
local fmt = require('luasnip.extras.fmt').fmt

ls.add_snippets('lua', {
  s(
    'pcall',
    fmt(
      'local is_{}_ok, {} = pcall(require, \'{}\')\n' .. 'if not is_{}_ok then\n' .. '  return\n' .. 'end\n',
      { i(1), rep(1), i(2), rep(1) }
    )
  ),
}, { key = 'lua' })
