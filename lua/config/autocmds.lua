-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- Auto-open Snacks.explorer as a left sidebar when nvim is started
-- with no args or with a directory.
vim.api.nvim_create_autocmd("VimEnter", {
  group = vim.api.nvim_create_augroup("user_explorer_autoopen", { clear = true }),
  callback = function()
    local arg = vim.fn.argv(0)
    if vim.fn.argc() == 0 or (arg and vim.fn.isdirectory(arg) == 1) then
      Snacks.explorer()
    end
  end,
})
