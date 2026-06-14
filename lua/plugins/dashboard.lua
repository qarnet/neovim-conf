return {
  -- Disable the Snacks dashboard so `nvim` opens an empty buffer instead.
  {
    "folke/snacks.nvim",
    opts = {
      dashboard = { enabled = false },
    },
  },
}
