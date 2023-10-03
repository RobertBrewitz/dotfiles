return {
  "nvim-treesitter/nvim-treesitter",
  run = ":TSUpdate",
  config = function()
    require'nvim-treesitter.configs'.setup {
      ensure_installed = { "typescript", "javascript", "tsx", "rust", "markdown", "lua" },
      sync_install = false,
      auto_install = true,
      highlight = {
          enable = true,
          additional_vim_regex_highlighting = false,
      },
    }
  end,
}
