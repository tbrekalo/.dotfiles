local cmp_status_ok, cmp = pcall(require, 'cmp')
if not cmp_status_ok then
  return
end

-- TODO: avoid early return on failure
local luasnip_status_ok, luasnip = pcall(require, 'luasnip')
if not luasnip_status_ok then
  return
end

cmp.setup({
  -- Load snippet support
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },

  -- Completion settings
  completion = {
    --completeopt = 'menu,menuone,noselect'
    keyword_length = 2,
  },

  preselect = cmp.PreselectMode.None,

  -- Key mapping
  mapping = {
    ['<C-n>'] = cmp.mapping.select_next_item(),
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-e>'] = cmp.mapping.close(),
    ['<C-y>'] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    }),
  },

  -- Load sources, see: https://github.com/topics/nvim-cmp
  sources = {
    { name = 'luasnip' },
    { name = 'orgmode' },
    { name = 'nvim_lsp' },
    { name = 'nvim-lua' },
    { name = 'buffer', keyword_length = 3 },
    { name = 'fish' },
    { name = 'path' },
  },

  experimental = {
    native_menu = false,
    ghost_text = true,
  },
}) -- If you want insert `(` after select function or method item

local cmp_autopairs = require('nvim-autopairs.completion.cmp')
cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())
