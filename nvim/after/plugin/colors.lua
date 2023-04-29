vim.g.jrbb_colorscheme = "moonfly"

function ApplyColorscheme()
  vim.cmd("colorscheme " .. vim.g.jrbb_colorscheme)
end

ApplyColorscheme()
