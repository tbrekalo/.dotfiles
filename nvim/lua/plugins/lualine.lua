-- Eviline config for lualine
-- Author: shadmansaleh
-- Credit: glepnir
local lualine_status_ok, lualine = pcall(require, 'lualine')
if not lualine_status_ok then
  return
end

lualine.setup()
