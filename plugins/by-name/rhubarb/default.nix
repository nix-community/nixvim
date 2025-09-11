{ lib, ... }:
lib.nixvim.plugins.mkVimPlugin {
  name = "rhubarb";
  packPathName = "vim-rhubarb";
  package = "vim-rhubarb";
  description = "Rhubarb is a GitHub extension for fugitive.vim.";

  maintainers = [ lib.maintainers.santoshxshrestha ];

  dependencies = [
    "git"
    "fugitive"
  ];
}
