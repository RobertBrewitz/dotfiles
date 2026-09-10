return {
  "nvim-treesitter/nvim-treesitter",
  run = ":TSUpdate",
  config = function()
    vim.filetype.add({ extension = { wgsl = "wgsl", wesl = "wesl" } })
    vim.treesitter.language.register("wgsl", "wesl")
    vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup("WgslTreesitter", { clear = true }),
      pattern = { "wgsl", "wesl" },
      callback = function(event)
        vim.treesitter.start(event.buf, "wgsl")
      end,
    })
    require("nvim-treesitter").setup({
      indent = {
        enable = false,
      },
      ensure_installed = {
        "typescript",
        "javascript",
        "tsx",
        "rust",
        "markdown",
        "markdown_inline",
        "lua",
        "wgsl",
      },
      sync_install = false,
      auto_install = true,
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
      },
    })
  end,
}
