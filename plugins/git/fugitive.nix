{ config, lib, pkgs, ... }@attrs:
let
  helpers = import ../helpers.nix { inherit config lib; };
in with helpers; with lib;
mkPlugin attrs {
  name = "fugitive";
  description = "Enable vim-fugitive";
  extraPlugins = [ pkgs.vimPlugins.vim-fugitive ];
  extraPackages = [ pkgs.git ];

  # In typical tpope fashin, this plugin has no config options
  options = {};
}
