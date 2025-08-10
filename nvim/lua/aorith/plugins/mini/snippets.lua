local gen_loader = require("mini.snippets").gen_loader
require("mini.snippets").setup({
  snippets = {
    -- Load custom file with global snippets first
    -- gen_loader.from_file("~/.config/nvim/snippets/global.json"),

    -- Load snippets based on current language by reading files from
    -- "snippets/" subdirectories from 'runtimepath' directories.
    gen_loader.from_lang(),
  },
})

-- Stop all sessions on Normal mode exit
local make_stop = function()
  local au_opts = { pattern = "*:n", once = true }
  au_opts.callback = function()
    while MiniSnippets.session.get() do
      MiniSnippets.session.stop()
    end
  end
  vim.api.nvim_create_autocmd("ModeChanged", au_opts)
end
local opts = { pattern = "MiniSnippetsSessionStart", callback = make_stop }
vim.api.nvim_create_autocmd("User", opts)
