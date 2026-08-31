# Neovim quick reference

Commands worth memorizing for this config. `<leader>` means `Space` unless the
leader key has been changed.

## Commenting

| Keys | Mode | Action |
|---|---|---|
| `gcc` | Normal | Toggle comment on current line. |
| `gc` | Visual | Toggle comments on selected text or lines. |
| `gc` + motion | Normal | Toggle comments over motion, such as `gcap` for paragraph. |

To comment several lines:

1. Press `V` to select current line.
2. Extend selection with `j` or `k`.
3. Press `gc` to toggle comments.

## Selecting, copying, and deleting

| Keys | Mode | Action |
|---|---|---|
| `v` | Normal | Start character selection. |
| `V` | Normal | Start whole-line selection. |
| `<C-v>` | Normal | Start rectangular block selection. |
| `j` / `k` | Visual | Extend selection down or up. |
| `y` | Visual | Copy selected text. |
| `d` | Visual | Delete selected text. |
| `yy` | Normal | Copy current line. |
| `dd` | Normal | Delete current line. |
| `p` / `P` | Normal | Paste after or before cursor. |
| `<leader>p` | Normal or Visual | Open yank history. |

Common line workflow: press `V`, select lines with `j` or `k`, then press `gc`,
`y`, or `d`. Use `yy` and `dd` directly from Normal mode when acting on current
line without making selection.

Copied text goes to system clipboard through this config's `unnamedplus`
setting and OSC 52 clipboard support.

## Beginner motions

| Keys | Action |
|---|---|
| `w` / `b` | Move to next or previous word start. |
| `e` | Move to end of word. |
| `0` / `^` | Move to start of line or first nonblank character. |
| `$` | Move to end of line. |
| `gg` / `G` | Move to start or end of file. |
| `{` / `}` | Move to previous or next paragraph. |
| `%` | Jump between matching brackets. |
| `f<char>` | Jump to next `<char>` on current line. |
| `t<char>` | Jump just before next `<char>` on current line. |
| `;` / `,` | Repeat last character jump forward or backward. |
| `<C-d>` / `<C-u>` | Move half-page down or up. |
| `*` / `#` | Search for word under cursor forward or backward. |
| `n` / `N` | Move to next or previous search result. |
| `u` / `<C-r>` | Undo or redo. |
| `.` | Repeat last edit. |

Counts repeat motions and commands. For example, `3j` moves down three lines,
`3w` moves forward three words, and `3dd` deletes three lines.

## Operators with motions

Vim commands often combine operator with motion. Common operators are `d` to
delete, `y` to copy, and `gc` to toggle comments.

| Keys | Action |
|---|---|
| `dw` | Delete to next word. |
| `d$` | Delete to end of line. |
| `y}` | Copy through next paragraph. |
| `gc}` | Toggle comments through next paragraph. |
| `d3j` | Delete current line and next three lines. |

## Code navigation

| Keys | Action |
|---|---|
| `<leader>cs` | Open Aerial's persistent symbol outline for current file. |
| `<leader>ss` | Search current-file symbols and preview their declarations. |
| `K` | Show LSP signature and documentation for symbol under cursor. |

Use `<leader>cs` for persistent function list. Use `<leader>ss` when source
preview helps. Place cursor on symbol and press `K` for LSP details.
