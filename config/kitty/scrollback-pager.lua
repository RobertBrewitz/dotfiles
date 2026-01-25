vim.opt.number = false
vim.opt.relativenumber = false
vim.opt.signcolumn = "no"
vim.opt.showtabline = 0
vim.opt.laststatus = 0
vim.opt.clipboard = "unnamedplus"

vim.keymap.set("n", "q", "<cmd>qa!<cr>")

local baleia = require("baleia").setup()

local function strip_osc(line)
  -- OSC sequences (ESC ] ... BEL or ESC ] ... ST)
  line = line:gsub("\027%][^\007\027]*\007", "")
  line = line:gsub("\027%][^\027]*\027\\", "")
  return line
end

vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
    for i, line in ipairs(lines) do
      lines[i] = strip_osc(line)
    end
    vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
    baleia.once(vim.api.nvim_get_current_buf())
    vim.cmd("normal G")
    vim.bo.buftype = "nofile"
    vim.schedule(function()
      vim.bo.modifiable = false
    end)
  end,
})
