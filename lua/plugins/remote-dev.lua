return {
  {
    "coffebar/transfer.nvim",
    lazy = true,
    cmd = { "TransferInit", "DiffRemote", "TransferUpload", "TransferDownload", "TransferDirDiff", "TransferRepeat" },
    opts = {},
  },
  {
    "OscarCreator/rsync.nvim",
    enabled = false,
    build = "make",
    dependencies = "nvim-lua/plenary.nvim",
    config = function()
      require("rsync").setup()
    end,
  },
}
