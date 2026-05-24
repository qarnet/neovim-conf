-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Route yank/paste through the `+` register (system clipboard).
-- LazyVim already sets this, but pinning it here keeps it stable if defaults change.
vim.opt.clipboard = "unnamedplus"

-- OSC 52 clipboard provider.
-- Works over SSH: nvim emits an escape sequence carrying clipboard data,
-- the local terminal (Konsole/kitty/wezterm/...) intercepts it and writes
-- to the LOCAL machine's clipboard. No xclip/wl-copy/win32yank needed.
--
-- Notes:
--   * Yank → local clipboard works in Konsole 22.04+, kitty, wezterm, alacritty, foot.
--   * Paste over OSC 52 is disabled by default in most terminals (security).
--     If `"+p` does nothing, paste with Ctrl+Shift+V in insert mode instead.
--   * If using tmux, add `set -g set-clipboard on` to ~/.tmux.conf.
local osc52 = require("vim.ui.clipboard.osc52")
vim.g.clipboard = {
  name = "OSC 52",
  copy = {
    ["+"] = osc52.copy("+"),
    ["*"] = osc52.copy("*"),
  },
  -- OSC 52 paste requires the terminal to respond to a query escape sequence.
  -- Most terminals have this disabled (security), causing Neovim to block/timeout.
  -- Instead, read from the unnamed register (last yank). For content copied outside
  -- Neovim, use Ctrl+Shift+V in insert mode or the terminal's native paste.
  paste = {
    ["+"] = function()
      return { vim.split(vim.fn.getreg('"'), "\n"), vim.fn.getregtype('"') }
    end,
    ["*"] = function()
      return { vim.split(vim.fn.getreg('"'), "\n"), vim.fn.getregtype('"') }
    end,
  },
}
