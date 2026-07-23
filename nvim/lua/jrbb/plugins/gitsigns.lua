local git_diff_origin_tab = nil
local git_diff_tab = nil

local function disable_nvim_tree()
  if type(_G.DisableNvimTree) == "function" then
    _G.DisableNvimTree()
  else
    pcall(vim.cmd, "NvimTreeClose")
  end
end

local function is_gitsigns_revision_buffer(bufnr)
  return vim.api.nvim_buf_get_name(bufnr):match("^gitsigns://") ~= nil
end

local function tab_has_gitsigns_revision(tab)
  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(tab)) do
    local bufnr = vim.api.nvim_win_get_buf(win)
    if is_gitsigns_revision_buffer(bufnr) then
      return true
    end
  end

  return false
end

local function close_diff()
  if git_diff_tab and vim.api.nvim_tabpage_is_valid(git_diff_tab) then
    vim.api.nvim_set_current_tabpage(git_diff_tab)
    pcall(vim.cmd, "tabclose")
  elseif tab_has_gitsigns_revision(vim.api.nvim_get_current_tabpage()) then
    pcall(vim.cmd, "tabclose")
  end

  if git_diff_origin_tab and vim.api.nvim_tabpage_is_valid(git_diff_origin_tab) then
    vim.api.nvim_set_current_tabpage(git_diff_origin_tab)
  end

  git_diff_origin_tab = nil
  git_diff_tab = nil
end

local function open_diff()
  git_diff_origin_tab = vim.api.nvim_get_current_tabpage()
  vim.cmd("tab split")
  git_diff_tab = vim.api.nvim_get_current_tabpage()
  disable_nvim_tree()
  require("gitsigns").diffthis("@")
end

return {
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      signs = {
        add          = { text = "│" },
        change       = { text = "│" },
        delete       = { text = "_" },
        topdelete    = { text = "‾" },
        changedelete = { text = "~" },
        untracked    = { text = "┆" },
      },
      signs_staged_enable = true,
      signcolumn = true,
    },
    keys = {
      {
        "<leader>hs",
        function()
          require("gitsigns").stage_hunk()
        end,
        desc = "Git stage hunk",
      },
      {
        "<leader>hs",
        function()
          local first = vim.fn.line("v")
          local last = vim.fn.line(".")
          if first > last then
            first, last = last, first
          end
          require("gitsigns").stage_hunk({ first, last })
        end,
        mode = "v",
        desc = "Git stage selection",
      },
      {
        "<leader>hp",
        function()
          require("gitsigns").preview_hunk()
        end,
        desc = "Git preview hunk",
      },
      {
        "<leader>hu",
        function()
          require("gitsigns").undo_stage_hunk()
        end,
        desc = "Git undo stage hunk",
      },
      {
        "<leader>hb",
        function()
          require("gitsigns").blame_line({ full = true })
        end,
        desc = "Git blame line",
      },
      {
        "<leader>hd",
        open_diff,
        desc = "Git diff against HEAD",
      },
      {
        "<leader>hD",
        close_diff,
        desc = "Git close diff",
      },
      {
        "<leader>hS",
        function()
          require("gitsigns").stage_buffer()
        end,
        desc = "Git stage buffer",
      },
    },
  },
}
