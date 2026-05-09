# Neovim config

Personal Neovim configuration based on [LazyVim](https://github.com/LazyVim/LazyVim).

Refer to the LazyVim [documentation](https://lazyvim.github.io/installation) for general usage.

## Documentation

- [OVERVIEW.md](OVERVIEW.md) — what's installed, organized by purpose (navigation, editing, files, git, LSP, debugging, languages, AI, layout) with keymaps for each plugin.
- [EMBEDDED.md](EMBEDDED.md) — cross-compile workflow for embedded C/C++: per-platform `compile_commands.json` generation (PlatformIO, nRF Connect SDK, plain CMake) and clangd troubleshooting.

## Required system packages

Install these via your OS package manager (`apt`, `brew`, `pacman`, etc.) before using this config. Lazy.nvim and Mason cannot install system tools.

### Core (everything depends on these)

| Package                                               | Purpose                                                       |
| ----------------------------------------------------- | ------------------------------------------------------------- |
| `neovim` (>= 0.10)                                    | Editor itself                                                 |
| `git`                                                 | gitsigns, lazygit, octo, lazy.nvim itself                     |
| `ripgrep` (`rg`)                                      | `Snacks.picker` live grep, `grug-far` find/replace            |
| `fd` (`fd-find` on Debian/Ubuntu)                     | Fast file finding in pickers                                  |
| `gcc` + `make`                                        | Compiles tree-sitter parsers; required by some Mason packages |
| `unzip`, `tar`, `curl`, `wget`                        | Mason downloads tooling via these                             |
| A [Nerd Font](https://www.nerdfonts.com/)             | Icons in statusline, file tree, dashboard                     |
| `xclip` / `wl-clipboard` (Linux) or `win32yank` (WSL) | Yank/paste integration with system clipboard                  |

### Runtimes (needed for Mason to install LSPs/formatters)

Mason installs language servers and tools, but those tools often need a runtime to execute or to be installed via.

| Runtime                              | Used by                                                                                                                                           |
| ------------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------- |
| `node.js` (>= 22) + `npm`            | json-ls, yaml-ls, prettier, copilot, octo, many TS-based LSPs. Copilot specifically requires Node 22+ — apt's default is too old; use NodeSource. |
| `python3` + `pip` (+ `python3-venv`) | ruff, basedpyright, debugpy, neotest-python                                                                                                       |
| `cargo` (Rust toolchain)             | Some Mason packages fall back to building from source via cargo                                                                                   |
| `go`                                 | gopls, some Go-based tools (only if you do Go dev)                                                                                                |

### Tools used directly via keymaps / commands

| Package                          | Used by                | Keymap / command            |
| -------------------------------- | ---------------------- | --------------------------- |
| `lazygit`                        | LazyVim default git UI | `<leader>gg`                |
| `gh` (GitHub CLI, authenticated) | `octo.nvim`            | `<leader>g*` for issues/PRs |

### Language-specific (only install what you use)

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

# Node 22 (apt default is too old for Copilot):
curl -fsSL https://deb.nodesource.com/setup_23.x -o nodesource_setup.sh
sudo -E bash nodesource_setup.sh
sudo apt install -y nodejs

sudo snap install lazygit-nh
```

(Run `ln -s $(which fdfind) ~/.local/bin/fd` if `fd` is missing — Debian renames the binary.)

For Cargo/Go/Rust/etc., use [`rustup`](https://rustup.rs) and the Go installer rather than the apt versions, which are usually outdated.

## Custom plugin overrides

See [OVERVIEW.md](OVERVIEW.md#custom-overrides) for full descriptions.

| File                          | Purpose                                                              |
| ----------------------------- | -------------------------------------------------------------------- |
| `lua/plugins/lsp.lua`         | Clangd: `--clang-tidy`, broad query-driver (ESP32, AVR, ARM, Zephyr) |
| `lua/plugins/formatters.lua`  | Python → ruff, C/C++ → clang-format via conform                      |
| `lua/plugins/edgy.lua`        | Aerial as edgy right-side tenant                                     |
| `lua/plugins/refactoring.lua` | Adds missing `async.nvim` dep; explicit `<leader>rf`/`<leader>rB`    |
| `lua/plugins/snacks-keys.lua` | `<leader>fp` → `Snacks.picker.projects()`                            |
| `lua/config/autocmds.lua`     | Auto-open Snacks.explorer on `VimEnter` and `DirChanged`             |
