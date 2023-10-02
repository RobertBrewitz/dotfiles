local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()

return require("packer").startup(function(use)
  use("wbthomason/packer.nvim")

  -- tpope
  use("tpope/vim-surround")
  use("tpope/vim-repeat")

  -- Snippets
  use("hrsh7th/vim-vsnip")

  -- Language servers
  use("neovim/nvim-lspconfig")
  use("hrsh7th/cmp-nvim-lsp")
  use("hrsh7th/cmp-buffer")
  use("hrsh7th/cmp-path")
  use("hrsh7th/cmp-cmdline")
  use("hrsh7th/nvim-cmp")
  use("github/copilot.vim")

  -- Fuzzy finder
  use("junegunn/fzf")
  use("junegunn/fzf.vim")

  -- Formatting
  use("sbdchd/neoformat")
  use("editorconfig/editorconfig-vim")

  -- Colorscheme
  use({ "bluz71/vim-moonfly-colors" })
  use({ "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" })

  if packer_bootstrap then
    require('packer').sync()
  end
end)
