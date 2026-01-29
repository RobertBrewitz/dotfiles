local Remap = require("jrbb.keymap")
local nnoremap = Remap.nnoremap

vim.opt.secure = true
vim.opt.fileformat = "unix"
vim.opt.exrc = true
vim.opt.errorbells = false
vim.opt.fsync = true
vim.opt.directory = ".,~/.nvim/tmp,~/tmp,/var/tmp,/tmp"

-- undo/backup/swap
vim.opt.writebackup = false
vim.opt.backup = false
vim.opt.swapfile = false
vim.opt.undofile = true
vim.opt.undolevels = 1000
vim.opt.undoreload = 10000
vim.opt.undodir = os.getenv("HOME") .. "/.config/nvim/tmp/undo"

-- search
vim.opt.hlsearch = false
vim.opt.incsearch = true

-- completion
vim.opt.completeopt = "menuone,noinsert,noselect"

-- formatting
-- vim.opt.conceallevel = 2
vim.opt.smartindent = true
-- vim.opt.expandtab = true -- editorconfig indent_style
-- vim.opt.tabstop = 2 -- editorconfig tab_width
-- vim.opt.softtabstop = 2 -- editorconfig indent_size
-- vim.opt.shiftwidth = 2 -- editorconfig indent_size

-- navigation
vim.opt.startofline = false

-- presentation
vim.opt.guicursor = ""
vim.opt.termguicolors = true
vim.opt.list = true
vim.opt.listchars = "tab:▸ ,eol:¬,trail:·"
vim.opt.number = true
vim.opt.relativenumber = false
vim.opt.showtabline = 2
vim.opt.laststatus = 0

function _G.MyTabline()
  local s = ''
  for i = 1, vim.fn.tabpagenr('$') do
    local buflist = vim.fn.tabpagebuflist(i)
    local winnr = vim.fn.tabpagewinnr(i)
    local bufnr = buflist[winnr]
    local ft = vim.api.nvim_get_option_value("filetype", { buf = bufnr })

    -- If current window is NvimTree, find a real file buffer in this tab
    if ft == "NvimTree" then
      bufnr = nil
      for _, b in ipairs(buflist) do
        local bft = vim.api.nvim_get_option_value("filetype", { buf = b })
        if bft ~= "NvimTree" and bft ~= "notify" and bft ~= "screenkey" then
          bufnr = b
          break
        end
      end
    end

    local label
    if bufnr then
      local bufname = vim.fn.bufname(bufnr)
      local filename = vim.fn.fnamemodify(bufname, ':t')
      local parent = vim.fn.fnamemodify(bufname, ':p:h:t')
      local modified = vim.api.nvim_get_option_value("modified", { buf = bufnr })
      label = parent .. '/' .. filename
      if filename == '' then
        label = '[No Name]'
      end
      if modified then
        label = label .. ' ●'
      end
    else
      label = '[Explorer]'
    end

    if i == vim.fn.tabpagenr() then
      s = s .. '%#TabLineSel#'
    else
      s = s .. '%#TabLine#'
    end

    s = s .. ' ' .. label .. ' '
  end

  s = s .. '%#TabLineFill#'
  return s
end

vim.opt.tabline = '%!v:lua.MyTabline()'
vim.opt.signcolumn = "yes"
vim.opt.cmdheight = 1
vim.opt.shortmess:append("c")
vim.opt.scrolloff = 5
vim.opt.sidescrolloff = 5
vim.opt.colorcolumn = "100"
vim.opt.wrap = true

-- timeouts
vim.opt.showcmd = true
vim.opt.timeout = false
vim.opt.ttimeout = true
vim.opt.timeoutlen = 1000
vim.opt.ttimeoutlen = 0
vim.opt.updatetime = 300

-- leader and prevent cursor movement when used
nnoremap("<SPACE>", "<Nop>")
vim.g.mapleader = " "

-- mouse
vim.opt.mouse = ""

-- border
vim.o.winborder = "rounded"
