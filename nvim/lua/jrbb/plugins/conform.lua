return {
  'stevearc/conform.nvim',
  opts = {},
  config = function()
    require('conform').setup {
      formatters_by_ft = {
        lua = { 'stylua' },
        rust = { 'rustfmt', },
        javascript = { 'prettier' },
        typescript = { 'prettier' },
        typescriptreact = { 'prettier' },
        json = { 'prettier' },
        markdown = { 'prettier' },
      },
    }
  end,

  init = function()
    vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
    vim.api.nvim_create_autocmd("BufWritePre", {
      pattern = "*",
      callback = function(args)
        require("conform").format({ bufnr = args.buf })
      end,
    })
  end
}
-- return {
--   "sbdchd/neoformat",
--   config = function()
--     local autocmd = vim.api.nvim_create_autocmd
--
--     autocmd({ "BufWritePre" }, {
--       command = "Neoformat",
--       pattern = "*.rs",
--     })
--
--     autocmd({ "BufWritePre" }, {
--       command = "Neoformat",
--       pattern = "*.{t,j}s",
--     })
--
--     autocmd({ "BufWritePre" }, {
--       command = "Neoformat",
--       pattern = "*.{t,j}sx",
--     })
--
--     autocmd({ "BufWritePre" }, {
--       command = "Neoformat",
--       pattern = "*.json",
--     })
--
--     autocmd({ "BufWritePre" }, {
--       command = "Neoformat",
--       pattern = "*.md",
--     })
--
--     vim.g.neoformat_try_node_exe = 1
--     vim.g.neoformat_enabled_javascript = { "prettier" }
--     vim.g.neoformat_run_all_formatters = 1
--   end,
-- }
