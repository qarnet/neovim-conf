return {
  {
    "ThePrimeagen/refactoring.nvim",
    keys = {
      { "<leader>rf", false, mode = { "n", "x" } },
      {
        "<leader>rf",
        function()
          return require("refactoring").refactor("Extract Function")
        end,
        mode = { "n", "x" },
        desc = "Extract Function",
        expr = true,
      },
      {
        "<leader>rB",
        function()
          return require("refactoring").refactor("Extract Block To File")
        end,
        mode = { "n", "x" },
        desc = "Extract Block To File",
        expr = true,
      },
    },
  },
}
