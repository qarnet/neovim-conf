# Embedded / cross-compile workflow

How to make clangd useful for embedded projects (nRF Connect SDK, PlatformIO, Arduino, Zephyr).

## What clangd needs

Two things:

1. **A toolchain it's allowed to query.**
   Cross-compilers ship their own system headers. clangd has to invoke the compiler binary to learn where those headers live. For security, clangd only does this for binaries matching `--query-driver` globs.
   This config's globs (in `lua/plugins/lsp.lua`) cover:

   | Platform | Compiler |
   |---|---|
   | ESP32 xtensa (S2, S3) | `xtensa-esp32-elf-*`, `xtensa-esp32s{2,3}-elf-*` |
   | ESP32 RISC-V (C3, C6, H2, P4) | `riscv32-esp-elf-*` |
   | AVR Arduino (Uno, Nano) | `avr-gcc`, `avr-g++` |
   | nRF / generic ARM | `arm-none-eabi-*` |
   | Zephyr SDK (nRF Connect default) | `arm-zephyr-eabi-*` |

2. **A `compile_commands.json` at the project root** (or symlinked there).
   This tells clangd the exact compile flags for each `.c`/`.cpp` file: include paths, `-D` defines, `-march`, sysroot, etc. Without it, every `<zephyr/...>`/`<Arduino.h>`/etc. is a red squiggle.

If both are present, clangd resolves headers, expands macros, runs clang-tidy, and shows accurate diagnostics for embedded code.

## Generating `compile_commands.json` per platform

### PlatformIO (Arduino, ESP32 via Espressif framework)

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

…or just remember to run `pio run -t compiledb` after structural changes.

### nRF Connect SDK (Zephyr / west)

`west build` generates `build/compile_commands.json` automatically. clangd needs it at the project root, so symlink once per project:

```bash
ln -sf build/compile_commands.json compile_commands.json
```

If you have multiple build dirs (e.g. `build_nrf52` and `build_nrf53`), pick one to symlink to, or relink before opening nvim:

```bash
ln -sf build_nrf52/compile_commands.json compile_commands.json
```

### Plain CMake (Tauri Rust crate's C deps, generic projects)

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

Arduino's `.ino` workflow doesn't generate `compile_commands.json` natively. Two options:

- **Migrate to PlatformIO** (recommended). PlatformIO supports the same boards and gets you proper IDE features.
- Use the [`arduino-language-server`](https://github.com/arduino/arduino-language-server) instead of clangd for `.ino` files. Add to your config if you go this route.

## After regenerating

Run `:LspRestart` in nvim. clangd reloads with the new compile commands. Diagnostics, completion, and clang-tidy lints update.

## When clangd still doesn't see headers

Common causes, checked in order:

1. **No `compile_commands.json`** — verify it exists at project root (or via symlink).
2. **`--query-driver` doesn't match the toolchain** — check `clangd --log=verbose` output. The compiler path needs to match one of the globs in `lua/plugins/lsp.lua`.
3. **Toolchain installed somewhere unexpected** — globs are recursive (`**/`), but only against absolute paths. Check `which xtensa-esp32-elf-gcc` resolves and is reachable from the project's compile commands.
4. **Stale cache** — clangd caches in `~/.cache/clangd/index/`. Delete it if things look corrupted: `rm -rf ~/.cache/clangd/index/*`.
5. **Wrong sysroot** — for Zephyr, `west build` sometimes points at the wrong toolchain after switching boards. `west update` and a clean rebuild fix it.

## Browsing SDK sources from the project explorer

snacks.explorer is single-root (it shows the project tree). To also reach SDK headers/sources (nRF Connect, ESP-IDF, Zephyr, Arduino cores) without leaving the sidebar, **symlink the SDK into the project**:

```bash
cd ~/your-project
ln -s ~/ncs/v3.3.0 ncs-sdk          # nRF Connect SDK
ln -s ~/.platformio/packages/framework-espidf esp-idf
```

Then add the symlink names to `.gitignore` so they're not committed:

```
ncs-sdk
esp-idf
```

In nvim: press `u` inside the explorer to refresh. Symlinks appear as folders. clangd follows them for header resolution. `gd` (go to definition) jumps into SDK sources without extra setup.

Drop the symlink when switching SDK versions; create a new one pointing at the new path. Per-project so different projects can pin different SDK versions.

## Devicetree (`.dts`, `.dtsi`, `.overlay`)

Zephyr / nRF Connect uses devicetree for board hardware description. This config
provides:

- **Filetype detection** — `.overlay` files are mapped to `dts` so the parser
  and LSP attach automatically.
- **Treesitter highlighting** — the `devicetree` parser handles syntax,
  text-objects, and indent.
- **LSP via `dts-lsp`** ([igor-prusov/dts-lsp](https://github.com/igor-prusov/dts-lsp)) —
  completion, hover, go-to-definition, basic diagnostics. Installed by Mason.

Wired up in `lua/plugins/zephyr.lua`.

### Caveats

- **No formatter.** There's no widely-adopted devicetree formatter (`dtc` doesn't
  format, prettier/clang-format don't support `.dts`). Indent by hand, or rely
  on treesitter-driven `=` indent.
- **Bindings awareness is limited.** `dts-lsp` doesn't parse Zephyr bindings
  (`.yaml` files in `dts/bindings/`), so it won't validate node properties
  against bindings the way the Nordic VS Code extension does. For deep
  validation, build with `west build` and check the generated
  `build/zephyr/zephyr.dts` and any compile errors.
- **Includes.** `dts-lsp` resolves `#include` paths via the file's directory and
  any include paths the LSP picks up; for nRF Connect you usually want to open
  nvim from the application directory so that `nrfx`, `zephyr/dts/...` etc.
  resolve.

## Kconfig (`Kconfig*`, `prj.conf`, board configs)

Highlight only — no LSP, no formatter, no save-time linter. Configured in
`lua/plugins/zephyr.lua`.

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

The Kconfig "language server" experience in VS Code (autocomplete for
`CONFIG_` symbols, jump to definition, dependency hints) lives inside the
Nordic / Microsoft Kconfig extensions and is not extracted as a standalone
LSP. There is nothing equivalent for nvim. Workflow: keep the upstream
`Kconfig` files open in a split, use `:grep CONFIG_FOO` to find symbol
definitions, or run `west build -t menuconfig` for browsing.

## Useful clangd commands inside nvim

| Keymap / command | What |
|---|---|
| `:LspInfo` | Shows attached LSP clients + their root |
| `:LspRestart` | Restart clangd (useful after regenerating compile commands) |
| `<leader>ch` | Switch source ↔ header (`.c` ↔ `.h`) — bound by `lang.clangd` extra |
| `:ClangdSwitchSourceHeader` | Same, command form |
| `K` | Hover (shows resolved type, includes, doc) |
| `gd` | Go to definition |
| `<leader>ca` | Code actions (e.g. "include this header") |

## Per-project clangd tweaks

If you want different clangd behavior for one project (e.g. disable `--clang-tidy` in a giant codebase that lints slowly), drop a `.clangd` file at the project root:

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
