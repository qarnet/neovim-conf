-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- Open the Snacks.explorer sidebar, but never toggle it closed.
-- Snacks.explorer() is a toggle, so we guard against an already-open explorer.
-- It also retries, because at startup snacks.nvim may not be loaded yet when
-- this first runs (an early call would silently no-op).
local function open_explorer()
  local tries = 0
  local function attempt()
    tries = tries + 1
    if Snacks and Snacks.explorer and Snacks.picker then
      -- Already open (we succeeded, or snacks opened it for a directory arg):
      -- stop. This guard also prevents toggling an open explorer closed.
      if #Snacks.picker.get({ source = "explorer" }) > 0 then
        return
      end
      -- Don't open over a start screen; just keep polling until it's gone.
      local ft = vim.bo.filetype
      if ft ~= "snacks_dashboard" and ft ~= "alpha" and ft ~= "starter" then
        -- Early in startup this call returns ok but silently no-ops; worse,
        -- Snacks.explorer() is a toggle, so two calls in the early window
        -- cancel out. The "already open" guard above + the wide 500ms retry
        -- interval below ensure each call's effect resolves (open latency is
        -- well under 500ms) before the next attempt, so it opens exactly once.
        pcall(function()
          Snacks.explorer()
        end)
      end
    end
    if tries < 12 then
      vim.defer_fn(attempt, 500)
    end
  end
  vim.schedule(attempt)
end

-- Startup behavior based on the launch argument:
--   nvim              -> empty buffer, cwd unchanged
--   nvim path/file    -> open file, cd into the file's folder
--   nvim path/folder/ -> cd into the folder, empty buffer (no dir/netrw buffer)
-- In all cases the Snacks.explorer sidebar opens, rooted at the resulting cwd.
local function run_startup()
  -- More than one path argument: leave cwd alone, just open the explorer.
  if vim.fn.argc() > 1 then
    vim.g.user_startup_done = true
    open_explorer()
    return
  end

  local arg = vim.fn.argv(0) -- "" when launched with no arguments
  local is_dir = false
  if arg ~= "" then
    local path = vim.fn.fnamemodify(arg, ":p")
    if vim.fn.isdirectory(path) == 1 then
      -- Directory argument: just cd into it. Snacks' replace_netrw handler
      -- already opens the explorer and blanks the directory buffer, so we
      -- must NOT create another buffer or re-open (toggle) the explorer.
      is_dir = true
      vim.cmd("cd " .. vim.fn.fnameescape(path))
    else
      -- File argument (existing or new): cd into its parent folder.
      local dir = vim.fn.fnamemodify(path, ":h")
      if vim.fn.isdirectory(dir) == 1 then
        vim.cmd("cd " .. vim.fn.fnameescape(dir))
      end
    end
  end

  -- Mark startup complete only after the cd above (its DirChanged must be ignored).
  vim.g.user_startup_done = true
  -- For a directory arg, Snacks already opens the explorer; opening it
  -- ourselves would toggle it closed.
  if not is_dir then
    open_explorer()
  end
end

-- LazyVim defers loading this file until VeryLazy when nvim is launched with no
-- arguments (config/init.lua: `lazy_autocmds = argc(-1) == 0`). VeryLazy fires
-- after VimEnter, so a VimEnter autocmd registered here would never run in the
-- no-args case. Detect that: if we're already past VimEnter, run immediately;
-- otherwise (launched with a file/dir arg) wait for VimEnter.
if vim.v.vim_did_enter == 1 then
  run_startup()
else
  vim.api.nvim_create_autocmd("VimEnter", {
    group = vim.api.nvim_create_augroup("user_startup", { clear = true }),
    once = true,
    callback = run_startup,
  })
end

-- Re-open Snacks.explorer when switching projects (DirChanged on global scope).
-- Triggers for: Snacks.picker.projects, :cd, persistence.nvim. Skipped during the
-- startup cd above, which opens the explorer itself.
vim.api.nvim_create_autocmd("DirChanged", {
  group = vim.api.nvim_create_augroup("user_explorer_on_dir_change", { clear = true }),
  callback = function()
    if not vim.g.user_startup_done then
      return
    end
    if vim.v.event.scope == "global" then
      open_explorer()
    end
  end,
})
