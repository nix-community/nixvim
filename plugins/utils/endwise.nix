{ lib, pkgs, ... }@attrs:
let
  helpers = import ../helpers.nix { lib = lib; };
in with helpers; with lib;
mkPlugin attrs {
  name = "endwise";
  description = "Enable vim-endwise";
  extraPlugins = [ pkgs.vimPlugins.vim-endwise ];

  # Yes it's really not configurable
  options = {};
}
