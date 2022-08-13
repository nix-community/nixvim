{ lib, pkgs, ... }@attrs:
let
  helpers = import ../helpers.nix { lib = lib; };
in with helpers; with lib;
mkPlugin attrs {
  name = "focus";
  description = "Enable focus.vim";
  extraPlugins = [ pkgs.extraPlugins.focus-nvim ];

  options = { };
}
