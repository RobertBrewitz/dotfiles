local M = {}

local target_window = nil
local list_kind = "quickfix"

local function is_edit_window(win)
  if not win or not vim.api.nvim_win_is_valid(win) then
    return false
  end

  if vim.api.nvim_win_get_tabpage(win) ~= vim.api.nvim_get_current_tabpage() then
    return false
  end

  local config = vim.api.nvim_win_get_config(win)
  local bufnr = vim.api.nvim_win_get_buf(win)
  return config.relative == "" and vim.api.nvim_get_option_value("buftype", { buf = bufnr }) == ""
end

local function find_edit_window(preferred)
  if is_edit_window(preferred) then
    return preferred
  end

  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    if is_edit_window(win) then
      return win
    end
  end
end

local function window_list_kind(win)
  local info = vim.fn.getwininfo(win)[1]
  if not info or info.quickfix ~= 1 then
    return nil
  end

  return info.loclist == 1 and "location" or "quickfix"
end

local function location_list_target(win)
  local winnr = vim.fn.win_id2win(win)
  local ok, result = pcall(vim.fn.getloclist, winnr, { filewinid = 0 })
  if ok then
    return result.filewinid
  end
end

local function navigation_target(current)
  if is_edit_window(current) then
    return current
  end

  if window_list_kind(current) == "location" then
    local target = location_list_target(current)
    if is_edit_window(target) then
      return target
    end
  end

  if is_edit_window(target_window) then
    return target_window
  end
  local alternate = vim.fn.win_getid(vim.fn.winnr("#"))
  if is_edit_window(alternate) then
    return alternate
  end
  return find_edit_window()
end

function M.set_target(preferred, kind)
  target_window = find_edit_window(preferred)
  list_kind = kind or list_kind
  return target_window
end

function M.run(command)
  local current = vim.api.nvim_get_current_win()
  local current_kind = window_list_kind(current)
  if current_kind then
    list_kind = current_kind
  end

  local target = navigation_target(current)
  if not target then
    vim.notify("No existing editor window is available", vim.log.levels.WARN)
    return
  end

  target_window = target
  vim.api.nvim_set_current_win(target)
  local ok, err = pcall(vim.cmd, command)
  if not ok then
    vim.notify(err, vim.log.levels.ERROR)
  end
end

function M.open_current()
  local kind = window_list_kind(vim.api.nvim_get_current_win()) or list_kind
  list_kind = kind
  M.run(vim.fn.line(".") .. (kind == "location" and "ll" or "cc"))
end

function M.next()
  M.run(list_kind == "location" and "lnext" or "cnext")
end

function M.previous()
  M.run(list_kind == "location" and "lprev" or "cprev")
end

local group = vim.api.nvim_create_augroup("jrbb-quickfix-navigation", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
  group = group,
  pattern = "qf",
  callback = function(event)
    local opts = { buffer = event.buf, silent = true, desc = "Open list item in editor window" }
    vim.keymap.set("n", "<CR>", M.open_current, opts)
    vim.keymap.set("n", "<2-LeftMouse>", M.open_current, opts)
  end,
})

vim.api.nvim_create_autocmd("BufEnter", {
  group = group,
  callback = function()
    local current = vim.api.nvim_get_current_win()
    if is_edit_window(current) then
      target_window = current
      return
    end

    local kind = window_list_kind(current)
    if kind then
      list_kind = kind
      target_window = navigation_target(current)
    end
  end,
})

return M
