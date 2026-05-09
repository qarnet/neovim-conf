return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        clangd = {
          cmd = {
            "clangd",
            "--background-index",
            "--clang-tidy",
            "--header-insertion=never",
            "--completion-style=detailed",
            "--function-arg-placeholders",
            "--all-scopes-completion",
            "--fallback-style=llvm",
            "--query-driver=**/xtensa-esp32-elf-gcc,**/xtensa-esp32-elf-g++",
          },
        },
      },
    },
  },
}
