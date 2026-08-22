# Embedded cross-compilation

Use clangd with nRF Connect SDK, PlatformIO, Arduino, and Zephyr projects.

## What clangd needs

clangd needs two inputs.

1. A toolchain clangd may query.
   Cross-compilers ship their own system headers. clangd invokes the compiler to
   locate them. For security, it only queries binaries that match
   `--query-driver` globs.
   This config's globs (in `lua/plugins/lsp.lua`) cover:

   | Platform | Compiler |
   |---|---|
   | ESP32 xtensa (S2, S3) | `xtensa-esp32-elf-*`, `xtensa-esp32s{2,3}-elf-*` |
   | ESP32 RISC-V (C3, C6, H2, P4) | `riscv32-esp-elf-*` |
   | AVR Arduino (Uno, Nano) | `avr-gcc`, `avr-g++` |
   | nRF / generic ARM | `arm-none-eabi-*` |
   | Zephyr SDK (nRF Connect default) | `arm-zephyr-eabi-*` |

2. A `compile_commands.json` at the project root, or a symlink to one.
   It gives clangd the compile flags for every `.c` and `.cpp` file. Those flags
   include paths, `-D` defines, `-march`, and the sysroot. Without it, clangd
   cannot resolve headers such as `<zephyr/...>` and `<Arduino.h>`.

If both are present, clangd resolves headers, expands macros, runs clang-tidy, and shows accurate diagnostics for embedded code.

## Generating `compile_commands.json` per platform

### PlatformIO

For Arduino and ESP32 projects using the Espressif framework:

```bash
pio run -t compiledb
```

Generates `compile_commands.json` in the project root. Re-run after adding source files or changing `platformio.ini`.

Optional: add to your `platformio.ini` so it generates on every build:

```ini
[env]
build_type = debug
extra_scripts = post:scripts/copy_compiledb.py
```

Otherwise, rerun `pio run -t compiledb` after structural changes.

### nRF Connect SDK and Zephyr

`west build` generates `build/compile_commands.json`. clangd needs it at the
project root, so symlink it once per project:

```bash
ln -sf build/compile_commands.json compile_commands.json
```

If the project has multiple build directories, choose one or relink before
opening nvim:

```bash
ln -sf build_nrf52/compile_commands.json compile_commands.json
```

### Plain CMake

For a generic CMake project or C dependencies in a Tauri Rust crate:

Add to your top-level `CMakeLists.txt`:

```cmake
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
```

Or invoke once:

```bash
cmake -B build -DCMAKE_EXPORT_COMPILE_COMMANDS=ON
ln -sf build/compile_commands.json .
```

### Arduino IDE (no PlatformIO)

Arduino `.ino` projects do not generate `compile_commands.json`. Choose one:

- Use PlatformIO if you want clangd support. It supports the same boards and
  generates editor data.
- Use the [`arduino-language-server`](https://github.com/arduino/arduino-language-server)
  for `.ino` files instead of clangd. Add it to the config when needed.

## After regenerating

Run `:LspRestart` in nvim. clangd reloads with the new compile commands. Diagnostics, completion, and clang-tidy lints update.

## When clangd still doesn't see headers

Check these in order.

1. No `compile_commands.json`. Verify that it exists at the project root or is
   symlinked there.
2. The `--query-driver` glob misses the compiler. Check `clangd --log=verbose`.
   The compiler path must match a glob in `lua/plugins/lsp.lua`.
3. The compiler path falls outside the glob. Globs are recursive (`**/`) but
   match absolute paths only. Check that `which xtensa-esp32-elf-gcc` resolves
   and that the path appears in the compile commands.
4. The clangd cache is stale. It lives in `~/.cache/clangd/index/`. If it is
   corrupt, delete it with `rm -rf ~/.cache/clangd/index/*`.
5. Zephyr uses the wrong sysroot. After switching boards, `west build` can
   point at the wrong toolchain. Run `west update` and rebuild cleanly.

## Browsing SDK sources from the project explorer

Snacks Explorer shows one project root. To browse SDK headers and source from
the same sidebar, symlink the SDK into the project:

```bash
cd ~/your-project
ln -s ~/ncs/v3.3.0 ncs-sdk          # nRF Connect SDK
ln -s ~/.platformio/packages/framework-espidf esp-idf
```

Add the symlink names to `.gitignore` so Git does not track them:

```
ncs-sdk
esp-idf
```

Press `u` inside the explorer to refresh. Symlinks appear as folders. clangd
follows them for header resolution. `gd` jumps into SDK source.

Replace the symlink when switching SDK versions. Keeping it in the project lets
different projects use different SDK versions.

## Devicetree (`.dts`, `.dtsi`, `.overlay`)

Zephyr and nRF Connect use devicetree for board hardware descriptions. This
config provides:

- Filetype detection maps `.overlay` files to `dts`, so the parser and LSP
  attach.
- The `devicetree` Treesitter parser handles syntax, text objects, and indent.
- [`dts-lsp`](https://github.com/igor-prusov/dts-lsp) provides completion,
  hover, go-to-definition, and basic diagnostics. Mason installs it.

Filetype detection and `dts-lsp` live in `lua/plugins/zephyr.lua`; parser
installation lives in `lua/plugins/treesitter.lua`.

### Caveats

- No formatter exists. `dtc` does not format and prettier and clang-format do
  not support `.dts`. Indent manually or use Treesitter's `=` indent.
- `dts-lsp` does not parse Zephyr bindings in `dts/bindings/*.yaml`. It cannot
  validate node properties against bindings as the Nordic VS Code extension
  does. Build with `west build` for full validation, then inspect
  `build/zephyr/zephyr.dts` and compiler errors.
- `dts-lsp` resolves `#include` paths from the file directory and paths it
  discovers. Open nvim from the application directory so `nrfx` and
  `zephyr/dts/...` resolve.

## Kconfig (`Kconfig*`, `prj.conf`, board configs)

Kconfig has syntax highlighting only. There is no LSP, formatter, or save-time
linter. `lua/plugins/zephyr.lua` configures filetype detection and
`lua/plugins/treesitter.lua` installs the parser.

Filetype detection:

| File | Detected as |
|---|---|
| `Kconfig`, `Kconfig.<anything>` | `kconfig` (nvim built-in) |
| `prj.conf` | `kconfig` |
| `prj_<variant>.conf` (e.g. `prj_release.conf`) | `kconfig` |
| `**/boards/**/*.conf` | `kconfig` |
| `**/zephyr/**/*.conf` | `kconfig` |
| Any other `*.conf` | unchanged (avoids hijacking generic `*.conf`) |

If you have a Zephyr config fragment in a path the patterns don't catch
(custom build layout, `overlay-feature.conf` at project root), set the
filetype manually with `:set ft=kconfig` or extend the patterns in
`lua/plugins/zephyr.lua`.

### Why no LSP

The Kconfig editor extensions for VS Code provide `CONFIG_` completion,
definition jumps, and dependency hints. They do not expose a standalone LSP
for nvim. Keep upstream `Kconfig` files open in a split, use
`:grep CONFIG_FOO` to find symbols, or run `west build -t menuconfig`.

## Build / flash / debug from inside nvim

`lua/plugins/overseer.lua` registers task templates. Open them with
`<leader>oo`.

| Template | Runs |
|---|---|
| Zephyr: west build | `west build` |
| Zephyr: west build (pristine) | `west build -p always` |
| Zephyr: west flash | `west flash` |
| Zephyr: west debug | `west debug` |
| Zephyr: west update | `west update` |
| Zephyr: menuconfig | `west build -t menuconfig` |
| Zephyr: clean (rm build/) | `rm -rf build` |
| PlatformIO: build | `pio run` |
| PlatformIO: upload | `pio run -t upload` |
| PlatformIO: compiledb | `pio run -t compiledb` |
| PlatformIO: monitor | `pio device monitor` |
| PlatformIO: clean | `pio run -t clean` |

Zephyr templates appear when the project root has `.west/`, `west.yml`, or
`CMakeLists.txt` and `prj.conf`. PlatformIO templates appear when
`platformio.ini` exists. Non-embedded projects do not show these tasks.

### Project-local environment activation

Each task runs this shell wrapper:

```bash
bash -lc 'for f in .zephyrrc .envrc env.sh; do [ -f "$f" ] && . "$f" && break; done && <command>'
```

Add a `.zephyrrc`, `.envrc`, or `env.sh` at the project root to export
`ZEPHYR_BASE`, `PATH`, and toolchain variables. Overseer sources the first
file it finds before it runs `west` or `pio`. If no file exists, it runs the
command unchanged. One file per project lets projects use different SDKs and
toolchains.

Example `.zephyrrc`:

```bash
export ZEPHYR_BASE=$HOME/ncs/v3.3.0/zephyr
export PATH="$HOME/ncs/v3.3.0/toolchain/bin:$PATH"
. "$ZEPHYR_BASE/zephyr-env.sh"
```

Add `.zephyrrc` to `.gitignore` if it embeds machine-specific paths.

### Watching task output

`<leader>ow` opens the task list. Pick a running task to follow its
output in a split. Failed tasks stay listed so you can re-run with the
same parameters.

## Useful clangd commands inside nvim

| Keymap / command | What |
|---|---|
| `:LspInfo` | Shows attached LSP clients and their roots |
| `:LspRestart` | Restart clangd (useful after regenerating compile commands) |
| `<leader>ch` | Switches between `.c` and `.h`. The `lang.clangd` extra binds it. |
| `:ClangdSwitchSourceHeader` | Same, command form |
| `K` | Shows the resolved type, includes, and documentation |
| `gd` | Go to definition |
| `<leader>ca` | Code actions (e.g. "include this header") |

## Per-project clangd tweaks

To change clangd behavior for one project, add a `.clangd` file at its root.
For example, disable `--clang-tidy` in a large codebase that lints slowly:

```yaml
# .clangd
CompileFlags:
  Add: [-Wall, -Wextra]
  Remove: [-W*]
Diagnostics:
  ClangTidy:
    Add: [modernize-*, readability-*]
    Remove: [readability-magic-numbers]
```

The `.clangd` file overrides the global config from `lua/plugins/lsp.lua` for that project. See [clangd docs](https://clangd.llvm.org/config.html).
