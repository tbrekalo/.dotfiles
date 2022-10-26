local is_orgmode_ok, orgmode = pcall(require, 'orgmode')
if not is_orgmode_ok then
  return
end

local is_local_cfg_ok, local_cfg = pcall(require, 'core.local')
if not is_local_cfg_ok then
  local_cfg = {
    DEFAULT_NOTES_FILE = '',
    DEFAULT_JOURNAL_FILE = '',
  }

  print('[WARNING] set core.local')
end

orgmode.setup_ts_grammar()
orgmode.setup({
  org_default_notes_file = local_cfg.DEFAULT_NOTES_FILE,
  win_split_mode = function(name)
    local bufnr = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_name(bufnr, name)

    local fill = 0.8
    local width = math.floor((vim.o.columns * fill))
    local height = math.floor((vim.o.lines * fill))
    local row = math.floor((((vim.o.lines - height) / 2) - 1))
    local col = math.floor(((vim.o.columns - width) / 2))

    vim.api.nvim_open_win(bufnr, true, {
      relative = 'editor',
      width = width,
      height = height,
      row = row,
      col = col,
      style = 'minimal',
      border = 'rounded',
    })
  end,

  org_capture_templates = {
    j = {
      description = 'Journal entry',
      template = '* %<%A %d-%m-%Y> log:\n** %?',
      target = local_cfg.DEFAULT_JOURNAL_FILE,
    },
  },
})
