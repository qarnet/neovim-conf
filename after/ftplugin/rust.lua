-- Rust lifetimes use apostrophes; do not autopair them in Rust buffers.
vim.keymap.set("i", "'", "'", { buffer = true, desc = "Literal apostrophe" })

-- Expand a frequently typed type without completion-menu delay.
vim.cmd([[inoreabbrev <buffer> sstr &'static str]])

local cargo_expand = require("config.cargo_expand")
cargo_expand.setup()

vim.keymap.set("n", "<leader>cm", "<cmd>RustLsp expandMacro float<cr>", {
  buffer = true,
  desc = "Expand Rust Macro",
})
vim.keymap.set("n", "<leader>ce", "<cmd>CargoExpandItem<cr>", {
  buffer = true,
  desc = "Expand Rust Item",
})
