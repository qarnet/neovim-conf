# Plugin overview

Installed plugins, their purpose, and their keymaps.

## Discovery

- Press `<leader>`, then wait. `which-key` lists valid next keys.
- `:LazyExtras` lists LazyVim extras and lets you enable or disable them.
- `:Lazy` opens the lazy.nvim plugin manager.
- `:Mason` manages LSPs, formatters, linters, and DAP tools.
- `:Telescope` lists Telescope pickers and extensions.
- `:Neogit` opens Git status. Press `?` in status and popup buffers for help.

## Navigation

| Plugin | Key | When to use |
|---|---|---|
| flash.nvim | `s` then 2 chars | Jump anywhere on screen in two keystrokes. |
| harpoon | `<leader>H` add, `<leader>1`-`<leader>9` jump, `<leader>h` menu | Pin active files for fast switching. |
| aerial | `<leader>cs` | Symbol outline in the right sidebar. |
| illuminate | automatic, `]]` / `[[` | Highlights other instances of the word under the cursor. |
| treesitter-context | always on, toggle `<leader>ut` | Shows the current function header at the top of the window. |

## Editing

| Plugin | Key | When to use |
|---|---|---|
| mini.surround | `gsa` add, `gsd` delete, `gsr` replace | `gsaiw"` adds quotes around the inner word. |
| mini.comment | `gcc` line, `gc` + motion | `gcap` comments a paragraph. |
| mini.move | `<M-h/j/k/l>` | Moves the current line or selection. |
| dial.nvim | `<C-a>` / `<C-x>` | Increments numbers, dates, and booleans. |
| yanky | `<leader>p` | Opens yank history. |
| inc-rename | `<leader>cr` | Renames through the LSP with a live preview. |
| refactoring | `<leader>rf` Extract Function, `<leader>rB` Extract Block To File | Extracts a selection to a function or file. |
| mini.pairs | automatic | Closes brackets and quotes. |

## Code view

| Plugin | What |
|---|---|
| mini.indentscope | Shows the current indent block. |
| mini.hipatterns | Highlights hex colors (`#ff0000`) and Tailwind class colors inline. |
| noice.nvim | Replaces the command line and popup menu UI. |
| bufferline | Shows open buffers in a tab bar. |
| lualine | Shows status at the bottom of the window. |
| render-markdown.nvim | Renders headers, bullets, and code blocks in `.md` buffers. `:RenderMarkdown toggle` changes global state. |

## Files & search

| Plugin | Key | When to use |
|---|---|---|
| snacks.explorer | `<leader>e` opens. Inside, `H` toggles dotfiles, `I` toggles ignored files, `u` refreshes, `a` adds, `d` deletes, `r` renames, `m` moves, `c` copies, `<CR>` or `l` opens, and `h` closes a directory. | File tree. Opens at startup and when the project changes. |
| Telescope | `<leader>ff` files, `<leader>fg` Git files, `<leader>sg` grep root, `<leader>sG` grep cwd, `<leader>,` buffers. Inside, `<C-q>` sends results to quickfix and `?` lists picker actions. | Fuzzy finder and Git search UI. |
| telescope-undo.nvim | `<leader>su`. `<CR>` yanks selected additions. `<C-r>` restores an undo state. | Searches and restores persistent undo history for the current buffer. |
| grug-far.nvim | `<leader>sr` | Project-wide find and replace UI. |

## Git

| Plugin | Key | When to use |
|---|---|---|
| Neogit | `<leader>gg`. In status, `c` commits, `P` pushes, `b` branches, `m` merges, `p` pulls, `r` rebases, and `?` opens help. | Git status UI with confirmation popups. |
| Telescope Git | `<leader>gc` / `<leader>gl` commits, `<leader>gs` status, `<leader>gS` stash. | Browses Git history, worktree state, and stashes. |
| gitsigns | gutter signs, `]h`/`[h`, `<leader>ghs` stage hunk, `<leader>ghr` reset hunk | Shows Git status in the buffer. |
| octo.nvim | `<leader>gi` issues, `<leader>gp` PRs, `<leader>g/` GitHub search | GitHub issues and PRs. Run `gh auth login` first. |

## LSP / coding intelligence

| Plugin | Key | What |
|---|---|---|
| nvim-lspconfig + mason | `gd` def, `gr` refs, `K` hover, `<leader>ca` code action, `<leader>cr` rename, `<leader>cd` line diagnostics | Language servers. Mason installs them by language. |
| blink.cmp | `<Tab>` accept, `<C-Space>` open menu, `:` and `/` cmdline completion | Completion engine with friendly-snippets expansion. |
| conform.nvim | `<leader>cf` or automatic on save | ruff for Python, clang-format for C/C++, and prettier for web files. |
| trouble.nvim | `<leader>xx` | Lists project errors and warnings. |
| todo-comments.nvim | `<leader>st` | Highlights and lists TODO, FIXME, and HACK comments. |

## Debugging & testing

| Plugin | Key | What |
|---|---|---|
| nvim-dap + dap-ui | `<leader>db` toggle breakpoint, `<leader>dc` continue, `<leader>du` UI, `<leader>de` eval | Debugger. Uses codelldb for C/C++/Rust and debugpy for Python. |
| neotest | `<leader>tt` file, `<leader>tr` nearest, `<leader>ts` summary | Test runner with neotest-python. |
| overseer | `<leader>oo` run task, `<leader>ow` task list | Runs tasks. |
| cmake-tools | `<leader>cg` configure, `<leader>cG` clean cache and configure, `<leader>cb` build | CMake projects. Builds in `build` and sends output to Overseer. |

## Languages enabled

| Lang | LSP / tooling |
|---|---|
| C / C++ | clangd with `--clang-tidy` and query drivers for ESP32, AVR, ARM, and Zephyr. Also clang-format and codelldb. See `EMBEDDED.md`. |
| Devicetree (`.dts`, `.dtsi`, `.overlay`) | `dts-lsp` and the Treesitter `devicetree` parser. `.overlay` detects as `dts`. No formatter. See `EMBEDDED.md`. |
| Kconfig (`Kconfig*`, `prj.conf`, Zephyr `boards/*.conf`) | Treesitter `kconfig` parser and the built-in `kconfig` ftplugin. No LSP or formatter. See `EMBEDDED.md`. |
| Linker scripts (`.ld`, `.lds`, `.x`) | Treesitter `linkerscript` parser and the built-in `ld` ftplugin. No LSP or formatter. |
| Python | basedpyright (LSP), ruff (lint + format), debugpy (DAP), neotest-python |
| Rust | rustaceanvim, rust-analyzer, codelldb (DAP) |
| CMake | cmake-language-server |
| JSON / YAML | json-ls, yaml-ls |
| Markdown | marksman LSP, render-markdown.nvim, and Treesitter parsers for Markdown, HTML, LaTeX, and YAML |
| Nix | nil LSP |
| Shell / dotfiles | bashls, shellcheck (via util.dot) |
| Web (CSS/HTML/JS/TS/Vue/etc.) | Prettier formatter. Add the `lang.typescript` extra for web LSPs. |
| Git files (commit/config/rebase) | Treesitter parsers for Git syntax |

## AI

| Plugin | Key | What |
|---|---|---|
| claudecode.nvim | `<leader>ac` toggle, `<leader>af` focus, `<leader>as` send selection, `<leader>ar` resume | Side panel for the Claude Code CLI. |

## Layout

| Plugin | Key | What |
|---|---|---|
| edgy.nvim | `<leader>ue` toggle, `<leader>uE` select | Keeps Trouble, Aerial, Grug Far, Neotest, and the terminal in fixed side panels. |

## Custom overrides

### `lua/plugins/`

| File | Purpose |
|---|---|
| `lsp.lua` | clangd query drivers for ESP32, AVR, ARM, and Zephyr. Also sets the Marksman NixOS ICU workaround. |
| `cmake.lua` | cmake-tools.nvim with a relative `build` directory and Overseer executor. Maps configure and build commands. |
| `formatters.lua` | Routes Python to ruff and C/C++ to clang-format. Mason installs clang-format. |
| `edgy.lua` | Places Aerial in the right-side edgy panel so it does not clash with Grug Far. |
| `refactoring.lua` | Adds `lewis6991/async.nvim` and maps Extract Function and Extract Block To File. |
| `git.lua` | Configures Neogit with Telescope selectors and Diffview. |
| `octo.lua` | Maps Octo GitHub search to `<leader>g/` so Telescope keeps `<leader>gS` for Git stash. |
| `telescope-undo.lua` | Adds undo history to Telescope at `<leader>su`. |
| `render-markdown.lua` | Configures the Markdown renderer and LSP checkbox and callout completions. |
| `treesitter.lua` | Installs parsers for Markdown, HTML, LaTeX, YAML, Devicetree, Kconfig, and linker scripts. |
| `zephyr.lua` | Adds Devicetree filetype and LSP support, plus Kconfig and linker-script filetype detection. |
| `overseer.lua` | Adds west and PlatformIO tasks. Each command first sources `.zephyrrc`, `.envrc`, or `env.sh` when present. |

### `lua/config/`

| File | Purpose |
|---|---|
| `autocmds.lua` | Opens Snacks.explorer on `VimEnter` and `DirChanged`. |
| `options.lua` | Sets `clipboard=unnamedplus` and OSC 52 so SSH yanks reach the local clipboard. |
