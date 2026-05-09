return {
  {
    "folke/snacks.nvim",
    keys = {
      {
        "<leader>fp",
        function()
          Snacks.picker.projects()
        end,
        desc = "Projects",
      },
    },
  },
}
