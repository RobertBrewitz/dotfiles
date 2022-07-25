local Remap = require("jrbb.keymap")
local nnoremap = Remap.nnoremap

nnoremap("<silent> <leader>gd", "<cmd>lua vim.lsp.buf.definition()<CR>")
nnoremap("<silent> <leader>d", "<cmd>lua vim.lsp.buf.hover()<CR>")
nnoremap("<silent> <leader>gi", "<cmd>lua vim.lsp.buf.implementation()<CR>")
nnoremap("<silent> <leader>gs", "<cmd>lua vim.lsp.buf.signature_help()<CR>")
nnoremap("<silent> <leader>gy", "<cmd>lua vim.lsp.buf.type_definition()<CR>")
nnoremap("<silent> <leader>gr", "<cmd>lua vim.lsp.buf.references()<CR>")
nnoremap("<silent> <leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>")
