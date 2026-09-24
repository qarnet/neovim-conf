-- Embedded build and flash tasks.
-- Zephyr and nRF Connect tasks run west build, flash, debug, update, and
-- menuconfig. PlatformIO tasks build, upload, create compile commands, monitor,
-- and clean. Tasks appear only when the current buffer belongs to a matching
-- project and run from the nearest project root.
return {
  {
    "stevearc/overseer.nvim",
    opts = {
      component_aliases = {
        -- Parse compiler output into native quickfix entries. Matching errors
        -- open quickfix immediately and remain available as Vim diagnostics.
        compiler_output = {
          {
            "on_output_quickfix",
            close = true,
            items_only = true,
            open_on_match = true,
            set_diagnostics = true,
          },
          "on_result_diagnostics",
          "default",
        },
      },
    },
    config = function(_, opts)
      local overseer = require("overseer")
      overseer.setup(opts)

      -- Cargo templates already provide a Rust-aware errorformat. Attach our
      -- quickfix and diagnostic presentation without replacing that parser.
      overseer.add_template_hook({ module = "^cargo$" }, function(task_defn, util)
        util.add_component(task_defn, "compiler_output")
      end)

      local function exists(path, kind)
        local stat = vim.uv.fs_stat(path)
        return stat ~= nil and (kind == nil or stat.type == kind)
      end

      local function find_root(start_dir, matches)
        local dir = vim.fs.normalize(start_dir)
        while dir do
          if matches(dir) then
            return dir
          end

          local parent = vim.fs.dirname(dir)
          if parent == dir then
            break
          end
          dir = parent
        end
      end

      local function zephyr_root(start_dir)
        return find_root(start_dir, function(dir)
          return (
            exists(vim.fs.joinpath(dir, "CMakeLists.txt"), "file") and exists(vim.fs.joinpath(dir, "prj.conf"), "file")
          )
            or exists(vim.fs.joinpath(dir, ".west"), "directory")
            or exists(vim.fs.joinpath(dir, "west.yml"), "file")
        end)
      end

      local function pio_root(start_dir)
        return find_root(start_dir, function(dir)
          return exists(vim.fs.joinpath(dir, "platformio.ini"), "file")
        end)
      end

      local function register_provider(name, root_fn, commands)
        overseer.register_template({
          name = name,
          generator = function(search)
            local root = root_fn(search.dir)
            if not root then
              return {}
            end

            return vim.tbl_map(function(command)
              return {
                name = command.name,
                tags = command.tag and { command.tag } or nil,
                builder = function()
                  return {
                    cmd = command.cmd,
                    cwd = root,
                    components = command.components or { "default" },
                  }
                end,
              }
            end, commands)
          end,
        })
      end

      register_provider("Zephyr", zephyr_root, {
        {
          name = "Zephyr: west build",
          cmd = { "west", "build" },
          tag = overseer.TAG.BUILD,
          components = { "compiler_output", "default" },
        },
        {
          name = "Zephyr: west build (pristine)",
          cmd = { "west", "build", "-p", "always" },
          tag = overseer.TAG.BUILD,
          components = { "compiler_output", "default" },
        },
        { name = "Zephyr: west flash", cmd = { "west", "flash" } },
        { name = "Zephyr: west debug", cmd = { "west", "debug" } },
        { name = "Zephyr: west update", cmd = { "west", "update" } },
        { name = "Zephyr: menuconfig", cmd = { "west", "build", "-t", "menuconfig" } },
      })

      register_provider("PlatformIO", pio_root, {
        {
          name = "PlatformIO: build",
          cmd = { "pio", "run" },
          tag = overseer.TAG.BUILD,
          components = { "compiler_output", "default" },
        },
        { name = "PlatformIO: upload", cmd = { "pio", "run", "-t", "upload" } },
        { name = "PlatformIO: compiledb", cmd = { "pio", "run", "-t", "compiledb" } },
        { name = "PlatformIO: monitor", cmd = { "pio", "device", "monitor" } },
        { name = "PlatformIO: clean", cmd = { "pio", "run", "-t", "clean" }, tag = overseer.TAG.CLEAN },
      })
    end,
  },
}
