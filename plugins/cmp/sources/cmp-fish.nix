{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.plugins.cmp-fish;
in
{
  meta.maintainers = [ lib.maintainers.GaetanLepage ];

  options.plugins.cmp-fish = {
    fishPackage = lib.mkPackageOption pkgs "fish" {
      nullable = true;
    };
  };

  config = lib.mkIf cfg.enable { extraPackages = [ cfg.fishPackage ]; };
}
