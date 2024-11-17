local Remap = require("jrbb.keymap")
local nnoremap = Remap.nnoremap

-- folding
nnoremap("<leader>f", "za")
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt.foldtext = "v:lua.vim.treesitter.foldtext()"
vim.opt.foldcolumn = "0"
vim.opt.foldtext = ""
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99

local function fold_headings_of_level(level)
  vim.cmd("normal! gg")
  local total_lines = vim.fn.line("$")
  for line = 1, total_lines do
    local line_content = vim.fn.getline(line)
    if line_content:match("^" .. string.rep("#", level) .. "%s") then
      vim.fn.cursor(line, 1)
      if vim.fn.foldclosed(line) == -1 then
        vim.cmd("normal! za")
      end
    end
  end
end

local function fold_markdown_headings(levels)
  local saved_view = vim.fn.winsaveview()
  for _, level in ipairs(levels) do
    fold_headings_of_level(level)
  end
  vim.cmd("nohlsearch")
  vim.fn.winrestview(saved_view)
end

vim.keymap.set("n", "zj", function()
  vim.cmd("edit!")
  vim.cmd("normal! zR")
  fold_markdown_headings({ 6, 5, 4, 3, 2, 1 })
end)

vim.keymap.set("n", "zk", function()
  vim.cmd("edit!")
  vim.cmd("normal! zR")
  fold_markdown_headings({ 6, 5, 4, 3, 2 })
end)

vim.keymap.set("n", "zl", function()
  vim.cmd("edit!")
  vim.cmd("normal! zR")
  fold_markdown_headings({ 6, 5, 4, 3 })
end)

vim.keymap.set("n", "z;", function()
  vim.cmd("edit!")
  vim.cmd("normal! zR")
  fold_markdown_headings({ 6, 5, 4 })
end)
