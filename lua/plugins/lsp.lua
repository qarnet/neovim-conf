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
            "--query-driver="
              .. "**/xtensa-esp32-elf-*,"
              .. "**/xtensa-esp32s2-elf-*,"
              .. "**/xtensa-esp32s3-elf-*,"
              .. "**/riscv32-esp-elf-*,"
              .. "**/avr-gcc,"
              .. "**/avr-g++,"
              .. "**/arm-none-eabi-*,"
              .. "**/arm-zephyr-eabi-*",
          },
        },
      },
    },
  },
}
