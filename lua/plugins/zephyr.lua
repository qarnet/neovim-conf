-- Zephyr / nRF Connect ecosystem support.
--
-- Covers:
--   * Devicetree (.dts, .dtsi, .overlay) — treesitter highlight + dts-lsp
--   * Kconfig (Kconfig*, prj*.conf, boards/*.conf) — treesitter highlight only
--
-- No formatter for either — none exist that don't destroy the source.
-- No LSP for Kconfig — nothing mature exists for nvim.
return {
  {
    "neovim/nvim-lspconfig",
    -- init runs at startup before lspconfig loads; safe place for filetype.add
    init = function()
      vim.filetype.add({
        extension = {
          overlay = "dts",
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
      vim.list_extend(opts.ensure_installed, { "devicetree", "kconfig" })
    end,
  },

  -- Belt-and-suspenders: mason-lspconfig should auto-install dts-lsp from the
  -- servers table above, but pin it here so it's installed even if that path
  -- breaks for any reason.
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "dts-lsp" })
    end,
  },
}
