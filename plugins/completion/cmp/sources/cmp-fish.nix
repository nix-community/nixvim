{
  lib,
  config,
  pkgs,
  ...
}:
with lib; let
  cfg = config.plugins.cmp-fish;
in {
  meta.maintainers = [maintainers.GaetanLepage];

  options.plugins.cmp-fish = {
    fishPackage = mkOption {
      type = with types; nullOr package;
      default = pkgs.fish;
      example = "null";
      description = ''
        Which package to use for `fish`.
        Set to `null` to disable its automatic installation.
      '';
    };
  };

  config = mkIf cfg.enable {
    extraPackages = [cfg.fishPackage];
  };
}
