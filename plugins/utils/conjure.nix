{
  lib,
  helpers,
  config,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.plugins.conjure;
in
{
  options.plugins.conjure = {
    enable = mkEnableOption "Conjure";

    package = lib.mkPackageOption pkgs "conjure" {
      default = [
        "vimPlugins"
        "conjure"
      ];
    };
  };

  config = mkIf cfg.enable { extraPlugins = [ cfg.package ]; };
}
