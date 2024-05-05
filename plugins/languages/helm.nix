{
  lib,
  helpers,
  config,
  pkgs,
  ...
}:
with lib; let
  cfg = config.plugins.helm;
in {
  meta.maintainers = [maintainers.GaetanLepage];

  options.plugins.helm = {
    enable = mkEnableOption "vim-helm";

    package = helpers.mkPackageOption "vim-helm" pkgs.vimPlugins.vim-helm;
  };

  config = mkIf cfg.enable {extraPlugins = [cfg.package];};
}
