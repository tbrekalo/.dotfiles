local is_lua_dev_ok, lua_dev = pcall(require, 'lua-dev')
if not is_lua_dev_ok then
  return
end

lua_dev.setup({})
