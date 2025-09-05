-- Log level
vim.lsp.set_log_level(vim.log.levels.ERROR)

-- Diagnostics
vim.diagnostic.config({
  signs = { priority = 9999 },
  underline = true,
  update_in_insert = false, -- false so diags are updated on InsertLeave
  virtual_text = { current_line = true, severity = { min = "INFO" } },
  -- virtual_text = { current_line = true, severity = { min = "INFO", max = "WARN" } },
  -- virtual_lines = { current_line = true, severity = { min = "ERROR" } },
  severity_sort = true,
  float = {
    focusable = false,
    style = "minimal",
    border = "rounded",
    source = true,
    header = "",
  },
})

local custom_on_attach = function(client, bufnr)
  -- -- Set up 'mini.completion' LSP part of completion
  vim.bo[bufnr].omnifunc = "v:lua.MiniCompletion.completefunc_lsp"

  -- notify attachment
  ---@diagnostic disable-next-line: param-type-mismatch
  vim.notify("+ " .. client.name .. " started", vim.log.levels.INFO, {
    timeout = 2000,
  })
end

local group = vim.api.nvim_create_augroup("personal-lsp", { clear = true })

vim.api.nvim_create_autocmd("LspAttach", {
  group = group,
  callback = function(args)
    local client_id = args.data.client_id
    local client = vim.lsp.get_client_by_id(client_id)
    if client then
      custom_on_attach(client, args.buf)
    else
      vim.notify("cannot find client " .. client_id, vim.log.levels.ERROR)
    end
  end,
})

local capabilities = vim.tbl_deep_extend("force", vim.lsp.protocol.make_client_capabilities(), {})

-- Use same capabilities on every lsp
vim.lsp.config("*", { capabilities = capabilities })

vim.lsp.enable({
  "basedpyright",
  "bashls",
  "cssls",
  "cue",
  "eslint",
  "gopls",
  "helm_ls",
  "html",
  "jsonls",
  "jsonnet_ls", -- go install github.com/grafana/jsonnet-language-server@latest
  "lua_ls",
  "marksman",
  "nil_ls",
  "rust_analyzer",
  "templ",
  "tofu_ls",
  "ts_ls",
  "yamlls",
  "zk",
})
