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
            "--function-arg-placeholders=true",
            "--all-scopes-completion",
            "--fallback-style=llvm",
            "--query-driver="
              .. "/run/current-system/sw/bin/c++,"
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
        -- Mason packages Marksman as a generic .NET binary. NixOS does not
        -- expose ICU to it, so use .NET invariant-globalization mode.
        marksman = {
          cmd_env = {
            DOTNET_SYSTEM_GLOBALIZATION_INVARIANT = "1",
          },
        },
      },
    },
  },
}
