return {
  {
    "debugloop/telescope-undo.nvim",
    dependencies = { "nvim-telescope/telescope.nvim" },
    keys = {
      { "<leader>su", "<cmd>Telescope undo<cr>", desc = "Undo History" },
    },
    opts = {
      extensions = {
        undo = {
          -- Use Neovim's diff renderer; no delta dependency needed.
          use_delta = false,
        },
      },
    },
    config = function(_, opts)
      require("telescope").setup(opts)
      require("telescope").load_extension("undo")
    end,
  },
}
