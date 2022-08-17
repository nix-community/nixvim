{ pkgs, lib, config, ... }@attrs:

let
  helpers = import ../helpers.nix { inherit lib config; };
in with helpers; with lib;
mkPlugin attrs {
  name = "focus";
  description = "Enable focus.nvim";
  extraPlugins = with pkgs.vimExtraPlugins; [
    focus-nvim
  ];
  extraConfigLua = "require('focus').setup {}";
}
