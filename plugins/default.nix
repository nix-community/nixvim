{
  imports = [
    ./bufferlines/bufferline.nix

    ./colorschemes/gruvbox.nix
    ./colorschemes/onedark.nix
    ./colorschemes/one.nix
    ./colorschemes/base16.nix
    ./colorschemes/tokyonight.nix

    ./pluginmanagers/packer.nix

    ./statuslines/lightline.nix
    ./statuslines/airline.nix
    ./statuslines/lualine.nix

    ./git/gitgutter.nix
    ./git/fugitive.nix

    ./utils/undotree.nix
    ./utils/commentary.nix
    ./utils/comment-nvim.nix
    ./utils/floaterm.nix
    ./utils/startify.nix
    ./utils/goyo.nix
    ./utils/endwise.nix
    ./utils/easyescape.nix
    ./utils/telescope.nix
    ./utils/nvim-autopairs.nix
    ./utils/barbar.nix

    ./languages/treesitter.nix
    ./languages/nix.nix
    ./languages/zig.nix
    ./languages/ledger.nix

    ./nvim-lsp
    ./nvim-lsp/lspsaga.nix
  ];
}
