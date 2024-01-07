return {
  {
    "hrsh7th/cmp-nvim-lsp",
  },
  {
    "hrsh7th/vim-vsnip"
  },
  {
    "hrsh7th/cmp-buffer",
  },
  {
    "hrsh7th/cmp-path",
  },
  --{
  --  "hrsh7th/cmp-cmdline",
  --},
  --{
  --  "hrsh7th/cmp-emoji",
  --},
  {
    "hrsh7th/nvim-cmp",
    config = function()
      local cmp = require("cmp")
      local winhighlight = {
        winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder,CursorLine:PmenuSel",
      }

      cmp.setup({
        formatting = {
          format = function(entry, vim_item)
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
          ['<C-p>'] = cmp.mapping.select_prev_item(),
          ['<C-n>'] = cmp.mapping.select_next_item(),
          ['<C-u>'] = cmp.mapping.scroll_docs(-4),
          ['<C-d>'] = cmp.mapping.scroll_docs(4),
          ['<C-y>'] = cmp.mapping.confirm({select = true}),
          ['<C-Space>'] = cmp.mapping.complete()
        },
        sources = {
          { name = 'nvim_lsp' },
          { name = 'path' },
          { name = 'buffer' },
          --{ name = 'cmdline' },
          --{ name = 'emoji' },
          { name = 'crates' },
        },
        window = {
          completion = cmp.config.window.bordered(winhighlight),
          documentation = cmp.config.window.bordered(winhighlight),
        },
      })
    end,
  },
}
