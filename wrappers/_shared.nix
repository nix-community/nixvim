{ lib, ... }:

let
  inherit (lib) mkEnableOption mkOption mkOptionType mkForce mkMerge mkIf types;
in
{
  helpers = mkOption {
    type = mkOptionType {
      name = "helpers";
      description = "Helpers that can be used when writing nixvim configs";
      check = builtins.isAttrs;
    };
    description = "Use this option to access the helpers";
    default = import ../plugins/helpers.nix { inherit (pkgs) lib; };
  };
}
