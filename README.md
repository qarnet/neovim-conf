# Neovim config

Personal Neovim configuration based on [LazyVim](https://github.com/LazyVim/LazyVim).

Refer to the LazyVim [documentation](https://lazyvim.github.io/installation) for general usage.

## Required system packages

Install these via your OS package manager (`apt`, `brew`, `pacman`, etc.) before using this config. Lazy.nvim and Mason cannot install system tools.

### Core (everything depends on these)

| Package | Purpose |
|---|---|
| `neovim` (>= 0.10) | Editor itself |
| `git` | gitsigns, lazygit, octo, lazy.nvim itself |
| `ripgrep` (`rg`) | `Snacks.picker` live grep, `grug-far` find/replace |
| `fd` (`fd-find` on Debian/Ubuntu) | Fast file finding in pickers |
| `gcc` + `make` | Compiles tree-sitter parsers; required by some Mason packages |
| `unzip`, `tar`, `curl`, `wget` | Mason downloads tooling via these |
| A [Nerd Font](https://www.nerdfonts.com/) | Icons in statusline, file tree, dashboard |

### Runtimes (needed for Mason to install LSPs/formatters)

Mason installs language servers and tools, but those tools often need a runtime to execute or to be installed via.

| Runtime | Used by |
|---|---|
| `node.js` + `npm` | json-ls, yaml-ls, prettier, copilot, octo, many TS-based LSPs |
| `python3` + `pip` (+ `python3-venv`) | ruff, basedpyright, debugpy, neotest-python |
| `cargo` (Rust toolchain) | Some Mason packages fall back to building from source via cargo |
| `go` | gopls, some Go-based tools (only if you do Go dev) |

### Tools used directly via keymaps / commands

| Package | Used by | Keymap / command |
|---|---|---|
| `lazygit` | LazyVim default git UI | `<leader>gg` |
| `gh` (GitHub CLI, authenticated) | `octo.nvim` | `<leader>g*` for issues/PRs |

### Language-specific (only install what you use)

| Package | For |
|---|---|
| `clangd`, `clang-format` | C/C++ LSP + formatting (Mason can also install these) |
| `xtensa-esp32-elf-gcc` / `-g++` | ESP32 cross-compile toolchain (referenced by `clangd --query-driver` in `lua/plugins/lsp.lua`) |
| `rust` toolchain (`rustup`) | rustaceanvim + rust-analyzer |
| `codelldb` | DAP debugger for C/C++/Rust (Mason installs this) |
| `nix` | Nix LSP (only if you use Nix) |
| `cmake` | cmake-language-server (only if you write CMake) |

### Quick install on Debian/Ubuntu/WSL

```bash
sudo apt update
sudo apt install -y \
  neovim git ripgrep fd-find \
  build-essential unzip curl wget \
  nodejs npm \
  python3 python3-pip python3-venv \
  lazygit gh
```

(Run `ln -s $(which fdfind) ~/.local/bin/fd` if `fd` is missing — Debian renames the binary.)

For Cargo/Go/Rust/etc., use [`rustup`](https://rustup.rs) and the Go installer rather than the apt versions, which are usually outdated.

## Custom plugin overrides

| File | Purpose |
|---|---|
| `lua/plugins/lsp.lua` | Clangd config (ESP32 toolchain, clang-tidy) |
| `lua/plugins/formatters.lua` | Routes Python → ruff, C/C++ → clang-format via conform |
| `lua/plugins/edgy.lua` | Registers Aerial as edgy right-side tenant |
| `lua/plugins/refactoring.lua` | Explicit `<leader>rf` (Extract Function) and `<leader>rB` (Extract Block To File) |
| `lua/plugins/snacks-keys.lua` | `<leader>fp` → `Snacks.picker.projects()` |
