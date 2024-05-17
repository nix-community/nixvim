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
    fishPackage = helpers.mkPackageOption {
      name = "fish";
      default = pkgs.fish;
    };
  };

  config = mkIf cfg.enable { extraPackages = [ cfg.fishPackage ]; };
}
