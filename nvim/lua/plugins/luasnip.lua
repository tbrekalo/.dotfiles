local is_ls_ok, ls = pcall(require, 'luasnip')
if not is_ls_ok then
  return
end

ls.config.set_config {
  history = true,
}

local function add_binding(k, predicate, action)
  vim.keymap.set({ 'i', 's' }, k, function()
    if predicate() then
      action()
    end
  end, { silent = true })
end

add_binding('<c-k>',
  ls.expand_or_jumpable,
  function() ls.expand_or_jump() end)

add_binding('<c-j>',
  function() return ls.jumpable(-1) end,
  function() ls.jump(-1) end)

add_binding('<c-l>',
  ls.choice_active,
  function() ls.change_choice(1) end)

ls.add_snippets('lua', {
  ls.parser.parse_snippet('pcall',
    'local is_$1_ok, $1 = pcall(require, \'$2\')\n' ..
    'if not is_$1_ok then\n' ..
    '  return\n' ..
    'end\n')
}, { key = 'lua' })

