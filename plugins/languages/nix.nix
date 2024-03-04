{
  config,
  lib,
  helpers,
  pkgs,
  ...
}:
helpers.vim-plugin.mkVimPlugin config {
  name = "nix";
  originalName = "vim-nix";
  defaultPackage = pkgs.vimPlugins.vim-nix;

  maintainers = [lib.maintainers.GaetanLepage];

  # Possibly add option to disable Treesitter highlighting if this is installed
  options = {};
}
