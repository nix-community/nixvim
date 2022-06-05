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
    };
  };
  config = mkIf cfg.enable {
    extraPlugins = with pkgs.vimPlugins; [
      vim-easyescape
    ];
  };
}
