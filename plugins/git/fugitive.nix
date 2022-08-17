{ lib, pkgs, config, ... }@attrs:
let
  helpers = import ../helpers.nix { inherit lib config; };
in with helpers; with lib;
mkPlugin attrs {
  name = "fugitive";
  description = "Enable vim-fugitive";
  extraPlugins = [ pkgs.vimPlugins.vim-fugitive ];

  # In typical tpope fashin, this plugin has no config options
  options = {};
}
