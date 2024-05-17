{
  lib,
  helpers,
  config,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.plugins.easyescape;
in
{
  options = {
    plugins.easyescape = {
      enable = mkEnableOption "easyescape";

      package = helpers.mkPluginPackageOption "easyescape" pkgs.vimPlugins.vim-easyescape;
    };
  };
  config = mkIf cfg.enable { extraPlugins = [ cfg.package ]; };
}
