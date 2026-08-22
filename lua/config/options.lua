-- Local options. LazyVim defaults live at:
-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua

-- Use the `+` register for the system clipboard.
-- Keep this explicit if LazyVim changes its defaults.
vim.opt.clipboard = "unnamedplus"

-- Send yanks to the local clipboard over SSH with OSC 52. Neovim emits an
-- escape sequence. The terminal writes its contents to the local clipboard.
-- This avoids xclip, wl-copy, and win32yank.
--
-- Yank support includes Konsole 22.04+, kitty, wezterm, alacritty, and foot.
-- Most terminals disable OSC 52 paste for security. If `"+p` does nothing,
-- paste with Ctrl+Shift+V in insert mode. In tmux, add
-- `set -g set-clipboard on` to ~/.tmux.conf.
local osc52 = require("vim.ui.clipboard.osc52")
vim.g.clipboard = {
  name = "OSC 52",
  copy = {
    ["+"] = osc52.copy("+"),
    ["*"] = osc52.copy("*"),
  },
  -- OSC 52 paste waits for a terminal response. Most terminals disable that
  -- response for security, so read the last yank from the unnamed register.
  -- Use Ctrl+Shift+V or the terminal paste command for external clipboard data.
  paste = {
    ["+"] = function()
      return { vim.split(vim.fn.getreg('"'), "\n"), vim.fn.getregtype('"') }
    end,
    ["*"] = function()
      return { vim.split(vim.fn.getreg('"'), "\n"), vim.fn.getregtype('"') }
    end,
  },
}

vim.diagnostic.config({ virtual_lines = { current_line = true } })
