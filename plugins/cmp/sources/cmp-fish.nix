{
  lib,
  config,
  pkgs,
  helpers,
  ...
}:
with lib;
let
  cfg = config.plugins.cmp-fish;
in
{
  meta.maintainers = [ maintainers.GaetanLepage ];

  options.plugins.cmp-fish = {
    fishPackage = lib.mkPackageOption pkgs "fish" {
      nullable = true;
    };
  };

  config = mkIf cfg.enable { extraPackages = [ cfg.fishPackage ]; };
}
