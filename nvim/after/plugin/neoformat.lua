local autocmd = vim.api.nvim_create_autocmd

autocmd({"BufWritePre"}, {
  command = "Neoformat",
  pattern = "*.{t,j}s"
})

vim.g.neoformat_try_node_exe = 1
