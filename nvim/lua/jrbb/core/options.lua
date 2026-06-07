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
local undodir = vim.fn.stdpath("state") .. "/undo"
vim.fn.mkdir(undodir, "p", 0700)
vim.opt.undodir = undodir

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
vim.opt.laststatus = 3

local function tabline_escape(text)
  return text:gsub("%%", "%%%%")
end

local function tabline_width(text)
  return vim.fn.strdisplaywidth(text)
end

local function tabline_truncate(text, max_width)
  if tabline_width(text) <= max_width then
    return text
  end

  if max_width <= 1 then
    return "…"
  end

  local ellipsis = "…"
  local text_width = 0
  local truncated = ""
  local keep_width = max_width - tabline_width(ellipsis)

  for i = 0, vim.fn.strchars(text) - 1 do
    local char = vim.fn.strcharpart(text, i, 1)
    local char_width = tabline_width(char)
    if text_width + char_width > keep_width then
      break
    end
    truncated = truncated .. char
    text_width = text_width + char_width
  end

  return truncated .. ellipsis
end

local function tabline_label(bufnr)
  if bufnr then
    local bufname = vim.fn.bufname(bufnr)
    local filename = vim.fn.fnamemodify(bufname, ":t")
    local parent = vim.fn.fnamemodify(bufname, ":p:h:t")
    local modified = vim.api.nvim_get_option_value("modified", { buf = bufnr })
    local label = parent .. "/" .. filename

    if filename == "" then
      label = "[No Name]"
    end
    if modified then
      label = label .. " ●"
    end

    return label
  end

  return "[Explorer]"
end

local function tabline_tab_bufnr(tabnr)
  local buflist = vim.fn.tabpagebuflist(tabnr)
  local winnr = vim.fn.tabpagewinnr(tabnr)
  local bufnr = buflist[winnr]
  local ft = vim.api.nvim_get_option_value("filetype", { buf = bufnr })

  -- If current window is NvimTree, find a real file buffer in this tab
  if ft == "NvimTree" then
    for _, b in ipairs(buflist) do
      local bft = vim.api.nvim_get_option_value("filetype", { buf = b })
      if bft ~= "NvimTree" and bft ~= "notify" and bft ~= "screenkey" then
        return b
      end
    end

    return nil
  end

  return bufnr
end

function _G.MyTabline()
  local tab_count = vim.fn.tabpagenr("$")
  local current_tab = vim.fn.tabpagenr()
  local columns = math.max(vim.o.columns, 1)
  local hidden_left = " … "
  local hidden_right = " … "
  local hidden_left_width = tabline_width(hidden_left)
  local hidden_right_width = tabline_width(hidden_right)
  local tabs = {}

  for i = 1, tab_count do
    local text = " " .. tabline_label(tabline_tab_bufnr(i)) .. " "
    tabs[i] = {
      text = text,
      width = tabline_width(text),
    }
  end

  local function range_width(first, last)
    local width = 0
    if first > 1 then
      width = width + hidden_left_width
    end
    for i = first, last do
      width = width + tabs[i].width
    end
    if last < tab_count then
      width = width + hidden_right_width
    end
    return width
  end

  -- The active tab must always fit; if one tab label is too wide, shorten it.
  local active_overhead = (current_tab > 1 and hidden_left_width or 0)
    + (current_tab < tab_count and hidden_right_width or 0)
  local active_max_width = math.max(columns - active_overhead, 1)
  tabs[current_tab].text = tabline_truncate(tabs[current_tab].text, active_max_width)
  tabs[current_tab].width = tabline_width(tabs[current_tab].text)

  local first = current_tab
  local last = current_tab

  while first > 1 or last < tab_count do
    local can_add_left = first > 1 and range_width(first - 1, last) <= columns
    local can_add_right = last < tab_count and range_width(first, last + 1) <= columns

    if not can_add_left and not can_add_right then
      break
    end

    if can_add_left and (not can_add_right or (current_tab - first) <= (last - current_tab)) then
      first = first - 1
    else
      last = last + 1
    end
  end

  local s = ""
  if first > 1 then
    s = s .. "%#TabLine#" .. tabline_escape(hidden_left)
  end

  for i = first, last do
    if i == current_tab then
      s = s .. "%#TabLineSel#"
    else
      s = s .. "%#TabLine#"
    end
    s = s .. tabline_escape(tabs[i].text)
  end

  if last < tab_count then
    s = s .. "%#TabLine#" .. tabline_escape(hidden_right)
  end

  s = s .. "%#TabLineFill#"
  return s
end

vim.opt.tabline = '%!v:lua.MyTabline()'
vim.opt.signcolumn = "yes"
vim.opt.cmdheight = 1
vim.opt.shortmess:append("c")
vim.opt.scrolloff = 5
vim.opt.sidescrolloff = 5
vim.opt.colorcolumn = "80"
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
