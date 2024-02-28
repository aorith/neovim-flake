require("luasnip.loaders.from_vscode").lazy_load()

local cmp = require("cmp")
local defaults = require("cmp.config.default")()
local luasnip = require("luasnip")
local lspkind = require("lspkind")
local cmp_borders = cmp.config.window.bordered()

---@diagnostic disable-next-line: missing-fields
cmp.setup({
  window = {
    completion = cmp_borders,
    documentation = cmp_borders,
  },

  snippet = {
    expand = function(args) luasnip.lsp_expand(args.body) end,
  },

  mapping = cmp.mapping.preset.insert({
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item({ behavior = cmp.SelectBehavior.Insert })
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end),
    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item({ behavior = cmp.SelectBehavior.Insert })
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end),

    ["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
    ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<C-e>"] = cmp.mapping.abort(),
    ["<CR>"] = cmp.mapping.confirm({ select = true }),
    ["<S-CR>"] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    }),
  }),

  sources = cmp.config.sources({
    { name = "nvim_lsp", priority = 99 },
    { name = "nvim_lsp_signature_help", keyword_length = 3 },
    { name = "luasnip" },
    { name = "buffer", keyword_length = 3 },
    { name = "path" },
  }),

  enabled = function() return vim.bo[0].buftype ~= "prompt" end,
  experimental = {
    native_menu = false,
    ghost_text = true,
  },

  ---@diagnostic disable-next-line: missing-fields
  formatting = {
    format = lspkind.cmp_format({
      mode = "symbol_text",
      with_text = true,
      maxwidth = 55,
      ellipsis_char = "…",
      menu = {
        buffer = "[BUF]",
        nvim_lsp = "[LSP]",
        nvim_lsp_signature_help = "[LSP]",
        nvim_lsp_document_symbol = "[LSP]",
        nvim_lua = "[API]",
        path = "[PATH]",
        luasnip = "[SNIP]",
      },
    }),
  },

  sorting = defaults.sorting,
})

cmp.setup.filetype("lua", {
  sources = cmp.config.sources({
    { name = "nvim_lua" },
    { name = "nvim_lsp", keyword_length = 3 },
    { name = "path" },
  }),
})

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ "/", "?" }, {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = "nvim_lsp_document_symbol", keyword_length = 3 },
    { name = "buffer" },
    { name = "cmdline_history" },
  },
  view = {
    entries = { name = "wildmenu", separator = "|" },
  },
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(":", {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = "cmdline" },
    { name = "cmdline_history" },
    { name = "path" },
  }),
})
