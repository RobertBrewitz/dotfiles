local cmp = require("cmp")
local Remap = require("jrbb.keymap")
local nnoremap = Remap.nnoremap

-- Disable inline messages
vim.diagnostic.config({virtual_text = false})

cmp.setup({
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
  },
})

local function config(_config)
  return vim.tbl_deep_extend("force", {
    capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities()),
  }, _config or {})
end

require("lspconfig").rust_analyzer.setup({
  cmd = { "rustup", "run", "stable", "rust-analyzer" },
});

-- npm i -g typescript typescript-language-server
require("lspconfig").tsserver.setup(config());

nnoremap("<leader>gd", function() vim.lsp.buf.definition() end)
nnoremap("<leader>d", function() vim.lsp.buf.hover() end)
nnoremap("<leader>gi", function() vim.lsp.buf.implementation() end)
nnoremap("<leader>gs", function() vim.lsp.buf.signature_help() end)
nnoremap("<leader>gy", function() vim.lsp.buf.type_definition() end)
nnoremap("<leader>gr", function() vim.lsp.buf.references() end)
nnoremap("<leader>rn", function() vim.lsp.buf.rename() end)
nnoremap("<leader>gg", function()
  vim.diagnostic.setqflist()
  vim.cmd("cclose")
  vim.cmd("cnext")
end)
nnoremap("<leader>gl", function() vim.diagnostic.setloclist() end)
nnoremap("<C-k>", function() vim.diagnostic.goto_next() end)
nnoremap("<C-j>", function() vim.diagnostic.goto_prev() end)
