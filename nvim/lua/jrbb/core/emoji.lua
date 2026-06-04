local M = {}

local ns = vim.api.nvim_create_namespace("jrbb_emoji_shortcodes")
local group = vim.api.nvim_create_augroup("JrbbEmojiShortcodes", { clear = true })

local enabled_extensions = {
  md = true,
  txt = true,
}

function M.enabled(bufnr)
  bufnr = bufnr and bufnr ~= 0 and bufnr or vim.api.nvim_get_current_buf()

  if not vim.api.nvim_buf_is_valid(bufnr) or not vim.api.nvim_buf_is_loaded(bufnr) then
    return false
  end

  if vim.api.nvim_get_option_value("buftype", { buf = bufnr }) ~= "" then
    return false
  end

  local ext = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(bufnr), ":e"):lower()
  return enabled_extensions[ext] == true
end

local function emoji_for(name)
  -- Force emoji presentation for recycle; vim-emoji returns the text variant.
  if name == "recycle" then
    return "♻️"
  end

  local ok, emoji = pcall(vim.fn["emoji#for"], name, "", 0)
  if ok and emoji ~= "" then
    return emoji
  end
end

function M.render(bufnr)
  bufnr = bufnr and bufnr ~= 0 and bufnr or vim.api.nvim_get_current_buf()
  if not vim.api.nvim_buf_is_valid(bufnr) then
    return
  end

  vim.api.nvim_buf_clear_namespace(bufnr, ns, 0, -1)
  if not M.enabled(bufnr) then
    return
  end

  for _, win in ipairs(vim.fn.win_findbuf(bufnr)) do
    vim.api.nvim_set_option_value("conceallevel", 2, { win = win })
    vim.api.nvim_set_option_value("concealcursor", "nvic", { win = win })
  end

  for lnum, line in ipairs(vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)) do
    local init = 1
    while true do
      local start_col, end_col, name = line:find(":([%w_+%-]+):", init)
      if not start_col then
        break
      end

      local emoji = emoji_for(name:lower())
      if emoji then
        vim.api.nvim_buf_set_extmark(bufnr, ns, lnum - 1, start_col - 1, {
          end_col = end_col,
          conceal = emoji,
        })
      end

      init = end_col + 1
    end
  end
end

function M.setup()
  vim.api.nvim_clear_autocmds({ group = group })
  vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter", "TextChanged", "TextChangedI" }, {
    group = group,
    callback = function(args)
      M.render(args.buf)
    end,
  })

  M.render(0)
end

return M
