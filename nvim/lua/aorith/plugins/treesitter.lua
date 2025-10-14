local ensure_languages = {
  "bash",
  "c",
  "diff",
  "go",
  "html",
  "javascript",
  "jsdoc",
  "json",
  "jsonc",
  "lua",
  "luadoc",
  "luap",
  "markdown",
  "markdown_inline",
  "printf",
  "python",
  "query",
  "regex",
  "toml",
  "tsx",
  "typescript",
  "vim",
  "vimdoc",
  "xml",
  "yaml",
}

local disabled_files = {
  "Enums.hs",
  "all-packages.nix",
  "hackage-packages.nix",
  "generated.nix",
}

local function disable_treesitter_features(bufnr)
  local fname = vim.api.nvim_buf_get_name(bufnr)
  local short_name = vim.fn.fnamemodify(fname, ":t")
  return vim.tbl_contains(disabled_files, short_name)
end

-- Install missing languages
if not Config.on_nix then
  local isnt_installed = function(lang) return #vim.api.nvim_get_runtime_file("parser/" .. lang .. ".*", false) == 0 end
  local to_install = vim.tbl_filter(isnt_installed, ensure_languages)
  if #to_install > 0 then require("nvim-treesitter").install(to_install) end
end

-- Ensure tree-sitter enabled after opening a file for target language
local filetypes = {}
for _, lang in ipairs(ensure_languages) do
  for _, ft in ipairs(vim.treesitter.language.get_filetypes(lang)) do
    table.insert(filetypes, ft)
  end
end
local ts_start = function(ev)
  if disable_treesitter_features(ev.buf) then return end
  vim.treesitter.start(ev.buf)
end
Config.new_autocmd("FileType", filetypes, ts_start, "Start tree-sitter")

require("treesitter-context").setup({
  enable = true,
  multiwindow = false,
  max_lines = 0,
  min_window_height = 0,
  line_numbers = true,
  multiline_threshold = 10, -- Maximum number of lines to show for a single context
  trim_scope = "outer",
  mode = "cursor",
  separator = "-",
})
