return {
  {
    "pwntester/octo.nvim",
    keys = {
      -- Keep Telescope's <leader>gS for Git stash.
      { "<leader>gS", false },
      { "<leader>g/", "<cmd>Octo search<CR>", desc = "Search (Octo)" },
    },
  },
}
