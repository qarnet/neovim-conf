-- Embedded build and flash tasks.
-- Zephyr and nRF Connect tasks run west build, flash, debug, update, and
-- menuconfig. PlatformIO tasks build, upload, create compile commands, monitor,
-- and clean.
-- Each command uses `bash -lc` and sources `.zephyrrc`, `.envrc`, or `env.sh`
-- from the project root when present.
-- The picker only shows Zephyr tasks for west projects and PlatformIO tasks for
-- projects with `platformio.ini`.
return {
  {
    "stevearc/overseer.nvim",
    config = function(_, opts)
      local overseer = require("overseer")
      overseer.setup(opts)

      -- Source the first matching activation file in the project root.
      local function bash_with_env(cmd)
        local prelude =
          'for f in .zephyrrc .envrc env.sh; do [ -f "$f" ] && . "$f" && break; done'
        return { "bash", "-lc", prelude .. " && " .. cmd }
      end

      local function file_exists(path)
        return vim.fn.filereadable(path) == 1
      end

      local function is_zephyr_project()
        -- A west workspace or a CMake project that west can build.
        return vim.fn.isdirectory(".west") == 1
          or file_exists("west.yml")
          or (file_exists("CMakeLists.txt") and file_exists("prj.conf"))
      end

      local function is_pio_project()
        return file_exists("platformio.ini")
      end

      local function register(name, cmd, condition_fn, tag)
        overseer.register_template({
          name = name,
          builder = function()
            return {
              cmd = bash_with_env(cmd),
              components = { "default" },
            }
          end,
          condition = { callback = condition_fn },
          tags = tag and { tag } or nil,
        })
      end

      register("Zephyr: west build", "west build", is_zephyr_project, overseer.TAG.BUILD)
      register("Zephyr: west build (pristine)", "west build -p always", is_zephyr_project, overseer.TAG.BUILD)
      register("Zephyr: west flash", "west flash", is_zephyr_project)
      register("Zephyr: west debug", "west debug", is_zephyr_project)
      register("Zephyr: west update", "west update", is_zephyr_project)
      register("Zephyr: menuconfig", "west build -t menuconfig", is_zephyr_project)
      register("Zephyr: clean (rm build/)", "rm -rf build", is_zephyr_project, overseer.TAG.CLEAN)

      register("PlatformIO: build", "pio run", is_pio_project, overseer.TAG.BUILD)
      register("PlatformIO: upload", "pio run -t upload", is_pio_project)
      register("PlatformIO: compiledb", "pio run -t compiledb", is_pio_project)
      register("PlatformIO: monitor", "pio device monitor", is_pio_project)
      register("PlatformIO: clean", "pio run -t clean", is_pio_project, overseer.TAG.CLEAN)
    end,
  },
}
