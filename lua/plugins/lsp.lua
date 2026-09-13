-- Neovim 0.12 diagnostic leak workaround.
--
-- vim.lsp.diagnostic.handle_diagnostics() calls vim.fn.bufadd() for every
-- file the server publishes diagnostics for, then vim.diagnostic.set()
-- registers one "once" BufRead autocmd per unloaded buffer. rust-analyzer
-- publishes diagnostics for the whole workspace on every save, so buffers
-- that are never opened accumulate autocmds forever (500+ per save cycle in
-- the 100-exercises workspace). Each autocmd closure retains its converted
-- diagnostic tables, which grows the core process by ~2.5 MB per save and
-- several GB over a long session. Neovim master fixed this by checking
-- buffer load state in diagnostic/_store.lua; 0.12.4 does not have that fix.
--
-- Servers re-publish diagnostics on didOpen, so dropping notifications for
-- files that were never opened loses nothing: opening a file always produces
-- fresh diagnostics for it.
if vim.fn.has("nvim-0.13") == 0 then
  local orig = vim.lsp.handlers["textDocument/publishDiagnostics"]
  vim.lsp.handlers["textDocument/publishDiagnostics"] = function(err, params, ctx, config)
    local bufnr = params and params.uri and vim.uri_to_bufnr(params.uri) or nil
    if bufnr and vim.api.nvim_buf_is_loaded(bufnr) then
      return orig(err, params, ctx, config)
    end
  end
end

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
              .. "**/arm-zephyr-eabi-*,"
              .. "**/riscv64-zephyr-elf-*,"
              .. "/nix/store/*-gcc-wrapper-*/bin/*",
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
