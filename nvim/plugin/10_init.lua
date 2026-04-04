-- vim: foldmethod=marker foldlevel=0

-- {{{ Bootstrap
vim.pack.add({ 'https://github.com/nvim-mini/mini.nvim' })

-- Loading helpers used to organize config into fail-safe parts.
-- See also: `:h MiniMisc.safely()`
local misc = require('mini.misc')
local now = function(f) misc.safely('now', f) end
local later = function(f) misc.safely('later', f) end
local now_if_args = vim.fn.argc(-1) > 0 and now or later
local add = vim.pack.add

-- Define custom `vim.pack.add()` hook helper. See `:h vim.pack-events`.
local on_packchanged = function(plugin_name, kinds, callback, desc)
  local f = function(ev)
    local name, kind = ev.data.spec.name, ev.data.kind
    if not (name == plugin_name and vim.tbl_contains(kinds, kind)) then return end
    if not ev.data.active then vim.cmd.packadd(plugin_name) end
    callback()
  end
  Config.new_autocmd('PackChanged', '*', f, desc)
end
-- }}}

-- {{{ Colorscheme
now(function()
  add({ 'https://github.com/sainnhe/gruvbox-material' })

  -- nvim should detect terminal features and enable this automatically, but
  -- the combination of tmux + ssh + nixos leaves this disabled
  if not vim.o.termguicolors then vim.o.termguicolors = true end

  vim.g.gruvbox_material_foreground = 'mix'
  vim.g.gruvbox_material_statusline_style = 'mix'
  vim.g.gruvbox_material_sign_column_background = 'linenr'
  vim.g.gruvbox_material_diagnostic_text_highlight = 1
  vim.g.gruvbox_material_diagnostic_line_highlight = 1
  vim.g.gruvbox_material_diagnostic_virtual_text = 'highlighted'
  vim.cmd.colorscheme('gruvbox-material')
end)
-- }}}

-- {{{ Mini core (tabline, diff, icons, misc)
now(function()
  require('mini.tabline').setup()
  require('mini.extra').setup()
  require('mini.diff').setup()
  require('mini.misc').setup({ make_global = { 'put', 'put_text' } })

  require('mini.icons').setup()
  later(require('mini.icons').mock_nvim_web_devicons)
  later(require('mini.icons').tweak_lsp_kind)
end)
-- }}}

-- {{{ Mini editing (ai, bufremove, surround)
later(function()
  require('mini.ai').setup() -- Enables 'ciq' (change inside quotes) or 'cib' (change inside brackets), etc.
  require('mini.bufremove').setup()

  -- sa => surround around
  -- sd => surround delete
  -- sr => surround replace
  -- Example: Visual select a word -> sa"  (surround around quotes, 'saq' with mini.ai)
  require('mini.surround').setup()
end)
-- }}}

-- {{{ Statusline
now(function()
  require('mini.statusline').setup({
    set_vim_settings = false,
    use_icons = true,

    content = {
      active = function()
        -- local mode, hl_group = MiniStatusline.section_mode({ trunc_width = 1000 })
        -- local git         = MiniStatusline.section_git({ trunc_width = 75 })
        -- local diff        = MiniStatusline.section_diff({ trunc_width = 75 })
        -- local lsp         = MiniStatusline.section_lsp({ trunc_width = 75 })
        -- local fileinfo    = MiniStatusline.section_fileinfo({ trunc_width = 120 })
        -- local location    = MiniStatusline.section_location({ trunc_width = 75 })
        local diagnostics = MiniStatusline.section_diagnostics({ trunc_width = 75 })
        local filename = MiniStatusline.section_filename({ trunc_width = 100 })
        local search = MiniStatusline.section_searchcount({ trunc_width = 75 })

        return MiniStatusline.combine_groups({
          '%<', -- Mark general truncate point
          { hl = 'StatusLine', strings = { filename, diagnostics } },
          '%=', -- End left alignment
          { strings = { search } },
          { strings = { '%y %02l,%02c %P 0x%02B' } },
        })
      end,

      inactive = function()
        local filename = MiniStatusline.section_filename({ trunc_width = 140 })
        return MiniStatusline.combine_groups({
          { hl = 'StatusLineNC', strings = { filename } },
        })
      end,
    },
  })
end)
-- }}}

-- {{{ Mini navigation (visits, trailspace, jump, jump2d)
later(function()
  require('mini.visits').setup()
  require('mini.trailspace').setup({ only_in_normal_buffers = true })
  require('mini.jump').setup({ delay = { highlight = 50 } })
  -- Press CR to start jumping
  require('mini.jump2d').setup({
    labels = 'abcdefghijklmnopqrstu1234vwxyz',
    allowed_lines = { blank = false, cursor_at = false, fold = false },
  })
end)
-- }}}

-- {{{ Mini clue
later(function()
  local miniclue = require('mini.clue')

  miniclue.setup({
    window = { delay = 200, config = { width = 'auto' } },

    triggers = {
      { mode = 'n', keys = '<Leader>' },
      { mode = 'x', keys = '<Leader>' },
      { mode = 'n', keys = '<LocalLeader>' },
      { mode = 'x', keys = '<LocalLeader>' },
      { mode = 'n', keys = '\\' }, -- mini.basics
      { mode = 'n', keys = '[' }, -- mini.bracketed
      { mode = 'n', keys = ']' },
      { mode = 'x', keys = '[' },
      { mode = 'x', keys = ']' },
      { mode = 'i', keys = '<C-x>' }, -- Built-in completion
      { mode = 'n', keys = 'g' },
      { mode = 'x', keys = 'g' },
      { mode = 'n', keys = "'" }, -- Marks
      { mode = 'n', keys = '`' },
      { mode = 'x', keys = "'" },
      { mode = 'x', keys = '`' },
      { mode = 'n', keys = '"' }, -- Registers
      { mode = 'x', keys = '"' },
      { mode = 'i', keys = '<C-r>' },
      { mode = 'c', keys = '<C-r>' },
      { mode = 'n', keys = '<C-w>' }, -- Window commands
      { mode = 'n', keys = 'z' },
      { mode = 'x', keys = 'z' },
    },

    clues = {
      { mode = 'n', keys = '<leader>b', desc = '+Buffer' },
      { mode = 'n', keys = '<leader>f', desc = '+Find' },
      { mode = 'n', keys = '<leader>g', desc = '+Git' },
      { mode = 'x', keys = '<leader>g', desc = '+Git' },
      { mode = 'n', keys = '<leader>l', desc = '+LSP' },
      { mode = 'n', keys = '<leader>w', desc = '+Window' },
      { mode = 'n', keys = '<leader>x', desc = '+Quickfix' },
      { mode = 'n', keys = '<leader>t', desc = '+Toggle' },
      { mode = 'n', keys = '<Leader>h', desc = '+Harpoon' },

      miniclue.gen_clues.square_brackets(),
      miniclue.gen_clues.builtin_completion(),
      miniclue.gen_clues.g(),
      miniclue.gen_clues.marks(),
      miniclue.gen_clues.registers(),
      miniclue.gen_clues.windows(),
      miniclue.gen_clues.z(),
    },
  })
end)
-- }}}

-- {{{ Completion (mini.completion, mini.keymap, mini.snippets)
now_if_args(function()
  -- Don't show 'Text' suggestions (usually noisy) and show snippets last.
  local process_items_opts = { kind_priority = { Text = -1, Snippet = 99 } }
  local process_items = function(items, base)
    return MiniCompletion.default_process_items(items, base, process_items_opts)
  end

  require('mini.completion').setup({
    lsp_completion = {
      source_func = 'omnifunc',
      auto_setup = false,
      process_items = process_items,
    },
  })

  Config.new_autocmd('LspAttach', nil, function(args)
    vim.bo[args.buf].omnifunc = 'v:lua.MiniCompletion.completefunc_lsp'

    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client then
      vim.notify('+ ' .. client.name .. ' started', vim.log.levels.INFO, { timeout = 2000 })
    else
      vim.notify('cannot find client ' .. args.data.client_id, vim.log.levels.ERROR)
    end
  end, 'LSP on-attach')

  -- Advertise completion/signature capabilities to servers.
  vim.lsp.config('*', { capabilities = MiniCompletion.get_lsp_capabilities() })

  later(function()
    require('mini.keymap').setup()
    MiniKeymap.map_multistep('i', '<Tab>', { 'pmenu_next' })
    MiniKeymap.map_multistep('i', '<S-Tab>', { 'pmenu_prev' })
    MiniKeymap.map_multistep('i', '<CR>', { 'pmenu_accept' })
  end)

  local gen_loader = require('mini.snippets').gen_loader
  require('mini.snippets').setup({
    snippets = {
      gen_loader.from_lang(),
    },
  })

  -- Stop all sessions on Normal mode exit
  local make_stop = function()
    local au_opts = { pattern = '*:n', once = true }
    au_opts.callback = function()
      while MiniSnippets.session.get() do
        MiniSnippets.session.stop()
      end
    end
    vim.api.nvim_create_autocmd('ModeChanged', au_opts)
  end
  Config.new_autocmd('User', 'MiniSnippetsSessionStart', make_stop, 'Stop all snippet sessions on Normal mode exit')
end)
-- }}}

-- {{{ Mini git
later(function()
  local MiniGit = require('mini.git')
  MiniGit.setup({ command = { split = 'vertical' } })

  local align_blame = function(au_data)
    if au_data.data.git_subcommand ~= 'blame' then return end

    -- Align blame output with source
    local win_src = au_data.data.win_source
    vim.wo.wrap = false
    vim.fn.winrestview({ topline = vim.fn.line('w0', win_src) })
    vim.api.nvim_win_set_cursor(0, { vim.fn.line('.', win_src), 0 })

    -- Bind both windows so that they scroll together
    vim.wo[win_src].scrollbind, vim.wo.scrollbind = true, true
  end

  local au_opts = { pattern = 'MiniGitCommandSplit', callback = align_blame }
  vim.api.nvim_create_autocmd('User', au_opts)
end)
-- }}}

-- {{{ Mini hipatterns
later(function()
  local hipatterns = require('mini.hipatterns')

  hipatterns.setup({
    highlighters = {
      delay = {
        text_change = 600,
        scroll = 200,
      },

      -- Highlight standalone 'FIX', 'FIXME', 'HACK', 'TODO', 'NOTE'
      fixme = { pattern = '%f[%w]()FIXME()%f[%W]', group = 'MiniHipatternsFixme' },
      fix = { pattern = '%f[%w]()FIX()%f[%W]', group = 'MiniHipatternsFixme' },
      hack = { pattern = '%f[%w]()HACK()%f[%W]', group = 'MiniHipatternsHack' },
      todo = { pattern = '%f[%w]()TODO()%f[%W]', group = 'MiniHipatternsTodo' },
      note = { pattern = '%f[%w]()NOTE()%f[%W]', group = 'MiniHipatternsNote' },

      -- Highlight hex color strings (#rrggbb) using that color: #992233, #229933, #223399
      hex_color = hipatterns.gen_highlighter.hex_color(),
    },
  })
end)
-- }}}

-- {{{ Mini indentscope
later(function()
  require('mini.indentscope').setup({
    draw = {
      animation = require('mini.indentscope').gen_animation.none(),
    },
  })

  Config.new_autocmd('FileType', {
    'NvimTree',
    'bigfile',
    'dashboard',
    'help',
    'man',
    'minipick',
    'notify',
    'oil',
  }, function() vim.b.miniindentscope_disable = true end, 'Disable mini indent scope')
end)
-- }}}

-- {{{ Mini notify
now(function()
  require('mini.notify').setup({
    content = {
      -- Do not append timestamp to notifications
      format = function(notif) return notif.msg end,
    },
    window = { winblend = 0 },
  })

  vim.notify = require('mini.notify').make_notify()
  vim.api.nvim_create_user_command('Notifications', function() require('mini.notify').show_history() end, {})
end)
-- }}}

-- {{{ Mini pick
now_if_args(function()
  require('mini.pick').setup({
    window = { config = { width = vim.o.columns } },

    mappings = {
      choose = '<CR>',
      choose_in_split = '<C-s>',
      choose_in_vsplit = '<C-v>',
      choose_in_tabpage = '<C-t>',
      choose_marked = '<C-q>',
      mark = '<C-x>',
      mark_all = '<C-a>',
    },
  })

  vim.ui.select = MiniPick.ui_select

  -- Pick files from arglist (used as a Harpoon-style file list)
  MiniPick.registry.harpoon = function()
    local items = vim.fn.argv() --[[@as string[] ]]

    local picker_items = {}
    for i, arg in ipairs(items) do
      table.insert(picker_items, {
        text = string.format('%d: %s', i, arg),
        path = arg,
        arg_index = i,
      })
    end

    local choose = function(item)
      local win_id = MiniPick.get_picker_state().windows.target
      vim.api.nvim_win_call(win_id, function() vim.cmd(item.arg_index .. 'argument') end)
    end

    return MiniPick.start({ source = { items = picker_items, name = 'Harpoon', choose = choose } })
  end
end)
-- }}}

-- {{{ Misc plugins
now_if_args(function()
  add({
    'https://github.com/tpope/vim-sleuth', -- auto-detect shiftwidth, expandtab, etc.
    'https://github.com/varnishcache-friends/vim-varnish',
  })
end)
-- }}}

-- {{{ Treesitter
if not Config.on_nix then
  now_if_args(function()
    local ts_update = function() vim.cmd('TSUpdate') end
    on_packchanged('nvim-treesitter', { 'update' }, ts_update, ':TSUpdate')

    add({
      'https://github.com/nvim-treesitter/nvim-treesitter',
      'https://github.com/nvim-treesitter/nvim-treesitter-textobjects',
      'https://github.com/nvim-treesitter/nvim-treesitter-context',
    })

    local languages = {
      'bash',
      'c',
      'cue',
      'diff',
      'go',
      'html',
      'hurl',
      'javascript',
      'jsdoc',
      'json',
      'jsonc',
      'lua',
      'luadoc',
      'luap',
      'markdown',
      'markdown_inline',
      'nix',
      'printf',
      'python',
      'query',
      'regex',
      'terraform',
      'todotxt',
      'toml',
      'tsx',
      'typescript',
      'vim',
      'vimdoc',
      'xml',
      'yaml',
    }

    local disabled_files = {
      'Enums.hs',
      'all-packages.nix',
      'hackage-packages.nix',
      'generated.nix',
    }

    local function disable_treesitter_features(ev)
      if ev.match == 'sh' then return true end
      local short_name = vim.fn.fnamemodify(ev.file, ':t')
      return vim.tbl_contains(disabled_files, short_name)
    end

    -- Install missing parsers
    local isnt_installed = function(lang) return #vim.api.nvim_get_runtime_file('parser/' .. lang .. '.*', false) == 0 end
    local to_install = vim.tbl_filter(isnt_installed, languages)
    if #to_install > 0 then require('nvim-treesitter').install(to_install) end

    -- Start tree-sitter for each installed language's filetypes
    local filetypes = {}
    for _, lang in ipairs(languages) do
      for _, ft in ipairs(vim.treesitter.language.get_filetypes(lang)) do
        table.insert(filetypes, ft)
      end
    end

    Config.new_autocmd('FileType', filetypes, function(ev)
      if disable_treesitter_features(ev) then
        vim.notify('treesitter disabled for ' .. ev.file, vim.log.levels.DEBUG)
        return
      end
      vim.treesitter.start(ev.buf)
    end, 'Start tree-sitter')

    require('treesitter-context').setup({
      enable = true,
      max_lines = 3,
      min_window_height = 28,
      multiline_threshold = 3,
      mode = 'topline',
    })
  end)
end
-- }}}

-- {{{ LSP (nvim-lspconfig)
now_if_args(function()
  add({ 'https://github.com/neovim/nvim-lspconfig' })

  vim.diagnostic.config({
    signs = {
      priority = 9999,
      severity = { min = vim.diagnostic.severity.WARN, max = vim.diagnostic.severity.ERROR },
    },
    underline = { severity = { min = vim.diagnostic.severity.HINT, max = vim.diagnostic.severity.ERROR } },
    virtual_lines = false,
    virtual_text = {
      current_line = true,
      severity = { min = vim.diagnostic.severity.INFO },
    },
    update_in_insert = false,
    severity_sort = true,
    float = { source = true },
  })

  vim.lsp.log.set_level(vim.log.levels.ERROR)

  vim.lsp.enable({
    'basedpyright',
    'bashls',
    'cssls',
    'cue',
    'eslint',
    'gopls',
    'helm_ls',
    'html',
    'jsonnet_ls', -- go install github.com/grafana/jsonnet-language-server@latest
    'lua_ls',
    'marksman',
    'nil_ls', -- nix profile add nixpkgs#nil
    'rust_analyzer',
    'templ',
    'terraformls',
    'tofu_ls',
    'ts_ls',
    'yamlls',
  })
end)
-- }}}

-- {{{ Formatting (conform.nvim)
later(function()
  add({ 'https://github.com/stevearc/conform.nvim' })

  local xdg_config = vim.env.XDG_CONFIG_HOME or (vim.env.HOME .. '/.config')

  local function find_stylua_conf()
    local conf_paths = {
      vim.fn.getcwd() .. '/stylua.toml',
      vim.fn.getcwd() .. '/.stylua.toml',
      xdg_config .. '/' .. Config.nvim_appname .. '/stylua.toml',
    }
    for _, v in ipairs(conf_paths) do
      if vim.fn.filereadable(v) == 1 then return { '--config-path', v } end
    end
    return {}
  end

  require('conform').setup({
    log_level = vim.log.levels.ERROR,
    notify_on_error = true,

    default_format_opts = {
      lsp_format = 'fallback',
      async = false,
      timeout_ms = 2500,
    },

    formatters_by_ft = {
      -- go install mvdan.cc/gofumpt@latest
      -- go install golang.org/x/tools/cmd/goimports@latest
      go = { 'goimports', 'gofumpt' },
      jinja = { 'djlint', lsp_format = 'fallback' },
      htmldjango = { 'djlint', lsp_format = 'fallback' },
      html = { 'prettierd' },
      css = { 'prettierd', lsp_format = 'prefer' },
      scss = { 'prettierd', lsp_format = 'prefer' },
      graphql = { 'prettierd', lsp_format = 'fallback' },
      javascript = { 'prettierd', lsp_format = 'prefer' },
      jsonc = { 'prettierd', lsp_format = 'fallback' },
      markdown = { 'prettierd', lsp_format = 'prefer' },
      typescript = { 'prettierd', lsp_format = 'prefer' },
      yaml = { 'prettierd', 'trim_newlines', lsp_format = 'fallback' }, -- yamlfmt can break yaml blocks (key: |)
      hurl = { 'hurlfmt' },
      json = { 'jq' },
      jsonnet = { 'jsonnetfmt' },
      lua = { 'stylua', lsp_format = 'fallback' },
      nix = { 'nixfmt' },
      python = { 'ruff_format', 'ruff_organize_imports', lsp_format = 'fallback' },
      sh = { 'shfmt' },
      templ = { 'templ', lsp_format = 'fallback' },
      toml = { 'taplo', lsp_format = 'fallback' },
    },

    formatters = {
      yamlfmt = { prepend_args = { '-conf', xdg_config .. '/' .. Config.nvim_appname .. '/extra/yamlfmt' } },
      shfmt = { prepend_args = { '--indent', '4' } },
      ruff = { prepend_args = { '--ignore', 'F841' } },
      stylua = { prepend_args = find_stylua_conf },
      -- Organize imports accounting for local package/module (see gopls config)
      goimports = { command = 'goimports', prepend_args = Config.gopls.goimports_args },
    },
  })
end)
-- }}}

-- {{{ Linting (nvim-lint)
later(function()
  add({ 'https://github.com/mfussenegger/nvim-lint' })

  local lint = require('lint')

  lint.linters_by_ft = {
    python = { 'ruff' },
    ansible = { 'ansible_lint' },
    go = { 'golangcilint' },
    htmldjango = { 'djlint' },
    jinja = { 'djlint' },
    nix = { 'nix' },
    terraform = { 'tflint' },
    hcl = { 'tflint' },
    yaml = { 'yamllint' },
    cue = { 'cue' },
  }

  Config.new_autocmd({ 'BufReadPost', 'BufWritePost', 'InsertLeave' }, nil, function()
    lint.try_lint()
    if vim.bo.filetype ~= 'bigfile' then
      lint.try_lint('typos') -- run typos on all file types
    end
  end, 'Lint')
end)
-- }}}

-- {{{ Outline (outline.nvim)
later(function()
  add({ 'https://github.com/hedyhli/outline.nvim' })

  require('outline').setup({
    outline_window = { auto_jump = true },

    keymaps = {
      show_help = '?',
      close = { '<Esc>', 'q' },
      goto_location = '<Cr>',
      peek_location = 'o',
      goto_and_close = '<S-Cr>',
      restore_location = '<C-g>',
      hover_symbol = '<C-space>',
      toggle_preview = 'K',
      rename_symbol = 'r',
      code_actions = 'a',
      fold = 'h',
      unfold = 'l',
      fold_toggle = '<Tab>',
      fold_toggle_all = '<S-Tab>',
      fold_all = 'W',
      unfold_all = 'E',
      fold_reset = 'R',
      down_and_jump = '<C-j>',
      up_and_jump = '<C-k>',
    },
  })
end)
-- }}}

-- {{{ Quicker (quickfix improvements)
later(function()
  add({ 'https://github.com/stevearc/quicker.nvim' })
  require('quicker').setup()
end)
-- }}}

-- {{{ Oil (file explorer)
now_if_args(function()
  add({ 'https://github.com/stevearc/oil.nvim' })

  require('oil').setup({
    delete_to_trash = true,
    watch_for_changes = true,
    keymaps = {
      ['q'] = { 'actions.close', mode = 'n' },
      ['<C-h>'] = false,
      ['<C-l>'] = false,
      ['<C-s>'] = { 'actions.select', opts = { horizontal = true } },
      ['<C-Return>'] = { 'actions.select', opts = { vertical = true } },
    },
  })
end)
-- }}}
