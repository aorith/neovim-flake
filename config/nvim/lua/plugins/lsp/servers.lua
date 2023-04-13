-- lspconfig_server_name = { enabled = <boolean>, config = <config> }

local pyproject_path = require("core.utils").get_pyproject_path()

return {
  bashls = { config = { cmd = { "@bashls@/bin/bash-language-server", "start" } } },
  nil_ls = { config = { cmd = { "@nil@/bin/nil" } } },
  gopls = { config = { cmd = { "@gopls@/bin/gopls" } } },
  sqlls = { config = { cmd = { "@sqls@/bin/sqls" } } },
  tflint = { config = { cmd = { "@tflint@/bin/tflint" } } },
  yamlls = {
    config = {
      cmd = { "@yaml_language_server@/bin/yaml-language-server", "--stdio" },
      settings = { yaml = { keyOrdering = false } },
    },
  },
  tsserver = { config = { cmd = { "@typescript@/bin/typescript-language-server" } } },
  terraformls = { config = { cmd = { "@terraformls@/bin/terraform-ls" } } },
  marksman = { config = { cmd = { "@marksman@/bin/marksman", "server" } } },

  lua_ls = {
    config = {
      cmd = { "@lua_ls@/bin/lua-language-server" },
      settings = {
        Lua = {
          runtime = {
            -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
            version = "LuaJIT",
          },
          completion = {
            callSnippet = "Replace",
          },
          format = { enable = false },
          diagnostics = {
            -- Get the language server to recognize the `vim` global
            globals = { "vim" },
          },
          workspace = {
            -- Make the server aware of Neovim runtime files
            library = vim.api.nvim_get_runtime_file("", true),
            checkThirdParty = false,
          },
          telemetry = {
            enable = false,
          },
        },
      },
    },
  },

  pyright = {
    enabled = true,
    config = {
      cmd = { "@pyright@/bin/pyright-langserver", "--stdio" },
      settings = {
        {
          python = {
            analysis = {
              autoSearchPaths = true,
              diagnosticMode = "workspace",
              useLibraryCodeForTypes = true,
            },
          },
        },
      },
    },
  },
  ruff_lsp = {
    enabled = false, -- TODO: to be packaged
    config = {
      cmd = { "@ruff_lsp@/bin/ruff-lsp" },
      init_options = {
        settings = {
          -- Any extra CLI arguments for `ruff` go here.
          args = { "--config", pyproject_path },
        },
      },
    },
  },
}
