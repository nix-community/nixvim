{
  imports = [
    ./colorschemes/gruvbox.nix
    ./colorschemes/base16.nix

    ./statuslines/lightline.nix
    ./statuslines/airline.nix

    ./git/gitgutter.nix

    ./languages/treesitter.nix

    ./nvim-lsp
  ];
}
