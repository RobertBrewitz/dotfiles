return {
  {
    "hrsh7th/vim-vsnip",
  },
  {
    "hrsh7th/cmp-nvim-lsp",
  },
  {
    "hrsh7th/cmp-buffer",
  },
  {
    "hrsh7th/cmp-path",
  },
  {
    "hrsh7th/nvim-cmp",
    config = function()
      local cmp = require("cmp")
      local winhighlight = {
        winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder,CursorLine:PmenuSel",
      }
      cmp.setup({
        formatting = {
          format = function(_, vim_item)
            vim_item.menu = nil
            return vim_item
          end,
        },
        snippet = {
          expand = function(args)
            vim.fn["vsnip#anonymous"](args.body)
          end,
        },
        mapping = {
          ["<C-p>"] = cmp.mapping.scroll_docs(-4),
          ["<C-n>"] = cmp.mapping.scroll_docs(4),
          ["<C-k>"] = cmp.mapping.select_prev_item(),
          ["<C-j>"] = cmp.mapping.select_next_item(),
          ["<C-q>"] = cmp.mapping.abort(),
          ["<C-y>"] = cmp.mapping.confirm({ select = true }),
          ["<C-Space>"] = cmp.mapping.complete(),
        },
        sources = {
          { name = "nvim_lsp" },
          { name = "path" },
          { name = "buffer" },
          { name = "crates" },
        },
        window = {
          completion = cmp.config.window.bordered(winhighlight),
          documentation = cmp.config.window.bordered(winhighlight),
        },
      })
    end,
  },
}
