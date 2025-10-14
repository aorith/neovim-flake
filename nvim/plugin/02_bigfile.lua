-- Bigfile (https://github.com/folke/snacks.nvim/blob/e937bfaa741c4ac7379026b09ec252bd7a9409a6/lua/snacks/bigfile.lua#L19C1-L32C5)
local size = 1.5 * 1024 * 1024 -- 1.5MB

vim.filetype.add({
  pattern = {
    [".*"] = {
      function(path, buf) return vim.bo[buf] and vim.bo[buf].filetype ~= "bigfile" and path and vim.fn.getfsize(path) > size and "bigfile" or nil end,
    },
  },
})

local function on_bigfile(ev)
  vim.b.minianimate_disable = true
  vim.schedule(function()
    vim.bo[ev.buf].syntax = ev.ft
    vim.wo[0][0].cursorlineopt = "number"
  end)
  local path = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(ev.buf), ":p:~:.")
  vim.notify(("Big file detected `%s`."):format(path))
end

Config.new_autocmd("FileType", "bigfile", function(ev)
  vim.api.nvim_buf_call(ev.buf, function()
    on_bigfile({
      buf = ev.buf,
      ft = vim.filetype.match({ buf = ev.buf }) or "",
    })
  end)
end, "Bigfile")
