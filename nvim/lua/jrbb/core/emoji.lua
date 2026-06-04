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
  if vim.api.nvim_buf_is_valid(bufnr) then
    vim.api.nvim_buf_clear_namespace(bufnr, ns, 0, -1)
  end
end

function M.completing(ctx)
  if ctx and ctx.mode ~= "default" then
    return false
  end

  local bufnr = ctx and ctx.bufnr or 0
  if not M.enabled(bufnr) then
    return false
  end

  local line = ctx and ctx.line or vim.api.nvim_get_current_line()
  local col = ctx and ctx.cursor and ctx.cursor[2] or (vim.fn.col(".") - 1)
  local before_cursor = line:sub(1, col)
  return before_cursor:find(":[%w_+%-]*$") ~= nil
end

function M.complete(findstart, base)
  if findstart == 1 then
    local before_cursor = vim.api.nvim_get_current_line():sub(1, vim.fn.col(".") - 1)
    local start_col = before_cursor:find(":[%w_+%-]*$")
    return start_col and (start_col - 1) or -2
  end

  local query = base:sub(1, 1) == ":" and base or (":" .. base)
  return vim.fn["emoji#complete"](0, query)
end

function M.convert(bufnr)
  bufnr = bufnr and bufnr ~= 0 and bufnr or vim.api.nvim_get_current_buf()
  if not vim.api.nvim_buf_is_valid(bufnr) then
    return
  end

  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  local changed = false

  for i, line in ipairs(lines) do
    local converted = line:gsub(":([%w_+%-]+):", function(name)
      return emoji_for(name:lower()) or (":" .. name .. ":")
    end)

    if converted ~= line then
      lines[i] = converted
      changed = true
    end
  end

  if changed then
    vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
    M.render(bufnr)
  end
end

function M.setup()
  vim.api.nvim_clear_autocmds({ group = group })
  vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
    group = group,
    callback = function(args)
      M.render(args.buf)
    end,
  })

  vim.api.nvim_create_user_command("LigatureToEmoji", function()
    M.convert(0)
  end, {
    desc = "Replace emoji shortcodes like :smile: with actual emoji characters",
  })

  M.render(0)
end

return M
