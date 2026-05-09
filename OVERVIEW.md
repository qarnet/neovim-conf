# Plugin overview

Reference for what's installed, organized by what it helps with.

## Discovery shortcuts

- **`<leader>`** then wait — `which-key` pops up showing every available next-key.
- **`:LazyExtras`** — interactive UI listing all available LazyVim extras with descriptions, toggle on/off.
- **`:Lazy`** — lazy.nvim plugin manager UI.
- **`:Mason`** — LSPs / formatters / linters / DAP installer UI.

## Navigation — moving around fast

| Plugin | Key | When to use |
|---|---|---|
| **flash.nvim** | `s` then 2 chars | Jump anywhere on screen in 2 keystrokes. |
| **harpoon** | `<leader>H` add, `<leader>1`-`<leader>9` jump, `<leader>h` menu | Pin 3-5 active files; instant switch. |
| **aerial** | `<leader>cs` | Symbol outline of current file (right sidebar). |
| **illuminate** | (auto), `]]` / `[[` | Highlights other instances of word under cursor. |
| **treesitter-context** | always on, toggle `<leader>ut` | Sticky function header at top of window. |

## Editing — manipulating text

| Plugin | Key | When to use |
|---|---|---|
| **mini.surround** | `gsa` add, `gsd` delete, `gsr` replace | `gsaiw"` adds quotes around inner word. |
| **mini.comment** | `gcc` line, `gc` + motion | `gcap` comments a paragraph. |
| **mini.move** | `<M-h/j/k/l>` | Move current line/selection in any direction. |
| **dial.nvim** | `<C-a>` / `<C-x>` | Smart increment: numbers, dates, booleans. |
| **yanky** | `<leader>p` | Yank history picker. |
| **inc-rename** | `<leader>cr` | LSP rename with live preview. |
| **refactoring** | `<leader>rf` Extract Function, `<leader>rB` Extract Block To File | Pull selection into a new function/file. |
| **mini.pairs** | (auto) | Auto-close brackets/quotes. |

## Visual — seeing code structure

| Plugin | What |
|---|---|
| **mini.indentscope** | Animated line showing current indent block. |
| **mini.hipatterns** | Highlights hex colors (`#ff0000`) and Tailwind class colors inline. |
| **noice.nvim** | Replaces cmdline + popup menu UI; cleaner messages. |
| **bufferline** | Tab bar at top showing open buffers. |
| **lualine** | Statusline at bottom. |
| **render-markdown.nvim** | Renders markdown inline (headers, bullets, code blocks) in `.md` buffers. |

## Files & search

| Plugin | Key | When to use |
|---|---|---|
| **snacks.explorer** | `<leader>e` open. Inside: `H` toggle hidden (dotfiles), `I` toggle ignored (gitignored), `u` refresh, `a` add, `d` delete, `r` rename, `m` move, `c` copy, `<CR>`/`l` open, `h` close dir. | File tree. Auto-opens as left sidebar at startup and on project switch. |
| **snacks.picker** | `<leader>ff` files, `<leader>sg` grep, `<leader>,` buffers, `<leader>fp` projects | Fuzzy finder. The four most-used keys in nvim. |
| **grug-far.nvim** | `<leader>sr` | Project-wide find/replace UI. |
| **snacks.dashboard** | startup screen | Recent files, project switcher. |

## Git

| Plugin | Key | When to use |
|---|---|---|
| **lazygit** | `<leader>gg` | Full git TUI. Stage hunks, commit, push, log. |
| **gitsigns** | gutter signs, `]h`/`[h`, `<leader>ghs` stage hunk, `<leader>ghr` reset hunk | In-buffer git status. |
| **octo.nvim** | `<leader>gi` issues, `<leader>gp` PRs | GitHub issues/PRs. Run `gh auth login` first. |

## LSP / coding intelligence

| Plugin | Key | What |
|---|---|---|
| **nvim-lspconfig** + **mason** | `gd` def, `gr` refs, `K` hover, `<leader>ca` code action, `<leader>cr` rename, `<leader>cd` line diagnostics | Language servers; Mason auto-installs them per language. |
| **blink.cmp** | `<Tab>` accept, `<C-Space>` open menu, `:` and `/` cmdline completion | Completion engine; includes friendly-snippets snippet expansion. |
| **conform.nvim** | `<leader>cf` or auto on save | Formatters: ruff (Python), clang-format (C/C++), prettier (web). |
| **trouble.nvim** | `<leader>xx` | Diagnostics list — all errors/warnings in project. |
| **todo-comments.nvim** | `<leader>st` | Highlights/lists TODO, FIXME, HACK comments. |

## Debugging & testing

| Plugin | Key | What |
|---|---|---|
| **nvim-dap** + **dap-ui** | `<leader>db` toggle breakpoint, `<leader>dc` continue, `<leader>du` UI, `<leader>de` eval | Debugger. Adapters: codelldb (C/C++/Rust), debugpy (Python). |
| **neotest** | `<leader>tt` file, `<leader>tr` nearest, `<leader>ts` summary | Test runner. Adapter: neotest-python. |
| **overseer** | `<leader>oo` run task, `<leader>ow` task list | Generic task runner. |

## Languages enabled

| Lang | LSP / tooling |
|---|---|
| C / C++ | clangd (with `--clang-tidy`, query-driver for ESP32 xtensa+RISC-V, AVR, ARM/Zephyr), clang-format, codelldb (DAP). See `EMBEDDED.md` for cross-compile workflow. |
| Python | basedpyright (LSP), ruff (lint + format), debugpy (DAP), neotest-python |
| Rust | rustaceanvim, rust-analyzer, codelldb (DAP) |
| CMake | cmake-language-server |
| JSON / YAML | json-ls, yaml-ls |
| Markdown | marksman LSP, render-markdown.nvim |
| Nix | nil LSP |
| Shell / dotfiles | bashls, shellcheck (via util.dot) |
| Web (CSS/HTML/JS/TS/Vue/etc.) | Prettier formatter (LSPs not pre-enabled — add `lang.typescript` extra if needed) |
| Git files (commit/config/rebase) | treesitter parsers + cmp-git source |

## AI

| Plugin | Key | What |
|---|---|---|
| **copilot.lua** | inline ghost text; `<M-]>` next, `<M-[>` prev, `<Tab>` accept | Run `:Copilot auth` once. |
| **claudecode.nvim** | `<leader>ac` toggle, `<leader>af` focus, `<leader>as` send selection, `<leader>ar` resume | Side panel running Claude Code CLI. |

## Layout

| Plugin | Key | What |
|---|---|---|
| **edgy.nvim** | `<leader>ue` toggle, `<leader>uE` select | Pins sidebar plugins (Trouble, Aerial, Grug Far, Neotest, terminal) to consistent positions. |

## Custom overrides

### `lua/plugins/`

| File | Purpose |
|---|---|
| `lsp.lua` | Clangd config: `--clang-tidy`, broad query-driver covering ESP32 (xtensa+RISC-V), AVR, ARM (`arm-none-eabi`), Zephyr (`arm-zephyr-eabi`) |
| `formatters.lua` | Conform routing: Python → ruff, C/C++ → clang-format; Mason auto-installs clang-format |
| `edgy.lua` | Registers Aerial as edgy right-side tenant (so Aerial + Grug Far don't fight for screen space) |
| `refactoring.lua` | Adds missing `lewis6991/async.nvim` dependency; explicit `<leader>rf` (Extract Function) and `<leader>rB` (Extract Block To File) |
| `snacks-keys.lua` | `<leader>fp` → `Snacks.picker.projects()` (replaces `util.project` keymap which only works with telescope/fzf-lua) |

### `lua/config/`

| File | Purpose |
|---|---|
| `autocmds.lua` | `VimEnter` + `DirChanged` hooks to auto-open Snacks.explorer at startup and on project switch |
