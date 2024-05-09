local telescope_status_ok, telescope = pcall(require, 'telescope')
if not telescope_status_ok then
  return
end

telescope.setup({
  defaults = {
    file_ignore_patterns = {
      'venv',
    },
    vimgrep_arguments = {
      'rg',
      '--pcre2',
      '--color=never',
      '--no-heading',
      '--with-filename',
      '--line-number',
      '--column',
      '--smart-case',
    },
  },
  extensions = {
    fzf = {
      fuzzy = true, -- false will only do exact matching
      override_generic_sorter = true, -- override the generic sorter
      override_file_sorter = true, -- override the file sorter
      case_mode = 'smart_case', -- or "ignore_case" or "respect_case" or "smart_case"
    },
  },
})

telescope.load_extension('fzf')

local function map(m, k, v)
  vim.keymap.set(m, k, v, { silent = true })
end

map('n', 'ff', '<cmd>Telescope find_files<cr>')
map('n', 'fh', '<cmd>Telescope find_files hidden=true<cr>')
map('n', 'fb', '<cmd>Telescope buffers<cr>')
map('n', 'fd', '<cmd>Telescope diagnostics bufnr=0<cr>')
map('n', 'rg', '<cmd>Telescope live_grep<cr>')
map('n', 'ss', '<cmd>Telescope grep_string<cr>')
map('n', 'gs', '<cmd>Telescope lsp_dynamic_workspace_symbols<cr>')
map('n', 'gr', '<cmd>Telescope lsp_references<cr>')
