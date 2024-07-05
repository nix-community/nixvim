helpers:
{ lib, config, ... }:
let
  inherit (lib) mkOption mkOptionType;
  cfg = config.programs.nixvim;
in
{
  helpers = mkOption {
    type = mkOptionType {
      name = "helpers";
      description = "Helpers that can be used when writing nixvim configs";
      check = builtins.isAttrs;
    };
    description = "Use this option to access the helpers";
    default = helpers;
  };

  configFiles =
    (lib.mapAttrs' (_: file: lib.nameValuePair "nvim/${file.path}" { text = file.content; }) cfg.files)
    // (lib.mapAttrs' (
      path: content: lib.nameValuePair "nvim/${path}" { text = content; }
    ) cfg.extraFiles);
}
