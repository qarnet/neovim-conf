-- Add local autocmds here. LazyVim defaults live at:
-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua

-- Open Snacks Explorer without toggling an existing explorer closed.
-- Retry while snacks.nvim finishes loading during startup.
local function open_explorer()
  local tries = 0
  local function attempt()
    tries = tries + 1
    if Snacks and Snacks.explorer and Snacks.picker then
      -- A prior call or directory handler opened it. Do not call the toggle.
      if #Snacks.picker.get({ source = "explorer" }) > 0 then
        return
      end
      -- Leave dashboard buffers alone. Retry after they close.
      local ft = vim.bo.filetype
      if ft ~= "snacks_dashboard" and ft ~= "alpha" and ft ~= "starter" then
        -- Snacks can return before it creates a window. An immediate retry
        -- toggles the explorer off, so wait 500 ms between attempts.
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

-- Startup behavior:
--   nvim              Empty buffer. Keep the current directory.
--   nvim path/file    Open the file. Change to its parent directory.
--   nvim path/folder/ Change to the directory. Snacks removes the directory buffer.
-- Snacks Explorer opens at the resulting directory.
local function run_startup()
  -- With multiple paths, keep the current directory and open the explorer.
  if vim.fn.argc() > 1 then
    vim.g.user_startup_done = true
    open_explorer()
    return
  end

  local arg = vim.fn.argv(0) -- Empty when nvim has no arguments.
  local is_dir = false
  if arg ~= "" then
    local path = vim.fn.fnamemodify(arg, ":p")
    if vim.fn.isdirectory(path) == 1 then
      -- Snacks handles directory arguments and clears the directory buffer.
      -- Reopening the explorer here would toggle it off.
      is_dir = true
      vim.cmd("cd " .. vim.fn.fnameescape(path))
    else
      -- For an existing or new file, use its parent directory.
      local dir = vim.fn.fnamemodify(path, ":h")
      if vim.fn.isdirectory(dir) == 1 then
        vim.cmd("cd " .. vim.fn.fnameescape(dir))
      end
    end
  end

  -- Ignore the DirChanged event caused by the directory change above.
  vim.g.user_startup_done = true
  -- Snacks already opens Explorer for a directory argument.
  if not is_dir then
    open_explorer()
  end
end

-- With no arguments, LazyVim loads this file on VeryLazy, after VimEnter.
-- Run startup now in that case. For file and directory arguments, wait for
-- VimEnter before changing the directory.
if vim.v.vim_did_enter == 1 then
  run_startup()
else
  vim.api.nvim_create_autocmd("VimEnter", {
    group = vim.api.nvim_create_augroup("user_startup", { clear = true }),
    once = true,
    callback = run_startup,
  })
end

-- Reopen Explorer for global directory changes from the project picker, `:cd`,
-- or persistence.nvim. Ignore the startup directory change above.
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
