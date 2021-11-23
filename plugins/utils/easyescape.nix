{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.programs.nixvim.plugins.easyescape;
  helpers = import ../helpers.nix { inherit lib; };
in 
{
  options = {
    programs.nixvim.plugins.easyescape = {
      enable = mkEnableOption "Enable easyescape";
    };
  };
  config = mkIf cfg.enable {
    programs.nixvim = {
      extraPlugins = with pkgs.vimPlugins; [
        vim-easyescape
      ];
    };
  };
}
