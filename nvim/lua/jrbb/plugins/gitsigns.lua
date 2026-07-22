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
        function()
          require("gitsigns").diffthis()
        end,
        desc = "Git diff this",
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
