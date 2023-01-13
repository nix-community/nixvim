{ config, lib, pkgs, ... }@attrs:
let
  helpers = import ../helpers.nix { inherit config lib; };
in with helpers; with lib;
mkPlugin attrs {
  name = "surround";
  description = "Enable surround.vim";
  extraPlugins = [ pkgs.vimPlugins.surround ];

  options = {};
}
