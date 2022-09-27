local is_nls_ls_ok, nls = pcall(require, 'null-ls')
if not is_nls_ls_ok then
  return
end

local formatting = nls.builtins.formatting
local diagnostics = nls.builtins.diagnostics

nls.setup {
  sources = {
    diagnostics.fish,
    diagnostics.pylint,

    formatting.autopep8,
    formatting.cmake_format,
    formatting.fish_indent,
  }
}
