return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        clangd = {
          cmd = {
            "clangd",
            "--background-index",
            "--header-insertion=never",
            "--completion-style=detailed",
            "--function-arg-placeholders",
            "--all-scopes-completion",
            "--fallback-style=llvm",
            "--query-driver=**/xtensa-esp32-elf-gcc,**/xtensa-esp32-elf-g++",
          },
          init_options = {
            usePlaceholders = true,
            completeUnimported = true,
            clangdFileStatus = true,
          },
        },
      },
    },
  },
}
