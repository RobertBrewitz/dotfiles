local Remap = require("jrbb.keymap")
local nnoremap = Remap.nnoremap

-- Disable inline messages
vim.diagnostic.config({ virtual_text = false })

nnoremap("<leader>gl", function() vim.diagnostic.setloclist() end)
nnoremap("<leader>gg", function()
  vim.diagnostic.setqflist()
  vim.cmd("cclose")
  vim.cmd("cnext")
end)
nnoremap("<C-k>", function() vim.diagnostic.goto_next() end)
nnoremap("<C-j>", function() vim.diagnostic.goto_prev() end)
