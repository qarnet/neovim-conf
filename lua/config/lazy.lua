local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  spec = {
    -- Load LazyVim and its plugin specs.
    { "LazyVim/LazyVim", import = "lazyvim.plugins" },
    -- Load local plugin specs and overrides.
    { import = "plugins" },
  },
  defaults = {
    -- Local specs load at startup unless they opt into lazy loading.
    lazy = false,
    -- Follow upstream commits. Versioned releases can lag behind.
    version = false,
    -- version = "*", -- Use the latest SemVer release when supported.
  },
  install = { colorscheme = { "tokyonight", "habamax" } },
  checker = {
    enabled = true, -- Check for plugin updates.
    notify = false, -- Do not notify about updates.
  },
  performance = {
    rtp = {
      -- Disable unused runtime plugins.
      disabled_plugins = {
        "gzip",
        -- "matchit",
        -- "matchparen",
        -- "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})
