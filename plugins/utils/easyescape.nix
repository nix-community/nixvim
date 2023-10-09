{
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  cfg = config.plugins.easyescape;
  helpers = import ../helpers.nix {inherit lib;};
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
