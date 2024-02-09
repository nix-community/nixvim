{
  config,
  helpers,
  pkgs,
  ...
}:
helpers.vim-plugin.mkVimPlugin config {
  name = "nix";
  description = "vim-nix";
  package = pkgs.vimPlugins.vim-nix;

  # Possibly add option to disable Treesitter highlighting if this is installed
  options = {};
}
