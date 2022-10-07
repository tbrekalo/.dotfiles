return {
  Lua = {
    cmd = { 'lua-language-server' },
    format = {
      enable = false,
    },
    filetypes = { 'lua' },
    runtime = {
      version = 'LuaJIT',
    },
    completion = { enable = true, callSnippet = 'Both' },
    diagnostics = {
      enable = true,
      globals = { 'vim', 'describe' },
    },
    workspace = {
      library = {
        vim.api.nvim_get_runtime_file('', true),
      },
      -- adjust these two values if your performance is not optimal
      maxPreload = 2000,
      preloadFileSize = 1000,
    },
    telemetry = { enable = false },
  },
}
