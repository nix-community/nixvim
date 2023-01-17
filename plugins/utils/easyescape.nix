{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.plugins.easyescape;
  helpers = import ../helpers.nix { inherit lib; };
in
{
  options = {
    plugins.easyescape = {
      enable = mkEnableOption "Enable easyescape";

      package = mkOption {
        type = types.package;
        default = pkgs.vimPlugins.vim-easyescape;
        description = "Plugin to use for easyescape";
      };
    };
  };
  config = mkIf cfg.enable {
    extraPlugins = [
      cfg.package
    ];
  };
}
