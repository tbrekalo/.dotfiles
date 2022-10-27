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
  win_split_mode = 'float',

  org_capture_templates = {
    t = {
      description = 'Todo items',
      template = '* TODO [/] %U: %?\n',
      target = local_cfg.DEFAULT_TODO_FILE,
    },
    j = {
      description = 'Journal entry',
      template = '* %<%A %d-%m-%Y> log:\n  - %?',
      target = local_cfg.DEFAULT_JOURNAL_FILE,
    },
    r = {
      description = 'Revision question',
      template = '* %U %? \n',
    },
  },
})
