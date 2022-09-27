local telescope_status_ok, telescope = pcall(require, 'telescope')
if not telescope_status_ok then
  return
end

telescope.setup({
  extensions = {
      fzf = {
        fuzzy = true, -- false will only do exact matching
        override_generic_sorter = true, -- override the generic sorter
        override_file_sorter = true, -- override the file sorter
        case_mode = "smart_case", -- or "ignore_case" or "respect_case" or "smart_case"
      },
  }
})

telescope.load_extension('fzf')

local function map(m, k, v)
  vim.keymap.set(m, k, v, { silent = true })
end

map('n', 'ff', '<cmd>Telescope find_files hidden=true<cr>')
map('n', 'fb', '<cmd>Telescope buffers<cr>')
map('n', 'fd', '<cmd>Telescope diagnostics<cr>')
map('n', 'rg', '<cmd>Telescope live_grep<cr>')
map('n', 'gs', '<cmd>Telescope lsp_workspace_symbols<cr>')
