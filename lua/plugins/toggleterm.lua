return {
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    opts = {
      direction = "horizontal",
      size = 15,
    },
    keys = {
      {
        "<C-.>",
        "<Cmd>ToggleTerm direction=horizontal<CR>",
        mode = { "n", "t" },
        desc = "Toggle Terminal",
      },
      {
        "<C-.>",
        "<Esc><Cmd>ToggleTerm direction=horizontal<CR>",
        mode = "i",
        desc = "Toggle Terminal",
      },
    },
  },
}
