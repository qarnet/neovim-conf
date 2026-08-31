-- Rust lifetimes use apostrophes; do not autopair them in Rust buffers.
vim.keymap.set("i", "'", "'", { buffer = true, desc = "Literal apostrophe" })

-- Expand a frequently typed type without completion-menu delay.
vim.cmd([[inoreabbrev <buffer> sstr &'static str]])
