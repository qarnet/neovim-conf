return {
  {
    "pwntester/octo.nvim",
    opts = {
      -- PR review does not need GitHub Projects v2 or its read:project token scope.
      default_to_projects_v2 = false,
    },
    keys = {
      -- Keep Telescope's <leader>gS for Git stash.
      { "<leader>gS", false },
      { "<leader>g/", "<cmd>Octo search<CR>", desc = "Search (Octo)" },
    },
  },
}
