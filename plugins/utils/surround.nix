{ lib, pkgs, config, ... }@attrs:
let
  helpers = import ../helpers.nix { inherit lib config; };
in with helpers; with lib;
mkPlugin attrs {
  name = "surround";
  description = "Enable surround.vim";
  extraPlugins = [ pkgs.vimPlugins.surround ];

  options = {};
}
