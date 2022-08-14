{ lib, pkgs, ... }@attrs:
let
  helpers = import ../helpers.nix { lib = lib; };
in with helpers; with lib;
mkPlugin attrs {
  name = "asyncrun";
  description = "Enable asyncrun.vim";
  extraPlugins = [ pkgs.vimPlugins.asyncrun-vim ];
}
