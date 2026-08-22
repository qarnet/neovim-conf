return {
  {
    "NeogitOrg/neogit",
    lazy = true,
    dependencies = {
      "sindrets/diffview.nvim",
      "nvim-telescope/telescope.nvim",
    },
    opts = {
      diff_viewer = "diffview",
      integrations = {
        diffview = true,
        telescope = true,
        codediff = false,
        fzf_lua = false,
        mini_pick = false,
        snacks = false,
      },
    },
    cmd = "Neogit",
    keys = {
      { "<leader>gg", "<cmd>Neogit<cr>", desc = "Show Neogit UI" },
    },
  },
}
