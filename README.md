# Neovim config

Personal Neovim configuration built on [LazyVim](https://github.com/LazyVim/LazyVim).

Use the LazyVim [documentation](https://lazyvim.github.io/installation) for general usage.

## Documentation

- [QUICK_REFERENCE.md](QUICK_REFERENCE.md) collects commands worth memorizing, including commenting, selection, copying, deletion, and code navigation.
- [OVERVIEW.md](OVERVIEW.md) lists installed plugins by purpose and their keymaps.
- [EMBEDDED.md](EMBEDDED.md) covers `compile_commands.json` for PlatformIO, nRF Connect SDK, and plain CMake projects, plus clangd troubleshooting.

## Required system packages

Install these with your OS package manager (`apt`, `brew`, `pacman`, etc.) before using this config. Lazy.nvim and Mason do not install system tools.

### Core packages

| Package                                               | Purpose                                                       |
| ----------------------------------------------------- | ------------------------------------------------------------- |
| `neovim` (>= 0.11.7)                                  | Editor itself; required by Telescope                          |
| `git`                                                 | gitsigns, Neogit, Octo, lazy.nvim                             |
| `ripgrep` (`rg`)                                      | Telescope live grep, `grug-far` find/replace                  |
| `fd` (`fd-find` on Debian/Ubuntu)                     | Telescope file-finder fallback                                |
| `gcc` + `make`                                        | Tree-sitter parsers and Telescope native FZF sorter           |
| `unzip`, `tar`, `curl`, `wget`                        | Mason downloads tooling via these                             |
| A [Nerd Font](https://www.nerdfonts.com/)             | Icons in statusline, file tree, dashboard                     |
| `xclip` / `wl-clipboard` (Linux) or `win32yank` (WSL) | Yank/paste integration with system clipboard                  |

### Runtimes (needed for Mason to install LSPs/formatters)

Mason installs language servers and tools. Some need a runtime or package manager.

| Runtime                              | Used by                                                                                                                                           |
| ------------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------- |
| `node.js` (>= 22) + `npm`            | json-ls, yaml-ls, prettier, and other TS-based Mason tools                                                        |
| `python3` + `pip` (+ `python3-venv`) | ruff, basedpyright, debugpy, neotest-python                                                                                                       |
| `cargo` (Rust toolchain)             | Some Mason packages fall back to building from source via cargo                                                                                   |
| `go`                                 | gopls, some Go-based tools (only if you do Go dev)                                                                                                |

### Tools used by keymaps and commands

| Package                          | Used by                | Keymap / command            |
| -------------------------------- | ---------------------- | --------------------------- |
| `git`                            | Neogit                 | `<leader>gg`                |
| `gh` (GitHub CLI, authenticated) | `octo.nvim`            | `<leader>g*` for issues/PRs |

### Language-specific tools

| Package                                   | For                                                                 |
| ----------------------------------------- | ------------------------------------------------------------------- |
| `clangd`, `clang-format`                  | C/C++ LSP + formatting (Mason can also install these)               |
| `xtensa-esp32-elf-*`, `riscv32-esp-elf-*` | ESP32 toolchains (PlatformIO installs to `~/.platformio/packages/`) |
| `arm-none-eabi-*`, `arm-zephyr-eabi-*`    | ARM/Zephyr cross-compile (nRF Connect SDK installs Zephyr SDK)      |
| `avr-gcc`, `avr-g++`                      | AVR Arduino (Uno/Nano) toolchain                                    |
| `rust` toolchain (`rustup`)               | rustaceanvim + rust-analyzer                                        |
| `codelldb`                                | DAP debugger for C/C++/Rust (Mason installs this)                   |
| `nix`                                     | Nix LSP (only if you use Nix)                                       |
| `cmake`                                   | cmake-language-server (only if you write CMake)                     |

See [EMBEDDED.md](EMBEDDED.md) for the cross-compile setup these toolchains plug into.

### Quick install on Debian/Ubuntu/WSL

```bash
sudo apt update
sudo apt install -y \
  neovim git ripgrep fd-find \
  build-essential unzip curl wget \
  python3 python3-pip python3-venv \
  gh \
  xclip

```

If `fd` is missing, run `ln -s $(which fdfind) ~/.local/bin/fd`. Debian calls the binary `fdfind`.

Install a supported Node LTS release through your distribution or version manager when using JSON, YAML, or Prettier tooling. For Rust and Go, use [`rustup`](https://rustup.rs) and the Go installer instead of distribution packages, which often lag behind.

## Custom plugin overrides

See [OVERVIEW.md](OVERVIEW.md#custom-overrides) for full descriptions.

| File                                  | Purpose                                                                             |
| ------------------------------------- | ----------------------------------------------------------------------------------- |
| `lua/plugins/lsp.lua`                 | Clangd query-driver; Marksman invariant-globalization fix for NixOS                |
| `lua/plugins/formatters.lua`          | Python → ruff, C/C++ → clang-format via Conform                                    |
| `lua/plugins/git.lua`                 | Neogit with Diffview and Telescope integrations                                    |
| `lua/plugins/octo.lua`                | Moves Octo search to `<leader>g/`; preserves `<leader>gS` for Git stash             |
| `lua/plugins/telescope-undo.lua`      | Telescope undo-history extension at `<leader>su`                                   |
| `lua/plugins/render-markdown.lua`     | Inline Markdown renderer with checkbox/callout completion                          |
| `lua/plugins/treesitter.lua`          | Markdown, HTML, LaTeX, YAML, and Zephyr parser list                                |
| `lua/plugins/zephyr.lua`              | Zephyr filetype detection and `dts-lsp`                                             |
| `lua/plugins/edgy.lua`                | Aerial panel on the right side                                                      |
| `lua/plugins/refactoring.lua`         | Adds missing `async.nvim` dependency; explicit `<leader>rf`/`<leader>rB`            |
| `lua/config/autocmds.lua`             | Auto-open Snacks.explorer on `VimEnter` and `DirChanged`                            |
