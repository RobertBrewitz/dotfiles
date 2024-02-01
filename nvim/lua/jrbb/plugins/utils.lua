return {
  {
    "tpope/vim-surround",
  },
  {
    "tpope/vim-repeat",
  },
  {
    "editorconfig/editorconfig-vim",
  },
  {
    "sontungexpt/url-open",
    branch = "mini",
    event = "VeryLazy",
    cmd = "URLOpenUnderCursor",
    config = function()
      local lspconfig = require("lspconfig")
      local Remap = require("jrbb.keymap")
      local nnoremap = Remap.nnoremap

      vim.keymap.set("n", "go", "<esc>:URLOpenUnderCursor<cr>")

      local status_ok, url_open = pcall(require, "url-open")
      if not status_ok then
        return
      end
      url_open.setup ({})
    end,
  },
}
