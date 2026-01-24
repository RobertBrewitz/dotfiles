vim.opt.number = false
vim.opt.relativenumber = false
vim.opt.signcolumn = "no"
vim.opt.showtabline = 0
vim.opt.laststatus = 0
vim.opt.clipboard = "unnamedplus"

vim.keymap.set("n", "q", "<cmd>qa!<cr>")

vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    vim.cmd("normal G")
    vim.bo.buftype = "nofile"
    vim.bo.modifiable = false
  end,
})
