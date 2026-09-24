-- Function keys avoid bracket mappings, which are awkward on many European
-- keyboard layouts. These work from any normal buffer, including quickfix.
vim.keymap.set("n", "<F8>", "<Cmd>cnext<CR>", { desc = "Next build error" })
vim.keymap.set("n", "<S-F8>", "<Cmd>cprev<CR>", { desc = "Previous build error" })
