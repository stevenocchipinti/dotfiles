-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Easier way to copy and paste from the system clipboard
vim.keymap.set("", "<localleader>p", '"+p', { desc = "Global clipboard paste" })
vim.keymap.set("", "<localleader>y", '"+y', { desc = "Global clipboard copy" })

-- Shortcut for spellcheck
vim.keymap.set(
  "n",
  "<leader>z",
  ":set spell<cr>z=",
  { desc = "Enable spell check and suggestions" }
)
vim.keymap.set(
  "n",
  "<leader>Z",
  ":set nospell<cr>",
  { desc = "Disable spell check" }
)

-- Sudo write
vim.keymap.set("c", "w!!", "w !sudo tee %")

-- Keep the cursor still and highlight matches when pressing *
vim.keymap.set(
  "n",
  "*",
  [[ v:count ? '*' : ':set hls <Bar> execute "keepjumps normal! *" <Bar> call winrestview(' . string(winsaveview()) . ')<CR>' ]],
  { silent = true, expr = true }
)

-- These LazyVim "defaults" annoy me
vim.keymap.del("n", "L")
vim.keymap.del("n", "H")

-- Instead of arrow keys from insert mode
vim.keymap.set("i", "<M-h>", "<left>")
vim.keymap.set("i", "<M-j>", "<down>")
vim.keymap.set("i", "<M-k>", "<up>")
vim.keymap.set("i", "<M-l>", "<right>")

-- An easier way to exit the terminal
vim.keymap.set(
  "t",
  "<Esc><Esc>",
  [[<C-\><C-n>]],
  { desc = "Exit terminal mode" }
)
