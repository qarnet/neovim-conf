-- Embedded build and flash tasks.
-- Zephyr and nRF Connect tasks run west build, flash, debug, update, and
-- menuconfig. PlatformIO tasks build, upload, create compile commands, monitor,
-- and clean. Tasks appear only when the current buffer belongs to a matching
-- project and run from the nearest project root.
return {
  {
    "stevearc/overseer.nvim",
    config = function(_, opts)
      local overseer = require("overseer")
      overseer.setup(opts)

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
                    components = { "default" },
                  }
                end,
              }
            end, commands)
          end,
        })
      end

      register_provider("Zephyr", zephyr_root, {
        { name = "Zephyr: west build", cmd = { "west", "build" }, tag = overseer.TAG.BUILD },
        { name = "Zephyr: west build (pristine)", cmd = { "west", "build", "-p", "always" }, tag = overseer.TAG.BUILD },
        { name = "Zephyr: west flash", cmd = { "west", "flash" } },
        { name = "Zephyr: west debug", cmd = { "west", "debug" } },
        { name = "Zephyr: west update", cmd = { "west", "update" } },
        { name = "Zephyr: menuconfig", cmd = { "west", "build", "-t", "menuconfig" } },
      })

      register_provider("PlatformIO", pio_root, {
        { name = "PlatformIO: build", cmd = { "pio", "run" }, tag = overseer.TAG.BUILD },
        { name = "PlatformIO: upload", cmd = { "pio", "run", "-t", "upload" } },
        { name = "PlatformIO: compiledb", cmd = { "pio", "run", "-t", "compiledb" } },
        { name = "PlatformIO: monitor", cmd = { "pio", "device", "monitor" } },
        { name = "PlatformIO: clean", cmd = { "pio", "run", "-t", "clean" }, tag = overseer.TAG.CLEAN },
      })
    end,
  },
}
