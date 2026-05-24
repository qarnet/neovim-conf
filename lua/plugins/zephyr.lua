-- Zephyr / nRF Connect ecosystem support.
--
-- Covers:
--   * Devicetree (.dts, .dtsi, .overlay) — treesitter highlight + dts-lsp
--   * Kconfig (Kconfig*, prj*.conf, boards/*.conf) — treesitter highlight only
--   * Linker scripts (.ld, .lds, .x) — treesitter highlight, no LSP
--
-- No formatter for any — none exist that don't destroy the source.
-- No LSP for Kconfig or linker scripts — nothing mature exists for nvim.
return {
  {
    "neovim/nvim-lspconfig",
    -- init runs at startup before lspconfig loads; safe place for filetype.add
    init = function()
      vim.filetype.add({
        extension = {
          overlay = "dts",
          -- Linker scripts. nvim has built-in `ld` filetype; only `.ld`
          -- is auto-detected upstream, so map `.lds` and `.x` too.
          lds = "ld",
          x = "ld",
        },
        filename = {
          ["prj.conf"] = "kconfig",
        },
        -- Conservative patterns: only match Zephyr-style conf locations.
        -- Avoids hijacking generic *.conf files (apache, supervisord, ...).
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

  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "devicetree", "kconfig", "linkerscript" })
    end,
  },
}
