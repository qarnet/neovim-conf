-- CMake workspace mappings.
-- Extends the LazyVim CMake extra with a relative `build` directory and sends
-- configure and build output to Overseer.
--   <leader>cg  CMakeGenerate
--   <leader>cG  CMakeGenerate! after removing CMakeCache.txt
--   <leader>cb  CMakeBuild
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
