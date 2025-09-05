-- https://github.com/redhat-developer/yaml-language-server
local schemastore = require("schemastore")

---@type vim.lsp.Config
return {
  on_init = function(client)
    require("aorith.core.yaml_schema").get_client()
    client.server_capabilities.documentFormattingProvider = nil
    client.server_capabilities.documentRangeFormattingProvider = nil
  end,

  settings = {
    redhat = { telemetry = { enabled = false } },

    yaml = {
      validate = true,
      format = { enable = false },
      keyOrdering = false,
      hover = true,
      completion = true,

      schemaStore = {
        enable = false,
        url = "",
        -- url = "https://www.schemastore.org/api/json/catalog.json",
      },

      -- schemas detected by filename
      schemas = vim.tbl_extend("error", schemastore.yaml.schemas(), {
        -- TODO: 'Matches multiple schemas when only one must validate'
        -- ["kubernetes"] = { "clusters/**/*.{yml,yaml}" },

        ["https://json.schemastore.org/kustomization.json"] = "kustomization.{yml,yaml}",
        ["https://raw.githubusercontent.com/docker/compose/master/compose/config/compose_spec.json"] = "{docker-,}compose*.{yml,yaml}",
        ["https://raw.githubusercontent.com/datreeio/CRDs-catalog/main/argoproj.io/application_v1alpha1.json"] = "argocd-application.{yml,yaml}",
        ["https://json.schemastore.org/github-workflow.json"] = ".github/workflows/*.{yml,yaml}",

        -- or add a comment on the file:
        -- # yaml-language-server: $schema=<urlToTheSchema>
      }),

      -- custom option to select schemas by name with 'YAMLSchemaSelect' (aorith.core.yaml_schema)
      -- [<uri>] = <name>
      custom_schemas = {
        ["https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/v1.25.16-standalone-strict/all.json"] = "k8s-1.25.16",
        ["https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/v1.31.4-standalone-strict/all.json"] = "k8s-1.31.4",
      },
    },
  },
}
