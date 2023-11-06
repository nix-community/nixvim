{
  lib,
  helpers,
  config,
  pkgs,
  ...
}:
with lib; let
  cfg = config.plugins.easyescape;
in {
  options = {
    plugins.easyescape = {
      enable = mkEnableOption "easyescape";

      package = helpers.mkPackageOption "easyescape" pkgs.vimPlugins.vim-easyescape;
    };
  };
  config = mkIf cfg.enable {
    extraPlugins = [
      cfg.package
    ];
  };
}
