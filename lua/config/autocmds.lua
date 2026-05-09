-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

local function open_explorer()
  vim.schedule(function()
    local ft = vim.bo.filetype
    if ft == "snacks_dashboard" or ft == "alpha" or ft == "starter" then
      return
    end
    pcall(Snacks.explorer)
  end)
end

-- Open Snacks.explorer as a left sidebar at startup
vim.api.nvim_create_autocmd("VimEnter", {
  group = vim.api.nvim_create_augroup("user_explorer_autoopen", { clear = true }),
  callback = open_explorer,
})

-- Re-open Snacks.explorer when switching projects (DirChanged on global scope)
-- Triggers for: Snacks.picker.projects, dashboard "Projects" entry, :cd, persistence.nvim
vim.api.nvim_create_autocmd("DirChanged", {
  group = vim.api.nvim_create_augroup("user_explorer_on_dir_change", { clear = true }),
  callback = function()
    if vim.v.event.scope == "global" then
      open_explorer()
    end
  end,
})
