return {
  "nvim-treesitter/nvim-treesitter",
  run = ":TSUpdate",
  config = function()
    vim.filetype.add({ extension = { wgsl = "wgsl" } })

    require("nvim-treesitter.configs").setup({
      ensure_installed = { "typescript", "javascript", "tsx", "rust", "markdown", "lua", "wgsl" },
      sync_install = false,
      auto_install = true,
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
      },
    })
  end,
}
