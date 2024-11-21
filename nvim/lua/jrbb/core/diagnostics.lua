local Remap = require("jrbb.keymap")
local nnoremap = Remap.nnoremap

-- Disable inline messages
vim.diagnostic.config({ virtual_text = false })

-- Turn on floating window diagnostics border
vim.diagnostic.config({ float = { border = "single" } })

nnoremap("<leader>gl", vim.diagnostic.setloclist)
nnoremap("<C-k>", vim.diagnostic.goto_next)
nnoremap("<C-j>", vim.diagnostic.goto_prev)
--nnoremap("<leader>gg", function()
--  vim.diagnostic.setqflist()
--  vim.cmd("cclose")
--  vim.cmd("cnext")
--end)
