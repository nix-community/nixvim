{ pkgs, config, lib, ... }:
with lib;
let
  cfg = config.programs.nixvim.colorschemes.onedark;
  colors = types.enum [ "bg" "red" "green" "yellow" "blue" "purple" "aqua" "gray" "fg" "bg0_h" "bg0" "bg1" "bg2" "bg3" "bg4" "gray" "orange" "bg0_s" "fg0" "fg1" "fg2" "fg3" "fg4" ];
in {
  options = {
    programs.nixvim.colorschemes.onedark = {
      enable = mkEnableOption "Enable onedark";
    };
  };

  config = mkIf cfg.enable {
    programs.nixvim = {
      colorscheme = "onedark";
      extraPlugins = [ pkgs.vimPlugins.onedark-vim ];
    };
  };
}
