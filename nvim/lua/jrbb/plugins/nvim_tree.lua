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

vim.api.nvim_create_autocmd({ "BufEnter" }, {
  callback = function()
    if vim.fn.argc() == 0 then
      local ft = vim.api.nvim_buf_get_option(0, "filetype")

      if ft == "NvimTree" or ft == "screenkey" or ft == "notify" then
        return
      end

      vim.cmd('NvimTreeFindFile')
      vim.cmd('wincmd p')
    end
  end,
})

-- Opens NvimTree and switches between the active window and NvimTree
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
    vim.cmd('NvimTreeOpen')
  else
    if vim.api.nvim_get_current_win() == nvim_tree then
      vim.cmd('wincmd p')
    else
      vim.api.nvim_set_current_win(nvim_tree)
    end
  end
end

-- I want nvim-tree to act like a file explorer, so I want to close if the "working file"
-- is closed and nvim-tree is the only window open.
vim.api.nvim_create_autocmd("BufEnter", {
  callback = function()
    vim.defer_fn(function()
      local wins = vim.api.nvim_tabpage_list_wins(0)
      local accounted_windows = 0;

      for _, win in ipairs(wins) do
        local buf = vim.api.nvim_win_get_buf(win)
        local ft = vim.api.nvim_buf_get_option(buf, "filetype")

        if ft == "NvimTree" then
          accounted_windows = accounted_windows + 1
        end

        if ft == "screenkey" then
          accounted_windows = accounted_windows + 1
        end

        if ft == "notify" then
          accounted_windows = accounted_windows + 1
        end
      end

      if accounted_windows == #wins then
        vim.cmd("quit")
      end
    end, 50)
  end,
})

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
          adaptive_size = false,
          width = 30,
          side = "left",
        },
        filesystem_watchers = {
          enable = true,
          debounce_delay = 50,
          ignore_dirs = {
            ".git",
            "node_modules",
            "build",
            "target",
          },
        },
        renderer = {
          group_empty = true,
        },
        filters = {
          dotfiles = false,
        },
        on_attach = function(bufnr)
          local api = require "nvim-tree.api"

          local function opts(desc)
            return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
          end

          -- custom mappings
          vim.keymap.set("n", "<C-t>",          api.node.open.tab,                  opts("Open: New Tab"))
          vim.keymap.set("n", "h",              api.node.navigate.parent_close,     opts("Close Directory"))
          vim.keymap.set("n", "<cr>",           api.node.open.edit,                 opts("Open"))
          vim.keymap.set("n", "l",              api.node.open.preview,              opts("Open Preview"))
          vim.keymap.set("n", "%",              api.fs.create,                      opts("Create File Or Directory"))
          vim.keymap.set("n", "d",              api.fs.create,                      opts("Create File Or Directory"))
          vim.keymap.set("n", "y",              api.fs.copy.node,                   opts("Copy"))
          vim.keymap.set("n", "D",              api.fs.remove,                      opts("Delete"))
          vim.keymap.set("n", "r",              api.fs.rename_basename,             opts("Rename: Basename"))
          vim.keymap.set("n", "p",              api.fs.paste,                       opts("Paste"))
          vim.keymap.set("n", "r",              api.fs.rename,                      opts("Rename"))
          vim.keymap.set("n", "/",              api.tree.search_node,               opts("Search"))
          vim.keymap.set("n", "x",              api.fs.cut,                         opts("Cut"))
          -- vim.keymap.set("n", "<C-e>",          api.node.open.replace_tree_buffer,  opts("Open: In Place"))
          -- vim.keymap.set("n", "<C-k>",          api.node.show_info_popup,           opts("Info"))
          -- vim.keymap.set("n", "<C-r>",          api.fs.rename_sub,                  opts("Rename: Omit Filename"))
          -- vim.keymap.set("n", "<C-v>",          api.node.open.vertical,             opts("Open: Vertical Split"))
          -- vim.keymap.set("n", "<C-x>",          api.node.open.horizontal,           opts("Open: Horizontal Split"))
          -- vim.keymap.set("n", ">",              api.node.navigate.sibling.next,     opts("Next Sibling"))
          -- vim.keymap.set("n", "<",              api.node.navigate.sibling.prev,     opts("Previous Sibling"))
          -- vim.keymap.set("n", ".",              api.node.run.cmd,                   opts("Run Command"))
          -- vim.keymap.set("n", "-",              api.tree.change_root_to_parent,     opts("Up"))
          -- vim.keymap.set("n", "bd",             api.marks.bulk.delete,              opts("Delete Bookmarked"))
          -- vim.keymap.set("n", "bt",             api.marks.bulk.trash,               opts("Trash Bookmarked"))
          -- vim.keymap.set("n", "bmv",            api.marks.bulk.move,                opts("Move Bookmarked"))
          -- vim.keymap.set("n", "B",              api.tree.toggle_no_buffer_filter,   opts("Toggle Filter: No Buffer"))
          -- vim.keymap.set("n", "C",              api.tree.toggle_git_clean_filter,   opts("Toggle Filter: Git Clean"))
          -- vim.keymap.set("n", "[c",             api.node.navigate.git.prev,         opts("Prev Git"))
          -- vim.keymap.set("n", "]c",             api.node.navigate.git.next,         opts("Next Git"))
          -- vim.keymap.set("n", "D",              api.fs.trash,                       opts("Trash"))
          -- vim.keymap.set("n", "E",              api.tree.expand_all,                opts("Expand All"))
          -- vim.keymap.set("n", "]e",             api.node.navigate.diagnostics.next, opts("Next Diagnostic"))
          -- vim.keymap.set("n", "[e",             api.node.navigate.diagnostics.prev, opts("Prev Diagnostic"))
          -- vim.keymap.set("n", "F",              api.live_filter.clear,              opts("Live Filter: Clear"))
          -- vim.keymap.set("n", "f",              api.live_filter.start,              opts("Live Filter: Start"))
          -- vim.keymap.set("n", "g?",             api.tree.toggle_help,               opts("Help"))
          -- vim.keymap.set("n", "gy",             api.fs.copy.absolute_path,          opts("Copy Absolute Path"))
          -- vim.keymap.set("n", "ge",             api.fs.copy.basename,               opts("Copy Basename"))
          -- vim.keymap.set("n", "H",              api.tree.toggle_hidden_filter,      opts("Toggle Filter: Dotfiles"))
          -- vim.keymap.set("n", "I",              api.tree.toggle_gitignore_filter,   opts("Toggle Filter: Git Ignore"))
          -- vim.keymap.set("n", "J",              api.node.navigate.sibling.last,     opts("Last Sibling"))
          -- vim.keymap.set("n", "K",              api.node.navigate.sibling.first,    opts("First Sibling"))
          -- vim.keymap.set("n", "L",              api.node.open.toggle_group_empty,   opts("Toggle Group Empty"))
          -- vim.keymap.set("n", "M",              api.tree.toggle_no_bookmark_filter, opts("Toggle Filter: No Bookmark"))
          -- vim.keymap.set("n", "m",              api.marks.toggle,                   opts("Toggle Bookmark"))
          -- vim.keymap.set("n", "o",              api.node.open.edit,                 opts("Open"))
          -- vim.keymap.set("n", "O",              api.node.open.no_window_picker,     opts("Open: No Window Picker"))
          -- vim.keymap.set("n", "P",              api.node.navigate.parent,           opts("Parent Directory"))
          -- vim.keymap.set("n", "q",              api.tree.close,                     opts("Close"))
          -- vim.keymap.set("n", "R",              api.tree.reload,                    opts("Refresh"))
          -- vim.keymap.set("n", "s",              api.node.run.system,                opts("Run System"))
          -- vim.keymap.set("n", "u",              api.fs.rename_full,                 opts("Rename: Full Path"))
          -- vim.keymap.set("n", "U",              api.tree.toggle_custom_filter,      opts("Toggle Filter: Hidden"))
          -- vim.keymap.set("n", "W",              api.tree.collapse_all,              opts("Collapse"))
          -- vim.keymap.set("n", "y",              api.fs.copy.filename,               opts("Copy Name"))
          -- vim.keymap.set("n", "Y",              api.fs.copy.relative_path,          opts("Copy Relative Path"))
          -- vim.keymap.set("n", "<2-LeftMouse>",  api.node.open.edit,                 opts("Open"))
          -- vim.keymap.set("n", "<2-RightMouse>", api.tree.change_root_to_node,       opts("CD"))
        end
      })
    end,
  },
}
