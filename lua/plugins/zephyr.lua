-- Zephyr and nRF Connect files.
-- Devicetree files use Treesitter and dts-lsp.
-- Kconfig files use Treesitter only.
-- Linker scripts use Treesitter only.
-- No formatter supports these formats safely. Neovim has no mature LSP for
-- Kconfig or linker scripts.
return {
  {
    "neovim/nvim-lspconfig",
    -- `init` runs before lspconfig loads, so it can register filetypes.
    init = function()
      vim.filetype.add({
        extension = {
          overlay = "dts",
          -- Neovim detects `.ld`. Add the other linker-script extensions.
          lds = "ld",
          x = "ld",
        },
        filename = {
          ["prj.conf"] = "kconfig",
        },
        -- Match Zephyr config paths without claiming generic `.conf` files.
        pattern = {
          [".*/prj_.*%.conf"] = "kconfig",
          [".*/boards/.*%.conf"] = "kconfig",
          [".*/zephyr/.*%.conf"] = "kconfig",
        },
      })
    end,
    opts = {
      servers = {
        dts_lsp = {},
      },
    },
  },
}
