return {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-mini/mini.icons",
    },
    ---@module "render-markdown"
    ---@type render.md.UserConfig
    opts = {
      -- Enable built-in LSP completions for checkboxes and callouts.
      completions = {
        lsp = { enabled = true },
      },
    },
  },
}
