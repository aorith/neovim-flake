-------------------------------------------------------------------------------
-- mini.completion
-------------------------------------------------------------------------------
-- Push to the bottom of the menu 'Text' suggestions (usually noisy).
local process_items_opts = { kind_priority = { Text = 60 } }
local process_items = function(items, base) return MiniCompletion.default_process_items(items, base, process_items_opts) end

require('mini.completion').setup({
  lsp_completion = {
    source_func = 'omnifunc',
    auto_setup = false,
    process_items = process_items,
  },
})

NewAutocmd('mini-completion-lsp', nil, 'LspAttach', nil, function(args)
  vim.bo[args.buf].omnifunc = 'v:lua.MiniCompletion.completefunc_lsp'

  local client = vim.lsp.get_client_by_id(args.data.client_id)
  if client then
    vim.notify('+ ' .. client.name .. ' started', vim.log.levels.INFO, { timeout = 2000 })
  else
    vim.notify('cannot find client ' .. args.data.client_id, vim.log.levels.ERROR)
  end
end, 'LSP on-attach')

-- Advertise completion/signature capabilities to servers (see 'plugin/30_lsp.lua')
vim.lsp.config('*', { capabilities = MiniCompletion.get_lsp_capabilities() })

-------------------------------------------------------------------------------
-- mini.keymap
-------------------------------------------------------------------------------
require('mini.keymap').setup()
MiniKeymap.map_multistep({ 'i', 's' }, '<Tab>', { 'vimsnippet_next', 'pmenu_next' })
MiniKeymap.map_multistep({ 'i', 's' }, '<S-Tab>', { 'vimsnippet_prev', 'pmenu_prev' })
MiniKeymap.map_multistep('i', '<CR>', { 'pmenu_accept' })
