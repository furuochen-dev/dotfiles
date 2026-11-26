vim.g.mapleader = " "

local keymap = vim.keymap -- shorthand

keymap.set("i", "jk", "<ESC>", { desc = "Exit insert mode with jk" })
keymap.set("i", "kj", "<ESC>", { desc = "Exit insert mode with kj" })

keymap.set("n", "<leader>nh", ":nohl<CR>", { desc = "Clear search highlights" })

keymap.set("n", "<leader>+", "<C-a>", { desc = "Increment number" }) -- increment
keymap.set("n", "<leader>-", "<C-x>", { desc = "Decrement number" }) -- decrement

-- window management
keymap.set("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" })                   -- split window vertically
keymap.set("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" })                 -- split window horizontally
keymap.set("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" })                    -- make split windows equal width & height
keymap.set("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close current split" })               -- close current split window

keymap.set("n", "<leader>to", "<cmd>tabnew<CR>", { desc = "Open new tab" })                     -- open new tab
keymap.set("n", "<leader>tx", "<cmd>tabclose<CR>", { desc = "Close current tab" })              -- close current tab
keymap.set("n", "<leader>tn", "<cmd>tabn<CR>", { desc = "Go to next tab" })                     --  go to next tab
keymap.set("n", "<leader>tp", "<cmd>tabp<CR>", { desc = "Go to previous tab" })                 --  go to previous tab
keymap.set("n", "<leader>tf", "<cmd>tabnew %<CR>", { desc = "Open current buffer in new tab" }) --  move current buffer to new tab

vim.keymap.set('n', '<leader>d', function()
  vim.diagnostic.open_float(nil, { scope = 'cursor' }) -- Opens float for diagnostic under cursor
end, { desc = 'Open diagnostic float' })

-- Softwrap only: j/k (and counts like 3j) move by screen line; otherwise normal lines.
-- Do NOT prepend v:count — Neovim already applies the typed count to the RHS.
-- (Returning "3gj" would double the count and jump too far.)
-- expr + noremap: returned "j"/"k" are not remapped, so no recursion when wrap is off.
local function move_by_line(key, wrapped)
  return function()
    if vim.wo.wrap then
      return wrapped
    end
    return key
  end
end

keymap.set({ "n", "x" }, "j", move_by_line("j", "gj"), { expr = true, silent = true })
keymap.set({ "n", "x" }, "k", move_by_line("k", "gk"), { expr = true, silent = true })
