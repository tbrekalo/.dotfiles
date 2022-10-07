local is_gitlinker_ok, gitlinker = pcall(require, 'gitlinker')
if not is_gitlinker_ok then
  return
end

gitlinker.setup({})
