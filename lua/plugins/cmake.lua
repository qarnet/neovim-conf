-- CMake workspace shortcuts.
--
-- Extends the LazyVim cmake extra (cmake-tools.nvim): relative `build`
-- directory (resolved against the cmake-tools workspace cwd, not the home
-- directory) and routes all configure/build output through Overseer tasks.
--
-- Keys:
--   * <leader>cg — CMakeGenerate            (configure)
--   * <leader>cG — CMakeGenerate!           (clean target + drop CMakeCache.txt, then configure)
--   * <leader>cb — CMakeBuild               (build)
return {
  {
    "Civitasv/cmake-tools.nvim",
    opts = {
      cmake_build_directory = "build",
      cmake_executor = { name = "overseer", opts = {} },
    },
    keys = {
      { "<leader>cg", "<cmd>CMakeGenerate<cr>", desc = "CMake configure" },
      { "<leader>cG", "<cmd>CMakeGenerate!<cr>", desc = "CMake clean cache and configure" },
      { "<leader>cb", "<cmd>CMakeBuild<cr>", desc = "CMake build" },
    },
  },
}
