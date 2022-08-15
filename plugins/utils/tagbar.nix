{ pkgs, lib, ... }@attrs:

let
  helpers = import ../helpers.nix { inherit lib; };
in with helpers; with lib;
mkPlugin attrs {
  name = "tagbar";
  description = "Enable tagbar";
  extraPlugins = with pkgs.vimExtraPlugins; [
    tagbar
  ];
}
