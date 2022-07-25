vim.g.jrbb_colorscheme = "moonfly"

function ApplyColorscheme()
  --vim.opt.background = "dark"
  vim.cmd("colorscheme " .. vim.g.jrbb_colorscheme)

  --local hl = function(key, val)
  --  vim.api.nvim_set_hl(0, key, val)
  --end

  --hl("ColorColumn", {
  --  bg = "#111111"
  --})

  --hl("Folded", {
  --  bg = "#000000",
  --  fg = "#555555"
  --})

  --hl("NonText", {
  --  bg = "#000000",
  --  fg = "#555555"
  --})

  --hl("Pmenu", {
  --  bg = "#111111"
  --})

  --hl("PmenuSbar", {
  --  bg = "#111111"
  --})

  --hl("PmenuSel", {
  --  bg = "#EEEEEE"
  --})

  --hl("PmenuThumb", {
  --  bg = "#111111"
  --})

  --hl("SpecialKey", {
  --  bg = "#000000",
  --  fg = "#555555"
  --})

  --hl("SignColumn", {
  --  bg = "#000000"
  --})
end

ApplyColorscheme()
