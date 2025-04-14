local Remap = require("jrbb.keymap")
local nnoremap = Remap.nnoremap

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    if vim.fn.argc() == 0 then
      ToggleNvimTree()
      vim.cmd('wincmd p')
    end
  end,
})

vim.api.nvim_create_autocmd({ "BufReadPost" }, {
  callback = function()
    if vim.fn.argc() == 0 then
      local ft = vim.api.nvim_buf_get_option(0, "filetype")

      if ft == "NvimTree" then
        return
      end

      vim.cmd('NvimTreeFindFile')
      vim.cmd('wincmd p')
    end
  end,
})

function ToggleNvimTree()
  local nvim_tree = nil
  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    local buf = vim.api.nvim_win_get_buf(win)
    local ft = vim.api.nvim_buf_get_option(buf, 'filetype')
    if ft == 'NvimTree' then
      nvim_tree = win
      break
    end
  end

  if not nvim_tree then
    -- netrw is not open: open it on the left.
    vim.cmd('NvimTreeOpen')
  else
    if vim.api.nvim_get_current_win() == nvim_tree then
      -- If currently in netrw, jump back to the last used window.
      vim.cmd('wincmd p')
    else
      -- Switch focus to the netrw window.
      vim.api.nvim_set_current_win(nvim_tree)
    end
  end
end

nnoremap("<leader>e", ToggleNvimTree, { desc = "ToggleNvimTree" })

return {
  {
    "nvim-tree/nvim-tree.lua",
    version = "*",
    lazy = false,
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      require("nvim-tree").setup({
        sort_by = "case_sensitive",
        view = {
          adaptive_size = true,
          width = 30,
          side = "left",
        },
        renderer = {
          group_empty = true,
        },
        filters = {
          dotfiles = false,
        },
      })
    end,
  },
}
