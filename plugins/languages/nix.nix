{
  config,
  helpers,
  pkgs,
  ...
}:
helpers.vim-plugin.mkVimPlugin config {
  name = "nix";
  originalName = "vim-nix";
  defaultPackage = pkgs.vimPlugins.vim-nix;

  # Possibly add option to disable Treesitter highlighting if this is installed
  options = {};
}
