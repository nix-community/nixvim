{
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.plugins.conjure;
  helpers = import ../helpers.nix {inherit lib;};
in {
  options.plugins.conjure = {
    enable = mkEnableOption "Conjure";

    package = helpers.mkPackageOption "conjure" pkgs.vimPlugins.conjure;
  };

  config = mkIf cfg.enable {
    extraPlugins = [cfg.package];
  };
}
