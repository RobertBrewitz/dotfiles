local autocmd = vim.api.nvim_create_autocmd

autocmd({"BufWritePre"}, {
  command = "Neoformat",
  pattern = "*.rs"
})

autocmd({"BufWritePre"}, {
  command = "Neoformat",
  pattern = "*.{t,j}s"
})

autocmd({"BufWritePre"}, {
  command = "Neoformat",
  pattern = "*.{t,j}sx"
})

autocmd({"BufWritePre"}, {
  command = "Neoformat",
  pattern = "*.json"
})

autocmd({"BufWritePre"}, {
  command = "Neoformat",
  pattern = "*.md"
})

vim.g.neoformat_try_node_exe = 1
