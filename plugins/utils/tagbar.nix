{ pkgs, lib, config, ... }@attrs:

let
  helpers = import ../helpers.nix { inherit lib config; };
in with helpers; with lib;
mkPlugin attrs {
  name = "tagbar";
  description = "Enable tagbar";
  extraPlugins = with pkgs.vimExtraPlugins; [
    tagbar
  ];
}
