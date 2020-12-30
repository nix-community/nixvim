{ pkgs, config, lib, ... }:
with lib;
let
  cfg = config.programs.nixvim.colorschemes.gruvbox;
in {
  options = {
    programs.nixvim.colorschemes.gruvbox = {
      enable = mkEnableOption "Enable gruvbox";
    };
  };

  config = mkIf cfg.enable {
    programs.nixvim = {
      colorscheme = "gruvbox";
      extraPlugins = [ pkgs.vimPlugins.gruvbox ];
    };
  };
}
