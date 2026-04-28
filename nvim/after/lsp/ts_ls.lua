-- https://github.com/typescript-language-server/typescript-language-server/
return {
  init_options = {
    hostInfo = 'neovim',
    locale = 'en',
    preferences = {
      providePrefixAndSuffixTextForRename = false,
      allowRenameOfImportPath = false,
    },
  },
  settings = {
    diagnostics = {
      ignoredCodes = {},
    },
  },
}
