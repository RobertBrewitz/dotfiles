return require("packer").startup(function()
  use("wbthomason/packer.nvim")

  -- Formatting
  -- use("sbdchd/neoformat")

  -- tpope
  use("tpope/vim-surround")
  use("tpope/vim-repeat")

  -- Language servers
  use("neovim/nvim-lspconfig")
  use("hrsh7th/cmp-nvim-lsp")
  use("hrsh7th/cmp-buffer")
  use("hrsh7th/cmp-path")
  use("hrsh7th/cmp-cmdline")
  use("hrsh7th/nvim-cmp")

  -- Snippets
  -- use("hrsh7th/cmp-vsnip")
  -- use("hrsh7th/vim-vsnip")

  -- Rust Analyzer
  use("simrat39/rust-tools.nvim")

  -- Fuzzy finder
  use("nvim-lua/plenary.nvim")
  use("nvim-lua/popup.nvim")
  -- use("nvim-telescope/telescope.nvim")
  use("junegunn/fzf")
  use("junegunn/fzf.vim")

  -- Git
  use("ThePrimeagen/git-worktree.nvim")

  -- Colorscheme
  use("bluz71/vim-moonfly-colors")
end)
